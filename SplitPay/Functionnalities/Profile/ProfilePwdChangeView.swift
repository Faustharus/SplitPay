//
//  ProfilePwdChangeView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 31/05/2022.
//

import SwiftUI

struct ProfilePwdChangeView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var email: String = ""
    
    @State private var oldPassword: String = ""
    @State private var toSeeOldPassword: Bool = false
    
    @State private var newPassword: String = ""
    @State private var toSeeNewPassword: Bool = false
    
    var body: some View {
        Text("Profile Password Change View")
        
        InputTextFieldView(text: $email, placeholder: "Email", sfSymbols: "envelope")
        
        PasswordTextFieldView(password: $oldPassword, toSeePassword: $toSeeOldPassword, placeholder: "Old Password", sfSymbols: "lock")
        
        PasswordTextFieldView(password: $newPassword, toSeePassword: $toSeeNewPassword, placeholder: "New Password", sfSymbols: "lock")
        
        ActionButtonView(title: "Confirm New Pwd", foreground: .white, background: oldPassword.isEmpty || newPassword.isEmpty || oldPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || newPassword.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue, sfSymbols: "pencil") {
            sessionService.updatePassword(with: newPassword)
        }
        .disabled(oldPassword.isEmpty || newPassword.isEmpty || oldPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || newPassword.trimmingCharacters(in: .whitespaces).isEmpty)
    }
}

struct ProfilePwdChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePwdChangeView()
            .environmentObject(SessionServiceImpl())
    }
}
