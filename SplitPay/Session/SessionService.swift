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

enum MessageKeys: String {
    case id
    case message
    case timestamp
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails { get }
    var splitArray: [SessionSplitUserDetails] { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails = SessionUserDetails.init(id: "", email: "", firstName: "", surName: "", nickName: "", extNickName: "", profilePicture: "", withContact: false)
    @Published var userArray: [SessionUserDetails] = []
    @Published var splitArray: [SessionSplitUserDetails] = []
    
    //@Published var userRequestArray: [SessionRequestSent] = []
    //@Published var userRequest: SessionRequestSent = SessionRequestSent.init(userUid: "", confirmation: false, entryDate: Timestamp())
    
    @Published var userTextMessage: String = ""
    //@Published var chatMessage: SessionChatMessageDetails = SessionChatMessageDetails(id: "", fromUid: "", toUid: "", message: "", timestamp: Timestamp(date: .now))
    @Published var chatMessageArray = [SessionChatMessageDetails]()
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    let db = Firestore.firestore()
    
    init() {
        setupFirebaseAuthhandler()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func withOrWithoutContact() {
        self.userDetails.withContact.toggle()
    }
    
    func updatePassword(with newPassword: String) {
        guard let user = Auth.auth().currentUser else { return }
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: newPassword)
        
        user.updatePassword(to: newPassword) { error in
            if error != nil {
                let authErr = AuthErrorCode(rawValue: 300)
                if authErr == .requiresRecentLogin {
                    user.reauthenticate(with: credential)
                }
                print("Some Error occured.. !")
            } else {
                print("Password successfully updated !")
            }
        }
    }
    
    func accountDeleting(with uid: String, with password: String) {
        guard let user = Auth.auth().currentUser else { return }
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
        
        let dbRef = db.collection("users").document(uid)
        let pictureRef = Storage.storage().reference().child("profile").child(uid)
        dbRef.collection("review").getDocuments() { snapshot, error in
            if snapshot!.count > 0 {
                for docSnapshot in snapshot!.documents {
                    docSnapshot.reference.delete { err in
                        if err == nil {
                            DispatchQueue.main.async {
                                self.splitArray.removeAll()
                                pictureRef.delete()
                                self.db.collection("users").document(uid).delete()
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    pictureRef.delete()
                    self.db.collection("users").document(uid).delete()
                }
            }
        }
        
        user.delete { error in
            if error != nil {
                let authErr = AuthErrorCode(rawValue: 300)
                if authErr == .requiresRecentLogin {
                    user.reauthenticate(with: credential)
                }
                print("Some Error Occured...")
            } else {
                print("Account successfully deleted !")
            }
        }
    }
    
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
                    self.splitRefresh(with: uid);
                    self.allUsersRefresh()
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
                    self.userDetails.id = data["id"] as? String ?? "N/A"
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
                self.userDetails = SessionUserDetails(id: self.userDetails.id, email: self.userDetails.email, firstName: self.userDetails.firstName, surName: self.userDetails.surName, nickName: self.userDetails.nickName, extNickName: self.userDetails.extNickName, profilePicture: self.userDetails.profilePicture, withContact: self.userDetails.withContact)
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
    
    func fetchMessages(with fromUid: String, and toUid: String) {
        let fromDocRef = db.collection("messages").document(fromUid).collection(toUid).order(by: "timestamp")
        //let toDocRef = db.collection("messages").document(toUid).collection(fromUid)
        
        fromDocRef.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error detected getting messages: \(error)")
                return
            }
            DispatchQueue.main.async {
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessageArray.append(.init(documentID: change.document.documentID, data: data))
                    }
                })
            }
        }
    }
        
    func allUsersRefresh() {
        guard let user = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").whereField("id", isNotEqualTo: user)
        docRef.getDocuments() { (querySnapshot, error) in
            guard let snapshot = querySnapshot, error == nil else {
                print("No other contacts detected... or simply ERROR !!")
                return
            }
            
            DispatchQueue.main.async {
                self.userArray = snapshot.documents.map { item in
                    if item.documentID != user {
                        return SessionUserDetails(id: item.documentID, email: item["email"] as? String ?? "", firstName: item["firstName"] as? String ?? "", surName: item["surName"] as? String ?? "", nickName: item["nickName"] as? String ?? "", extNickName: item["extNickName"] as? String ?? "", profilePicture: item["profilePicture"] as? String ?? "", withContact: item["withContact"] as? Bool ?? false)
                        
                    } else {
                        return SessionUserDetails(id: "", email: "", firstName: "", surName: "", nickName: "", extNickName: "", profilePicture: "", withContact: false)
                    }
                }
            }
        }
    }
    
}


// MARK: - Friend Req Received
//    func reqReceivedRefresh(with uid: String) {
//        let docRef = db.collection("users").document(uid).collection("requestReceived")
//        docRef.getDocuments() { (querySnapshot, error) in
//            guard let snapshot = querySnapshot, error == nil else {
//                print("Error retrieving Req Sent Detected ... !")
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.userRequestArray = snapshot.documents.map { item in
//                    return SessionRequestSent(userUid: item.documentID, confirmation: item["confirmation"] as? Bool ?? true, entryDate: item["entryDate"] as? Timestamp ?? Timestamp())
//                }
//            }
//        }
//    }


// MARK: - Fetch Messages


//    func fetchMessages() {
//        guard let fromUid = Auth.auth().currentUser?.uid else { return }
//        let toUid = userDetails.id
//        // If docRef exists otherwise Fatal Error !!!
//        let docRef = db.collection("users").document(fromUid).collection(toUid).order(by: "timestamp")
//
//        docRef.addSnapshotListener { querySnapshot, error in
//            if let error = error {
//                print("Error getting messages detected: \(error)")
//                return
//            }
//
//            DispatchQueue.main.async {
//                querySnapshot?.documentChanges.forEach({ change in
//                    if change.type == .added {
//                        self.chatMessage.append(SessionChatDetails(id: change.document.documentID, textMessage: self.userTextMessage, timestamp: Timestamp(date: .now)))
//                    }
//                })
//            }
//
//        }
//    }
