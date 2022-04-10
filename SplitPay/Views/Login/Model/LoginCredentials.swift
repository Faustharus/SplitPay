//
//  LoginCredentials.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
}

extension LoginCredentials {
    
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
    
}
