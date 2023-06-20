//
//  ForgotPasswordView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 05/05/2022.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = ForgotPasswordViewModelImpl(service: ForgotPasswordServiceImpl())
    
    @State private var tapButton: Bool = false
    @State private var tapBackButton: Bool = false
    
    @State private var raiseAlert: Bool = false
    
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
                            .padding(.top, geo.size.height * 0.03)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.black.opacity(0.6).shadow(.inner(color: .white.opacity(0.4), radius: 5, x: 2, y: 2)))
                                .frame(width: 350, height: 480)
                                .padding()
                            
                            VStack(alignment: .leading) {
                                Text("Forgot Password")
                                    .font(.system(size: 24, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                
                                Spacer().frame(height: 24)
                                
                                MailTextFieldView(email: $vm.email, placeholder: "", sfSymbols: "envelope", width: 310, height: 60)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            if !vm.email.isEmpty {
                                                Button {
                                                    self.vm.email = ""
                                                } label: {
                                                    Text("Reset")
                                                }
                                            }
                                        }
                                    }
                                
                                Spacer().frame(height: 40)
                                
                                ButtonActionView(tapButton: $tapButton, title: "Send Password", foreground: .black, background: [.blue, .purple], sfSymbols: "rectangle.portrait.and.arrow.right", width: 310, height: 45) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        withAnimation {
                                            tapButton = false
                                        }
                                    }
                                    withAnimation {
                                        tapButton = true
                                    }
                                    raiseAlert = true
                                    if checkValidEmail(newValue: vm.email) {
                                        vm.sendPasswordReset()
                                    }
                                }
                                .disabled(vm.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                
                                Spacer().frame(height: 16)
                                
                                ChevronButtonActionView(tapButton: $tapBackButton, title: "Back", foreground: .white, background: [.red.opacity(0.9), .red.opacity(0.6), .red.opacity(0.3)], leftSfSymbols: "chevron.left", rightSfSymbols: "", width: 310, height: 45) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        withAnimation {
                                            tapBackButton = false
                                        }
                                    }
                                    withAnimation {
                                        tapBackButton = true
                                    }
                                    self.dismiss()
                                }
                            }
                        }
                    }
                }
                .alert(isPresented: $raiseAlert, content: {
                    if checkValidEmail(newValue: vm.email) {
                        return Alert(title: Text("Lost Password Request Sent"), message: Text("If you do have an account, you should see the request in your mail box - Check your Spam Inbox"), dismissButton: .default(Text("OK"), action: {
                            raiseAlert = false
                        }))
                    } else {
                        return Alert(title: Text("Email Format Invalid"), message: Text("The format of your email is incorrect"), dismissButton: .default(Text("OK"), action: {
                            raiseAlert = false
                        }))
                    }
                })
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

// MARK: - Regex
extension ForgotPasswordView {
    
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
