//
//  LoginView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/03/2022.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var toSeePassword: Bool = false
    
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
                        
                        Text("Login Page")
                            .font(.system(.title, design: .serif).weight(.bold))
                        
                        EmailTextFieldView(email: $email, placeholder: "Email", sfSymbols: "envelope")
                        
                        
                        PasswordTextFieldView(password: $password, toSeePassword: $toSeePassword, placeholder: "Password", sfSymbols: "lock")
                        
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
                    NavigationLink {
                        SplitView()
                    } label: {
                        HStack {
                            Text("Login")
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                        .foregroundColor(.white)
                        .font(.system(.title3, design: .serif).weight(.semibold))
                        .frame(maxWidth: .infinity, maxHeight: 55)
                        .background(.blue)
                        .cornerRadius(7)
                    }
                    
                    
                    
                    //                ActionButtonView(title: "Login", foreground: .white, background: .blue, sfSymbols: "rectangle.portrait.and.arrow.right", handler: {})
                    
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
