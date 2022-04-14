//
//  SessionUserDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Foundation

struct SessionUserDetails: Hashable {
    var email: String
    var firstName: String
    var surName: String
    var nickName: String
    var extNickName: Int
    var profilePicture: String
    //var contacts: [String]?
}
