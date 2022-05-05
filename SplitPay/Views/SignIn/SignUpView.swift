//
//  SignUpView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/03/2022.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var vm = RegistrationViewModelImpl(service: RegistrationServiceImpl())
    
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
    @State private var toSeePassword: Bool = false
    @State private var toSeeConfirmPassword: Bool = false
    @State private var nextForm: Bool = false
    
    @Binding var changePage: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color.white], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                if !nextForm {
                    firstPage
                } else {
                    secondPage
                }
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

// MARK: - View Components
extension SignUpView {
    
    private var firstPage: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                Text("SignUp Page")
                    .font(.system(.title, design: .serif).weight(.bold))
                
                EmailTextFieldView(email: $vm.userDetails.email, placeholder: "Email", sfSymbols: "envelope")
                
                PasswordTextFieldView(password: $vm.userDetails.password, toSeePassword: $toSeePassword, placeholder: "Password", sfSymbols: "lock")
                
                PasswordTextFieldView(password: $vm.userDetails.password, toSeePassword: $toSeeConfirmPassword, placeholder: "Confirm Password", sfSymbols: "lock")
            }
            
            ActionButtonView(title: "Continue", foreground: .white, background: .blue, sfSymbols: "rectangle.portrait.and.arrow.right") {
                nextForm = true
            }
            
            ActionButtonView(title: "Reset", foreground: .white, background: .red, sfSymbols: "trash") {
                resetFirstPage()
            }
            
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
    
    private var secondPage: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                InputTextFieldView(text: $vm.userDetails.nickName, placeholder: "Nickname", sfSymbols: "person")
                
                InputTextFieldView(text: $vm.userDetails.firstName, placeholder: "First Name", sfSymbols: "person")
                
                InputTextFieldView(text: $vm.userDetails.surName, placeholder: "Surname", sfSymbols: "person")
            }
            ActionButtonView(title: "Back", foreground: .white, background: .blue, sfSymbols: "arrow.left") {
                nextForm = false
            }
            
            ActionButtonView(title: "Reset", foreground: .white, background: .red, sfSymbols: "trash") {
                resetSecondPage()
            }
            
            Spacer().frame(height: 50)
            
            ActionButtonView(title: "SignUp", foreground: .white, background: .green, sfSymbols: "checkmark", handler: {
                vm.register()
            })
        }
        .padding(.horizontal, 10)
    }
    
}


// MARK: - Functions
extension SignUpView {
    
    func resetFirstPage() {
        vm.userDetails.email = ""
        vm.userDetails.password = ""
    }
    
    func resetSecondPage() {
        vm.userDetails.nickName = ""
        vm.userDetails.firstName = ""
        vm.userDetails.surName = ""
    }
    
}
