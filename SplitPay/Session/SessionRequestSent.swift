//
//  SessionRequestSent.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 02/11/2022.
//

import Foundation
import FirebaseFirestore

struct SessionRequestSent: Identifiable, Hashable {
    var id: String
    var fromUid: String
    var toUid: String
    var confirmation: Bool
    var timestamp: Timestamp
    
//    var dictionary: [String: Any] {
//        return [
//            "userUid": userUid,
//            "confirmation": confirmation,
//            "entryDate": entryDate
//        ]
//    }
}

//extension SessionRequestSent: DocumentSerializable {
//
//    init(dictionary: [String : Any]) {
//        let userUid = dictionary["userUid"] as? String ?? ""
//        let confirmation = dictionary["confirmation"] as? Bool ?? false
//        let entryDate = dictionary["entryDate"] as? Timestamp ?? Timestamp()
//
//        self.init(userUid: userUid, confirmation: confirmation, entryDate: entryDate)
//    }
//
//}
