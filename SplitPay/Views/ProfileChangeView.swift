//
//  ProfileChangeView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 27/05/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileChangeView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @Environment(\.dismiss) var dismiss
    
    @State private var picture: Image?
    @State private var showingPickerImage: Bool = false
    
    var body: some View {
        VStack {
            Text("Test Profile Updating View")
            InputTextFieldView(text: $sessionService.userDetails.firstName, placeholder: "\(sessionService.userDetails.firstName)", sfSymbols: "1.circle")
            InputTextFieldView(text: $sessionService.userDetails.surName, placeholder: "\(sessionService.userDetails.surName)", sfSymbols: "2.circle")
            PictureProfileView(inputPicture: $sessionService.userDetails.picture, picture: $picture) {
                showingPickerImage = true
            }

            
            ActionButtonView(title: "Confirm Change", foreground: .white, background: sessionService.userDetails.firstName.isEmpty || sessionService.userDetails.surName.isEmpty ? .gray : .green, sfSymbols: "checkmark.shield") {
                sessionService.updateProfile(with: Auth.auth().currentUser!.uid)
                sessionService.updateProfilePicture(with: Auth.auth().currentUser!.uid, with: sessionService.userDetails)
            }
            .disabled(sessionService.userDetails.firstName.isEmpty || sessionService.userDetails.surName.isEmpty)
            
            ActionButtonView(title: "Back", foreground: .white, background: .blue, sfSymbols: "chevron.backward") {
                self.dismiss()
                
            }
        }
        .interactiveDismissDisabled()
        .onChange(of: sessionService.userDetails.picture) { _ in loadPicture() }
        .sheet(isPresented: $showingPickerImage) {
            ImagePicker(image: $sessionService.userDetails.picture)
        }
        .padding(.horizontal, 15)
    }
}

struct ProfileChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileChangeView()
            .environmentObject(SessionServiceImpl())
    }
}

// MARK: - Functions
extension ProfileChangeView {
    
    func loadPicture() {
        picture = Image(uiImage: sessionService.userDetails.picture!)
    }
    
}
