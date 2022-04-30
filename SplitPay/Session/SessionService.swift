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
import SwiftUI

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails = SessionUserDetails.init(email: "", firstName: "", surName: "", nickName: "", extNickName: 0000, profilePicture: "", withContact: false)
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
                    self.userDetails.extNickName = data["extNickName"] as? Int ?? 0000
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
                self.splitArray = snapshot.documents.compactMap { SessionSplitUserDetails(dictionary: $0.data()) }
            }
        }
    }
    
}
