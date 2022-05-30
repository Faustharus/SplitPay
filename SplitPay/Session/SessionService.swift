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
    
    init() {
        setupFirebaseAuthhandler()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func withOrWithoutContact() {
        self.userDetails.withContact.toggle()
    }
    
    func updateProfile(with uid: String) {
        let profileRef = db.collection("users").document(uid)
        profileRef.updateData([
            "firstName": userDetails.firstName,
            "surName": userDetails.surName
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateProfilePicture(with uid: String, with details: SessionUserDetails) {
        
        guard let imageSelected = details.picture else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://splitpay-6dc17.appspot.com")
        let storageProfileRef = storageRef.child("profile").child("\(uid)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageProfileRef.putData(imageData, metadata: metadata, completion: {
            (storageMetaData, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
                return
            }
            
            storageProfileRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    self.userDetails.profilePicture = metaImageUrl
                    
                    let pictureRef = self.db.collection("users").document(uid)
                    pictureRef.updateData([
                        "profilePicture": metaImageUrl
                    ]) { error in
                        if let error = error {
                            print("Error uploading picture: \(error)")
                        } else {
                            print("Picture successfully uploaded")
                        }
                    }
                    
                }
            }
        })
    }
    
    func splitDelete(with uid: String, with details: SessionSplitUserDetails) {
        db.collection("users").document(uid).collection("review").document(details.id).delete { error in
            if error == nil {
                DispatchQueue.main.async {
                    withAnimation(.spring()) {
                        self.splitArray.removeAll { item in
                            return item.id == details.id
                        }
                    }
                }
            }
        }
    }
    
    func splitDeleteAll(with uid: String) {
        let docRf = db.collection("users").document(uid).collection("review")
        docRf.getDocuments() { (querySnapshot, error) in
            for docSnapshot in querySnapshot!.documents {
                docSnapshot.reference.delete { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            withAnimation(.spring()) {
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
        handler = Auth
            .auth()
            .addStateDidChangeListener({ [weak self] res, user in
                guard let self = self else { return }
                self.state = user == nil ? .loggedOut : .loggedIn
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
        let docRef = db.collection("users").document(uid).collection("review")
        docRef.getDocuments() { (querySnapshot, error) in
            guard let snapshot = querySnapshot, error == nil else {
                print("Error detected ...")
                return
            }
            DispatchQueue.main.async {
                //self.splitArray = snapshot.documents.compactMap { SessionSplitUserDetails(dictionary: $0.data()) }
                self.splitArray = snapshot.documents.map { item in
                    return SessionSplitUserDetails(id: item.documentID, initialAmount: item["initialAmount"] as? Double ?? 0.00, percentages: item["percentages"] as? Int ?? 0, currencyCode: item["currencyCode"] as? String ?? "", indexOfPersons: item["indexOfPersons"] as? Int ?? 0, splitedAmount: item["splitedAmount"] as? Double ?? 0.00, entryDate: item["entryDate"] as? Timestamp ?? Timestamp())
                }
            }
        }
    }
    
}
