//
//  SessionUserDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Foundation
import UIKit

struct SessionUserDetails: Hashable {
    var email: String
    var firstName: String
    var surName: String
    var nickName: String
    var extNickName: String
    var picture: UIImage?
    var profilePicture: String
    var withContact: Bool
    //var contacts: [String]?
}
