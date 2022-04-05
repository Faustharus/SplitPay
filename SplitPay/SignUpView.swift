//
//  SignUpView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/03/2022.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var toSeePassword: Bool = false
    @State private var toSeeConfirmPassword: Bool = false
    
    @Binding var changePage: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color.white], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                //            VStack {
                //                Image(systemName: "chevron.up")
                //                    .resizable()
                //                    .scaledToFit()
                //                    .frame(width: 50)
                //                    .font(.system(.headline, design: .rounded).weight(.thin))
                //                    .shadow(color: .black, radius: 3, x: 0, y: 7)
                //                    .background()
                //                    .padding(.top, 5)
                //                
                //                Spacer()
                //            }
                
                VStack(spacing: 16) {
                    VStack(spacing: 16) {
                        Text("SignUp Page")
                            .font(.system(.title, design: .serif).weight(.bold))
                        
                        EmailTextFieldView(email: $email, placeholder: "Email", sfSymbols: "envelope")
                        
                        PasswordTextFieldView(password: $password, toSeePassword: $toSeePassword, placeholder: "Password", sfSymbols: "lock")
                        
                        PasswordTextFieldView(password: $confirmPassword, toSeePassword: $toSeeConfirmPassword, placeholder: "Confirm Password", sfSymbols: "lock")
                    }
                    
                    ActionButtonView(title: "SignUp", foreground: .white, background: .blue, sfSymbols: "rectangle.portrait.and.arrow.right", handler: {})
                    
                    ActionButtonView(title: "Reset", foreground: .white, background: .red, sfSymbols: "trash", handler: {})
                    
                    HStack {
                        Text("Already have an account ? -")
                        Button {
                            changePage.toggle()
                        } label: {
                            Text("LogIn")
                        }
                    }
                    .font(.headline)
                }
                .padding(.horizontal, 10)
            }
            .navigationBarHidden(true)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(changePage: .constant(false))
    }
}
