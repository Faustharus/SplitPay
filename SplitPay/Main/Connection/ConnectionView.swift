//
//  ConnectionView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 03/05/2023.
//

import SwiftUI
import RegexBuilder

enum InputLoginActive: Hashable {
    case email, password
}

struct ConnectionView: View {
    
    @StateObject private var vm = LoginViewModelImpl(service: LoginServiceImpl())
    
    @State private var toSeePassword: Bool = false
    @State private var forgotPassword: Bool = false
    
    @State private var tapButton: Bool = false
    
    @Binding var changePage: Bool
    
    @FocusState var inputsActive: InputLoginActive?
    
    // MARK: - New Login View
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    LinearGradient(colors: [Color(red: 0.2, green: 0, blue: 1).opacity(1), Color(red: 0.4, green: 0, blue: 1).opacity(0.8), Color(red: 0.3, green: 0, blue: 0.6).opacity(0.6), Color(red: 0.6, green: 0, blue: 0.8).opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                    
                    ScrollView {
                        Image("dollarIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.25)
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.black.opacity(0.6).shadow(.inner(color: .white.opacity(0.4), radius: 5, x: 2, y: 2)))
                                .frame(width: 350, height: 480)
                                .padding()
                            
                            VStack(alignment: .leading) {
                                Text("Login")
                                    .font(.system(size: 24, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                
                                Spacer().frame(height: 24)
                                
                                MailTextFieldView(email: $vm.credentials.email, placeholder: "", sfSymbols: "envelope", width: 310, height: 60)
                                    .focused($inputsActive, equals: .email)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            if inputsActive == .email {
                                                Button {
                                                    self.vm.credentials.email = ""
                                                } label: {
                                                    Text("Reset")
                                                }
                                            }
                                        }
                                    }
                                
                                Spacer().frame(height: 8)
                                
                                
                                SecureTextFieldView(password: $vm.credentials.password, toSeePassword: $toSeePassword, placeholder: "********", sfSymbols: "lock", width: 310, height: 60)
                                    .focused($inputsActive, equals: .password)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            if inputsActive == .password {
                                                Button {
                                                    self.vm.credentials.password = ""
                                                } label: {
                                                    Text("Reset")
                                                }
                                            }
                                        }
                                    }
                                
                                Spacer().frame(height: 8)
                                
                                HStack {
                                    Text("Remember me ?")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer().frame(width: 50)
                                    
                                    Button {
                                        self.forgotPassword = true
                                    } label: {
                                        Text("Forgot Password")
                                            .bold()
                                            .underline()
                                    }
                                    .sheet(isPresented: $forgotPassword) {
                                        ForgotPasswordView()
                                    }
                                }
                                .frame(height: 24)
                                    
                                Spacer().frame(height: 16)
                                    
                                    
                                VStack {
                                    ButtonActionView(tapButton: $tapButton, title: "Login", foreground: .black, background: [.blue, .purple], sfSymbols: "rectangle.portrait.and.arrow.right", width: 310, height: 45) {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation {
                                                tapButton = false
                                            }
                                        }
                                        withAnimation {
                                            tapButton = true
                                        }
                                        if checkValidEmail(newValue: vm.credentials.email) {
                                            vm.login()
                                        }
                                    }
                                    .disabled(vm.credentials.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.credentials.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    
                                    Spacer().frame(height: 24)
                                    
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.005)
                                        .offset(x: 0, y: 0)
                                    
                                    Spacer().frame(height: 16)
                                    
                                    HStack {
                                        Text("Don't have an account yet ?")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(" - ")
                                        Button {
                                            changePage.toggle()
                                        } label: {
                                            Text("SignUp")
                                                .bold()
                                                .underline()
                                        }
                                    }
                                }
                            }
                        }
                        .offset(x: 0, y: geo.size.height * 0.07)
                    }
                }
                .alert(isPresented: $vm.hasError, content: {
                    if case .failed(let error) = vm.state {
                        return Alert(title: Text("Your credentials aren't correct"), message: Text("\(error.localizedDescription)"))
                    } else {
                        return Alert(title: Text("Error"), message: Text("Something went wrong"))
                    }
                })
            }
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView(changePage: .constant(false))
    }
}

// MARK: - Regex
extension ConnectionView {
    
    private func checkValidEmail(newValue: String) -> Bool {
        let emailRegex = try! Regex("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z0-9]{2,64}")
        
        do {
            if newValue.contains(emailRegex) {
                print("Email Format Valid")
                return true
            }
        }
        print("Email Format Invalid...")
        return false
    }
    
}
