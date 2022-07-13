//
//  SessionService.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails { get }
    var splitArray: [SessionSplitUserDetails] { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails = SessionUserDetails.init(email: "", firstName: "", surName: "", nickName: "", extNickName: "", profilePicture: "", withContact: false)
    @Published var splitArray: [SessionSplitUserDetails] = []
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    let db = Firestore.firestore()
    //let user = Auth.auth().currentUser
    //var credential: AuthCredential
    //var credentials = EmailAuthProvider.credential(withEmail: user!.email!, password: "")
    
    init() {
        setupFirebaseAuthhandler()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func withOrWithoutContact() {
        self.userDetails.withContact.toggle()
    }
    
//    func reauthenticating(with currentEmail: String, with oldPassword: String) {
//        guard let user = Auth.auth().currentUser else { return }
//        var credential: AuthCredential
//        let emailCred = EmailAuthProvider.credential(withEmail: currentEmail, password: oldPassword)
//
//        user.reauthenticate(with: emailCred, completion: {
//            [weak self] (result, error) in
//            if let err = error {
//                print("Error detected: \(err)")
//            } else {
//                // TODO: More Code Later
//            }
//        })
//    }
    
//    func updatePassword(with newPassword: String) {
//        guard let user = Auth.auth().currentUser else { return }
//
//        user.updatePassword(to: newPassword) { error in
//            if error == nil {
//                print("Current User Password Changed !")
//            } else {
//                guard let errorCode = AuthErrorCode(rawValue: 3600) else { return }
//
//                if errorCode == AuthErrorCode.requiresRecentLogin {
//                    //let loginView = LoginView(changePage: .constant(false))
//                }
//            }
//        }
//    }
    
    func updatePassword(with newPassword: String) {
        guard let user = Auth.auth().currentUser else { return }
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: newPassword)
        
        user.updatePassword(to: newPassword) { error in
            if error != nil {
                let authErr = AuthErrorCode(rawValue: 3600)
                if authErr == .requiresRecentLogin {
                    user.reauthenticate(with: credential)
                }
                print("Some Error occured.. !")
            } else {
                print("Password successfully updated !")
            }
        }
    }
    
/*    func updatePassword(with email: String, with oldPassword: String, with newPassword: String) {
        let credentials = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        Auth
            .auth()
            .signIn(with: credentials) { res, error in
                if error != nil {
                    print("Error detected ...")
                } else {
                    print("You're reconnected !")
                }
            }
        user!.reauthenticate(with: credentials) { error, _ in
            if error != nil {
                print("Something wrong occured ...")
            } else {
                self.user!.updatePassword(to: newPassword) { (error) in
                    if error != nil {
                        print("Password not updated")
                    } else {
                        print("Password successfully updated")
                    }
                }
            }
        }
    }*/
    
//    func updatePassword(with password: String) {
//        let user = Auth.auth().currentUser
//        let credentials = EmailAuthProvider.credential(withEmail: userDetails.email, password: password)
//
//        user?.reauthenticate(with: credentials) { error, _ in
//            if error != nil {
//                print("Data Successfully Updated")
//            } else {
//                print("Error detected: \(String(describing: error))")
//            }
//        }
//    }
    
//    func updatePassword(with email: String, with password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
//            if let err = error {
//                print("Error detected: \(err)")
//            } else {
//                print("Credentials Valid !")
//                self.user?.reauthenticate(with: self.credentials!) { error, _ in
//                    if error != nil {
//                        print("Something went wrong !")
//                    } else {
//                        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
//                            if error != nil {
//                                print("Something wrong happened again...")
//                            } else {
//                                print("Password successfully updated !")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    func updatePassword(with password: String) {
//        if let credentials = credentials {
//            user?.reauthenticate(with: credentials) { error, _ in
//                if error != nil {
//                    print("Something wrong occur...")
//                } else {
//                    Auth.auth().currentUser?.updatePassword(to: password) { (error) in
//                        if error != nil {
//                            print("Something wrong happened again...")
//                        } else {
//                            print("Password successfully updated !")
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func updateProfile(with uid: String, with details: SessionUserDetails) {
        
        // Check if there is any image selected
        guard let imageSelected = details.picture else {
            print("Avatar is nil")
            return
        }
        // Set the compression quality of the image for storing
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        // Define the link reference on where to store images
        let storageRef = Storage.storage().reference(forURL: "gs://splitpay-6dc17.appspot.com")
        // Set up the file and the name for the profile image stored
        let storageProfileRef = storageRef.child("profile").child("\(uid)") /* Later : let uid as a file and put another child named "imageProfile" */
        
        // Define the storage of the metadata and the type of image stored
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Store the imageProfile and it's metadata
        storageProfileRef.putData(imageData, metadata: metadata, completion: {
            (storageMetaData, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
                return
            }
            
            // Set the url from where the image can be downloaded by converting it as a String
            storageProfileRef.downloadURL { [weak self] (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    self!.userDetails.profilePicture = metaImageUrl
                    // Get the document of whom is currently connected
                    let profileRef = self!.db.collection("users").document(uid)
                    // Update the data, if anything is altered
                    profileRef.updateData([
                        "firstName": self!.userDetails.firstName,
                        "surName": self!.userDetails.surName,
                        "profilePicture": metaImageUrl
                    ]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
        })
    }
    
    func splitDelete(with uid: String, with details: SessionSplitUserDetails) {
        // Get the selected document through it's id for deleting
        db.collection("users").document(uid).collection("review").document(details.id).delete { error in
            if error == nil {
                // Dispatch it on the main thread
                DispatchQueue.main.async {
                    withAnimation(.spring()) {
                        // If the doc's id is the same as the one on the DB
                        self.splitArray.removeAll { item in
                            // Remove it from the UI
                            return item.id == details.id
                        }
                    }
                }
            }
        }
    }
    
    func splitDeleteAll(with uid: String) {
        // Get the Collection "review"
        let docRf = db.collection("users").document(uid).collection("review")
        docRf.getDocuments() { (querySnapshot, error) in
            // For all documents in "review"
            for docSnapshot in querySnapshot!.documents {
                // Retrieve the reference for deleting on the DB
                docSnapshot.reference.delete { error in
                    if error == nil {
                        // Dispatch the deleting on the main thread
                        DispatchQueue.main.async {
                            withAnimation(.spring()) {
                                // Remove everything from the UI
                                self.splitArray.removeAll()
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension SessionServiceImpl {
    
    func setupFirebaseAuthhandler() {
        // Listen for any change in Authentication
        handler = Auth
            .auth()
            .addStateDidChangeListener({ [weak self] res, user in
                guard let self = self else { return }
                // if "state" is nil means the user is loggedOut, otherwise he's loggedIn
                self.state = user == nil ? .loggedOut : .loggedIn
                // If user is loggedIn - Display "handleRefresh" and "SplitRefresh"
                if let uid = user?.uid {
                    self.handleRefresh(with: uid);
                    self.splitRefresh(with: uid)
                }
            })
    }
    
    func handleRefresh(with uid: String) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error Detected: ", error ?? "Unknown Error")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("This is the expected Data: \(data)")
                    self.userDetails.email = data["email"] as? String ?? "N/A"
                    self.userDetails.firstName = data["firstName"] as? String ?? "N/A"
                    self.userDetails.surName = data["surName"] as? String ?? "N/A"
                    self.userDetails.nickName = data["nickName"] as? String ?? "N/A"
                    self.userDetails.extNickName = data["extNickName"] as? String ?? "N/A"
                    self.userDetails.profilePicture = data["profilePicture"] as? String ?? "N/A"
                    self.userDetails.withContact = data["withContact"] as? Bool ?? false // Need to be modified reguarlely if necessary
                }
            }
            
            DispatchQueue.main.async {
                self.userDetails = SessionUserDetails(email: self.userDetails.email, firstName: self.userDetails.firstName, surName: self.userDetails.surName, nickName: self.userDetails.nickName, extNickName: self.userDetails.extNickName, profilePicture: self.userDetails.profilePicture, withContact: self.userDetails.withContact)
            }
        }
    }
    
    func splitRefresh(with uid: String) {
        // Get the Collection named "review"
        let docRef = db.collection("users").document(uid).collection("review")
        // Get all stored documents
        docRef.getDocuments() { (querySnapshot, error) in
            // If empty, sets an error on the console
            guard let snapshot = querySnapshot, error == nil else {
                print("Error detected ...")
                return
            }
            // Dispatch the request on the main thread asynchronously
            DispatchQueue.main.async {
                self.splitArray = snapshot.documents.map { item in
                    // Correctly return each split in the correct format in "splitArray" Array
                    return SessionSplitUserDetails(id: item.documentID, initialAmount: item["initialAmount"] as? Double ?? 0.00, percentages: item["percentages"] as? Int ?? 0, currencyCode: item["currencyCode"] as? String ?? "", indexOfPersons: item["indexOfPersons"] as? Int ?? 0, splitedAmount: item["splitedAmount"] as? Double ?? 0.00, entryDate: item["entryDate"] as? Timestamp ?? Timestamp())
                }
            }
        }
    }
    
}
