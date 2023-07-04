//
//  ProfileAccountView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/07/2022.
//

import SwiftUI
import FirebaseAuth

struct ProfileAccountView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var currentPassword: String = ""
    @State private var toSeeCurrentPassword: Bool = false
    @State private var toDelete: Bool = false
    
    var body: some View {
        VStack {
            PasswordTextFieldView(password: $currentPassword, toSeePassword: $toSeeCurrentPassword, placeholder: "Password", sfSymbols: "lock")
            
            ActionButtonView(title: "Deleting Account", foreground: .white, background: currentPassword.isEmpty || currentPassword.count < 6 || currentPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .red, sfSymbols: "trash.fill") {
                self.toDelete = true
            }
            .disabled(currentPassword.isEmpty || currentPassword.count < 6 || currentPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.all, 10)
        .alert(isPresented: $toDelete) {
            Alert(title: Text("⚠️ You're about to delete your account ! ⚠️"), message: Text("This operation can't be cancelled \n Are you sure ?"), primaryButton: .destructive(Text("Deleting"), action: {
//                if !sessionService.splitArray.isEmpty {
//                    sessionService.splitDeleteAll(with: Auth.auth().currentUser?.uid ?? "N/A")
//                }
                sessionService.accountDeleting(with: "\(Auth.auth().currentUser!.uid)",  with: currentPassword)
                dismiss()
            }), secondaryButton: .default(Text("Cancel"), action: {
                self.toDelete = false
            }))
        }
    }
}

struct ProfileAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAccountView()
            .environmentObject(SessionServiceImpl())
    }
}
