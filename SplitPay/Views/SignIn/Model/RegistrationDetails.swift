//
//  RegistrationDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Foundation
import SwiftUI

struct RegistrationDetails: Identifiable {
    var id: String = UUID().uuidString
    var email: String
    var password: String
    var confirmPassword: String
    var firstName: String
    var surName: String
    var nickName: String
    var picture: UIImage?
    var profilePicture: String
    var withContact: Bool
}

extension RegistrationDetails {
    
    static var new: RegistrationDetails {
        RegistrationDetails(email: "", password: "", confirmPassword: "", firstName: "", surName: "", nickName: "", picture: nil, profilePicture: "", withContact: false)
    }
    
}
