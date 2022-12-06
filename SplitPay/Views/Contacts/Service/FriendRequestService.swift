//
//  FriendRequestService.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 24/09/2022.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

enum RequestKeys: String {
    case userUid
    case confirmation
    case entryDate
}

protocol FriendRequestService {
    func makeRequest(with details: FriendRequest?) -> AnyPublisher<Void, Error>
    func deleteRequest(with details: FriendRequest?) -> AnyPublisher<Void, Error>
}

final class FriendRequestServiceImpl: FriendRequestService {
    
    func makeRequest(with details: FriendRequest?) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let uid = Auth.auth().currentUser?.uid
                let toUid = details?.id
                
                if let uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).collection("requestSent").document(toUid!).setData([
                        RequestKeys.userUid.rawValue: details?.id ?? "",
                        RequestKeys.entryDate.rawValue: details?.entryDate ?? Timestamp(),
                        RequestKeys.confirmation.rawValue: details?.confirmation ?? true
                    ])
                }
                
                if let toUid {
                    let db = Firestore.firestore()
                    db.collection("users").document(toUid).collection("requestReceived").document(uid!).setData([
                        RequestKeys.userUid.rawValue: uid ?? "",
                        RequestKeys.entryDate.rawValue: details?.entryDate ?? Timestamp(),
                        RequestKeys.confirmation.rawValue: details?.confirmation ?? true
                    ])
                }

            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func deleteRequest(with details: FriendRequest?) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let uid = Auth.auth().currentUser?.uid
                let toUid = details?.id
                
                if let uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).collection("requestSent").document(toUid!).delete { error in
                        if let err = error {
                            print("Error removing document: \(err.localizedDescription)")
                        } else {
                            print("Document Successfully removed !")
                        }
                    }
                }
                
                if let toUid {
                    let db = Firestore.firestore()
                    db.collection("users").document(toUid).collection("requestReceived").document(uid!).delete { error in
                        if let err = error {
                            print("Error removing document: \(err.localizedDescription)")
                        } else {
                            print("Document Successfully removed !")
                        }
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
