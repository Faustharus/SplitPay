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
    case id
    case fromUid
    case toUid
    case confirmation
    case timestamp
}

protocol FriendRequestService {
    func makeRequest(with toUid: String?, with model: FriendRequest?) -> AnyPublisher<Void, Error>
    func deleteRequest(with toUid: String?, with model: FriendRequest?) -> AnyPublisher<Void, Error>
}

final class FriendRequestServiceImpl: FriendRequestService {
    let collectionId = Double.random(in: 0001 ..< 10000)
    
    func makeRequest(with toUid: String?, with model: FriendRequest?) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
//                let fromUid = Auth.auth().currentUser?.uid
//                let toUid = toUid
//
//                if let fromUid {
//                    let db = Firestore.firestore()
//                    //db.collection("friendRequest").document(fromUid).collection(collectionId).document(toUid).setData([String : Any])
//                    db.collection("friendRequest").document(fromUid).collection("\(self.collectionId)").document(toUid!).setData([
//                        RequestKeys.id.rawValue: self.collectionId.description,
//                        RequestKeys.fromUid.rawValue: fromUid,
//                        RequestKeys.toUid.rawValue: toUid!,
//                        RequestKeys.timestamp.rawValue: Timestamp(date: .now),
//                        RequestKeys.confirmation.rawValue: model?.confirmation ?? false
//                    ])
//                    // RequestKeys.confirmation.rawValue: true - Linked with an @Binding or @Published
//                }
//
//                if let toUid {
//                    let db = Firestore.firestore()
//                    //db.collection("friendRequest").document(toUid).collection(collectionId).document(fromUid).setData([String : Any])
//                    db.collection("friendRequest").document(toUid).collection("\(self.collectionId)").document(fromUid!).setData([
//                        RequestKeys.id.rawValue: self.collectionId.description,
//                        RequestKeys.fromUid.rawValue: fromUid!,
//                        RequestKeys.toUid.rawValue: toUid,
//                        RequestKeys.timestamp.rawValue: Timestamp(date: .now),
//                        RequestKeys.confirmation.rawValue: model?.confirmation ?? false
//                    ])
//                    // RequestKeys.confirmation.rawValue: false
//                }

            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func deleteRequest(with toUid: String?, with details: FriendRequest?) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
//                let fromUid = Auth.auth().currentUser?.uid
//                let toUid = toUid
//
//                if let fromUid {
//                    let db = Firestore.firestore()
//                    db.collection("friendRequest").document(fromUid).collection("\(self.collectionId)").document(toUid!).delete { error in
//                        if let err = error {
//                            print("Error removing document: \(err.localizedDescription)")
//                        } else {
//                            print("Document Successfully removed !")
//                        }
//                    }
//                }
//
//                if let toUid {
//                    let db = Firestore.firestore()
//                    db.collection("friendRequest").document(toUid).collection("\(self.collectionId)").document(fromUid!).delete { error in
//                        if let err = error {
//                            print("Error removing document: \(err.localizedDescription)")
//                        } else {
//                            print("Document Successfully removed !")
//                        }
//                    }
//                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
