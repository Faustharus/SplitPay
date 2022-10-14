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

enum RequestKeys: String { // This is probably useless by now
    case userUid
    //case requestType
    //case firstName
    //case confirmation
}

protocol FriendRequestService {
    func makeRequest(with userUID: String) -> AnyPublisher<Void, Error>
}

final class FriendRequestServiceImpl: FriendRequestService {
    
    func makeRequest(with userUID: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                if let uid = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).updateData([
                        "requestSent": FieldValue.arrayUnion([
                            userUID
                        ])
                    ])
                } else {
                    promise(.failure(NSError(domain: "Error Sending Friend Request", code: 9, userInfo: nil)))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
}
