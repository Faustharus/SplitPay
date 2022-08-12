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
    @State private var forgotPassword: Bool = false
    
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
                                self.forgotPassword = true
                            } label: {
                                Text("Forgot Password ? ")
                                    .font(.headline)
                            }
                            .sheet(isPresented: $forgotPassword) {
                                ForgotPasswordView()
                            }
                        }
                        
                    }
                    
                    
                    ActionButtonView(title: "Login", foreground: .white, background: vm.credentials.email.isEmpty || vm.credentials.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.credentials.password.isEmpty || vm.credentials.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue, sfSymbols: "rectangle.portrait.and.arrow.right") {
                        vm.login()
                    }
                    .disabled(vm.credentials.email.isEmpty || vm.credentials.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.credentials.password.isEmpty || vm.credentials.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    ActionButtonView(title: "Reset", foreground: .white, background: .red, sfSymbols: "trash") {
                        reset()
                    }
                    
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

// MARK: - Functions
extension LoginView {
    
    func reset() {
        email = ""
        password = ""
    }
    
}
