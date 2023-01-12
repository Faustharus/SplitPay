//
//  FriendRequest.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 24/09/2022.
//

import Foundation

struct FriendRequest: Identifiable, Hashable {
    var id: String
    var fromUid: String
    var toUid: String
    var confirmation: Bool
    var entryDate: Date
}

extension FriendRequest {
    
    static var new: FriendRequest = FriendRequest(id: "", fromUid: "", toUid: "", confirmation: false, entryDate: .now)
    
}
