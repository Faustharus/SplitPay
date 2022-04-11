//
//  LoginView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/03/2022.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var vm = LoginViewModelImpl(service: LoginServiceImpl())
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var toSeePassword: Bool = false
    
    @Binding var changePage: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color.white], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                VStack(spacing: 16) {
                    VStack(spacing: 16) {
                        
                        Text("Login Page")
                            .font(.system(.title, design: .serif).weight(.bold))
                        
                        EmailTextFieldView(email: $vm.credentials.email, placeholder: "Email", sfSymbols: "envelope")
                        
                        
                        PasswordTextFieldView(password: $vm.credentials.password, toSeePassword: $toSeePassword, placeholder: "Password", sfSymbols: "lock")
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                // TODO: More Code Later
                            } label: {
                                Text("Forgot Password ? ")
                                    .font(.headline)
                            }
                        }
                        
                    }
                    
                    
                    ActionButtonView(title: "Login", foreground: .white, background: .blue, sfSymbols: "rectangle.portrait.and.arrow.right") {
                        vm.login()
                    }
                    
                    ActionButtonView(title: "Reset", foreground: .white, background: .red, sfSymbols: "trash", handler: {})
                    
                    HStack {
                        Text("Don't have an account yet ? -")
                        Button {
                            changePage.toggle()
                        } label: {
                            Text("SignUp")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(changePage: .constant(false))
    }
}
