//
//  ChatDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 08/12/2022.
//

import Foundation

struct ChatDetails: Identifiable {
    
    var id: String { documentID }
    var documentID: String
    var fromUid: String
    var toUid: String
    var message: String
    var timestamp: Date
    
}

extension ChatDetails {
    
    static var new: ChatDetails = ChatDetails(documentID: "", fromUid: "", toUid: "", message: "", timestamp: Date())
    
}
