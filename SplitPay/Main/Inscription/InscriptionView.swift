//
//  InscriptionView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 09/05/2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import RegexBuilder

enum InputSignUpActive {
    case firstName, surName, nickname, email, password, confirmPassword
}

struct InscriptionView: View {
    
    @StateObject private var vm = RegistrationViewModelImpl(service: RegistrationServiceImpl())
    
    @State var onBoardingState: Int = 0
    
    @State private var tapButton: Bool = false
    @State private var tapBackButton: Bool = false
    @State private var tapPicture: Bool = false
    
    @State private var toSeePassword: Bool = false
    @State private var toSeeConfirmPassword: Bool = false
    
    @State private var picture: Image?
    @State private var showingPickerImage: Bool = false
    
    @FocusState var inputsActive: InputSignUpActive?
    
    @Binding var changePage: Bool
    
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
                                Text("SignUp")
                                    .font(.system(size: 24, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                
                                Spacer().frame(height: 24)
                                
                                // MARK: - OnBoarding
                                
                                ZStack {
                                    switch onBoardingState {
                                        case 1:
                                            nicknameAndMail
                                        case 2:
                                            profilPicture
                                        case 3:
                                            passwords
                                        default:
                                            names
                                    }
                                }
                                .onChange(of: vm.userDetails.picture) { _ in loadPicture() }
                                .sheet(isPresented: $showingPickerImage) {
                                    ImagePicker(image: $vm.userDetails.picture)
                                }
                                
                                
                                Spacer().frame(height: 16)
                                
                                VStack {
                                    
                                    HStack {
                                        if onBoardingState > 0 {
                                             // MARK: - Back Button
                                            ChevronButtonActionView(tapButton: $tapBackButton, title: "Back", foreground: .white, background: [Color(red: 0.4, green: 0, blue: 0), Color(red: 0.6, green: 0, blue: 0), Color(red: 0.8, green: 0, blue: 0), Color(red: 1, green: 0, blue: 0)], leftSfSymbols: "chevron.left", rightSfSymbols: "", width: 150, height: 45) {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                    withAnimation {
                                                        tapBackButton = false
                                                    }
                                                }
                                                withAnimation {
                                                    tapBackButton = true
                                                }
                                                // TODO: More Code Later
                                                withAnimation(.spring()) {
                                                    onBoardingState -= 1
                                                }
                                            }
                                        }
                                        
                                        // MARK: - SignUp Button
                                        ChevronButtonActionView(tapButton: $tapButton, title: onBoardingState != 3 ? "Continue" : "SignUp", foreground: .white, background: [Color(red: 0.8, green: 0, blue: 1), Color(red: 0.6, green: 0, blue: 0.8), Color(red: 0.4, green: 0, blue: 0.6), Color(red: 0.2, green: 0, blue: 0.4)], leftSfSymbols: "", rightSfSymbols: "chevron.right", width: onBoardingState > 0 ? 150 : 300, height: 45) {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                withAnimation {
                                                    tapButton = false
                                                }
                                            }
                                            withAnimation {
                                                tapButton = true
                                            }
                                            withAnimation(.spring()) {
                                                if onBoardingState < 3 {
                                                    onBoardingState += 1
                                                }
                                            }
                                            if onBoardingState == 3 {
                                                if checkValidEmail(newValue: vm.userDetails.email) {
                                                    vm.register()
                                                }
                                            }
                                        }
                                        .disabled(onBoardingState == 3 && (vm.userDetails.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.userDetails.surName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.userDetails.nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.userDetails.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || picture == nil || vm.userDetails.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.userDetails.confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) )
                                    }
                                    
                                    Spacer().frame(height: 24)
                                    
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.005)
                                        .offset(x: 0, y: 0)
                                    
                                    Spacer().frame(height: 16)
                                    
                                    HStack {
                                        Text("You've already an account ?")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(" - ")
                                        Button {
                                            changePage.toggle()
                                        } label: {
                                            Text("LogIn")
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
            }
        }
    }
}

struct InscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        InscriptionView(changePage: .constant(false))
    }
}

// MARK: - Regex
extension InscriptionView {
    
    func checkNames(newValue: String) -> Bool {
        let namesRegex = try! Regex("[a-zA-Z.-]{2,64}")
        
        do {
            if newValue.contains(namesRegex) {
                print("First Name and Surname at the correct length")
                return true
            }
        }
        print("Please enter a valid First Name and Surname")
        return false
    }
    
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
    
    func checkPasswordValidity(newValue: String) -> Bool {
        let pwdRegex = try! Regex("\\A(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{11,}\\z")
        
        do {
            if newValue.contains(pwdRegex) {
                print("Password Format Valid")
                return true
            }
        }
        print("Minimum of 11 caracters required")
        return false
    }
    
    
    
}


// MARK: - OnBoarding Views
extension InscriptionView {
    
    private var names: some View {
        VStack {
            InfoTextFieldView(candidateText: $vm.userDetails.firstName, candidateInfo: "First Name", placeholder: "", sfSymbols: "person.crop.circle", width: 310, height: 60)
                .focused($inputsActive, equals: .firstName)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        if !vm.userDetails.firstName.isEmpty && inputsActive == .firstName {
                            Button {
                                self.vm.userDetails.firstName = ""
                            } label: {
                                Text("Reset")
                            }
                        }
                    }
                }
            
            Spacer().frame(height: 8)
            
            InfoTextFieldView(candidateText: $vm.userDetails.surName, candidateInfo: "Last Name", placeholder: "", sfSymbols: "person.crop.circle", width: 310, height: 60)
                .focused($inputsActive, equals: .surName)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        if !vm.userDetails.surName.isEmpty && inputsActive == .surName {
                            Button {
                                self.vm.userDetails.surName = ""
                            } label: {
                                Text("Reset")
                            }
                        }
                    }
                }
            
            Spacer().frame(height: 8)
            
            Text("The first and last name will not be \neditable and will only be visible to \nyour contacts, unless you change \nthe setting.")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium, design: .default))
                .shadow(color: .black, radius: 3, x: 2, y: 2)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var nicknameAndMail: some View {
        VStack {
            InfoTextFieldView(candidateText: $vm.userDetails.nickName, candidateInfo: "Nickname", placeholder: "", sfSymbols: "person.crop.circle", width: 310, height: 60)
                .focused($inputsActive, equals: .nickname)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        if !vm.userDetails.nickName.isEmpty && inputsActive == .nickname {
                            Button {
                                self.vm.userDetails.nickName = ""
                            } label: {
                                Text("Reset")
                            }
                        }
                    }
                }
            
            Spacer().frame(height: 8)
            
            MailTextFieldView(email: $vm.userDetails.email, placeholder: "", sfSymbols: "envelope", width: 310, height: 60)
                .focused($inputsActive, equals: .email)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        if !vm.userDetails.email.isEmpty && inputsActive == .email {
                            Button {
                                self.vm.userDetails.email = ""
                            } label: {
                                Text("Reset")
                            }
                        }
                    }
                }
            
            Spacer().frame(height: 8)
            
            Text("The nickname will be editable and \nvisible to your contacts, unless you \nchange the setting by \nshowing your name.")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium, design: .default))
                .shadow(color: .black, radius: 3, x: 2, y: 2)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var profilPicture: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(.yellow.opacity(0.85).shadow(.drop(color: .white.opacity(0.5), radius: 5, x: 2, y: 2)))
                .frame(width: 310, height: 200)
            VStack {
                PictureButtonView(inputPicture: $vm.userDetails.picture, picture: $picture, tapPicture: $tapPicture) {
                    showingPickerImage = true
                }
                
                Spacer().frame(height: 20)
                
                Text("Add a profil picture which will allow \nyour contacts to recognize you")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .shadow(color: .black, radius: 3, x: 2, y: 2)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    private var passwords: some View {
        VStack {
            SecureTextFieldView(password: $vm.userDetails.password, toSeePassword: $toSeePassword, placeholder: "Password", sfSymbols: "lock", width: 310, height: 60)
                .focused($inputsActive, equals: .password)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        if !vm.userDetails.password.isEmpty && inputsActive == .password {
                            Button {
                                self.vm.userDetails.password = ""
                            } label: {
                                Text("Reset")
                            }
                        }
                    }
                }
            
            Spacer().frame(height: 8)
            
            SecureTextFieldView(password: $vm.userDetails.confirmPassword, toSeePassword: $toSeePassword, placeholder: "Confirm Password", sfSymbols: "lock", width: 310, height: 60)
                .focused($inputsActive, equals: .confirmPassword)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        if !vm.userDetails.confirmPassword.isEmpty && inputsActive == .confirmPassword {
                            Button {
                                self.vm.userDetails.confirmPassword = ""
                            } label: {
                                Text("Reset")
                            }
                        }
                    }
                }
            
            Spacer().frame(height: 8)
            
            Text("By Signing Up, you accept the \nGeneral Terms of Use")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium, design: .default))
                .shadow(color: .black, radius: 3, x: 2, y: 2)
                .multilineTextAlignment(.leading)
        }
    }
    
    func loadPicture() {
        picture = Image(uiImage: vm.userDetails.picture!)
    }
    
}
