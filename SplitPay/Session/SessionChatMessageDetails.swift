//
//  SessionChatMessageDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 07/12/2022.
//

import Foundation
import FirebaseFirestore

struct SessionChatMessageDetails: Identifiable, Hashable {
    
    var id: String { documentID }
    var documentID: String
    var fromUid: String
    var toUid: String
    var message: String
    var timestamp: Timestamp
    
    init(documentID: String, data: [String: Any]) {
        self.documentID = documentID
        self.fromUid = data["fromUid"] as? String ?? ""
        self.toUid = data["toUid"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
    
//    var id: String { documentId }
//
//    let documentId: String
//
//    let fromUid: String
//    let toUid: String
//    let message: String
//    var timestamp: Timestamp
//
//    init(documentId: String, data: [String: Any]) {
//        self.documentId = documentId
//        self.fromUid = data["fromUid"] as? String ?? ""
//        self.toUid = data["toUid"] as? String ?? ""
//        self.message = data["message"] as? String ?? ""
//        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
//    }
    
}
