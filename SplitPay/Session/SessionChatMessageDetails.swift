//
//  SessionChatMessageDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 07/12/2022.
//

import Foundation
import FirebaseFirestore

struct SessionChatMessageDetails: Identifiable, Hashable {
    var id: String
    var fromUid: String
    var toUid: String
    var message: String
    var timestamp: Timestamp
}
