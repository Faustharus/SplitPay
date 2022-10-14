//
//  FriendRequest.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 24/09/2022.
//

import Foundation
import SwiftUI

struct FriendRequest: Hashable {
    var id: String
    var requestType: String
    var isSent: Bool
}

extension FriendRequest {
    
    static var new: FriendRequest = FriendRequest(id: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F", requestType: "Sent", isSent: false)
    
}
