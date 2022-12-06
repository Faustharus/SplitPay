//
//  SessionRequestSent.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 02/11/2022.
//

import Foundation
import FirebaseFirestore

struct SessionRequestSent: Hashable {
    var userUid: String
    var confirmation: Bool
    var entryDate: Timestamp
    //var requestType: String
    //var whenIsSent: Timestamp
    
    var dictionary: [String: Any] {
        return [
            "userUid": userUid,
            "confirmation": confirmation,
            "entryDate": entryDate
        ]
    }
}

extension SessionRequestSent: DocumentSerializable {
    
    init(dictionary: [String : Any]) {
        let userUid = dictionary["userUid"] as? String ?? ""
        let confirmation = dictionary["confirmation"] as? Bool ?? false
        let entryDate = dictionary["entryDate"] as? Timestamp ?? Timestamp()

        self.init(userUid: userUid, confirmation: confirmation, entryDate: entryDate)
    }
    
}
