//
//  RegistrationDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Foundation
import SwiftUI

struct RegistrationDetails {
    var email: String
    var password: String
    var firstName: String
    var surName: String
    var nickName: String
    var picture: UIImage?
    var profilePicture: String
    var withoutContact: Bool
}

extension RegistrationDetails {
    
    static var new: RegistrationDetails {
        RegistrationDetails(email: "", password: "", firstName: "", surName: "", nickName: "", picture: nil, profilePicture: "", withoutContact: false)
    }
    
}
