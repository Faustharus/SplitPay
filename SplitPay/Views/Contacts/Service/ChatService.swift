//
//  ChatService.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 08/12/2022.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

enum ChatKeys: String {
    case id
    case fromUid
    case toUid
    case message
    case timestamp
}

protocol ChatService {
    func sendMessage(with toUid: String?, and model: ChatDetails) -> AnyPublisher<Void, Error>
    func lastMessage(with toUid: String?, and model: ChatDetails) -> AnyPublisher<Void, Error>
}

final class ChatServiceImpl: ChatService {
    // MARK: - sendMessage Func
    func sendMessage(with toUid: String?, and model: ChatDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let fromUid = Auth.auth().currentUser?.uid
                let toUid = toUid
                
                if let fromUid {
                    let db = Firestore.firestore().collection("messages").document(fromUid).collection(toUid!).document()
                    db.setData([
                        ChatKeys.id.rawValue: db.documentID,
                        ChatKeys.fromUid.rawValue: fromUid,
                        ChatKeys.toUid.rawValue: toUid!,
                        ChatKeys.message.rawValue: model.message,
                        ChatKeys.timestamp.rawValue: Timestamp(date: Date.now)
                    ]) { error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "Invalid Entered Message Data", code: 3, userInfo: nil)))
                }
                
                if let toUid {
                    let db = Firestore.firestore().collection("messages").document(toUid).collection(fromUid!).document()
                    db.setData([
                        ChatKeys.id.rawValue: db.documentID,
                        ChatKeys.fromUid.rawValue: fromUid!,
                        ChatKeys.toUid.rawValue: toUid,
                        ChatKeys.message.rawValue: model.message,
                        ChatKeys.timestamp.rawValue: Timestamp(date: Date.now)
                    ]) { error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "Invalid Received Message Data", code: 4, userInfo: nil)))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    
    
    
    // MARK: - lastMessage Func
    func lastMessage(with toUid: String?, and model: ChatDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let fromUid = Auth.auth().currentUser?.uid
                let toUid = toUid
                
                if let fromUid {
                    let db = Firestore.firestore().collection("users").document(fromUid).collection("lastMessage").document(toUid!)
                    db.setData([
                        ChatKeys.id.rawValue: toUid!,
                        ChatKeys.fromUid.rawValue: fromUid,
                        ChatKeys.toUid.rawValue: toUid!,
                        ChatKeys.message.rawValue: model.message,
                        ChatKeys.timestamp.rawValue: Timestamp(date: Date.now)
                    ]) { error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "Invalid Last Entered Message Data", code: 13, userInfo: nil)))
                }
                
                if let toUid {
                    let db = Firestore.firestore().collection("users").document(toUid).collection("lastMessage").document(fromUid!)
                    db.setData([
                        ChatKeys.id.rawValue: fromUid!,
                        ChatKeys.fromUid.rawValue: fromUid!,
                        ChatKeys.toUid.rawValue: toUid,
                        ChatKeys.message.rawValue: model.message,
                        ChatKeys.timestamp.rawValue: Timestamp(date: Date.now)
                    ]) { error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "Invalid Last Received Message Data", code: 14, userInfo: nil)))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
