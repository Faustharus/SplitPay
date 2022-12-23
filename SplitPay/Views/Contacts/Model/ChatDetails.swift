//
//  ChatDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 08/12/2022.
//

import Foundation

struct ChatDetails: Identifiable {
    
    var id: String
    var fromUid: String
    var toUid: String
    var message: String
    var timestamp: Date
    
}

extension ChatDetails {
    
    static var new: ChatDetails = ChatDetails(id: "", fromUid: "", toUid: "", message: "", timestamp: Date())
    
}
