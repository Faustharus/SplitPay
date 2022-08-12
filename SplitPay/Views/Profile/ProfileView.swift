//
//  ProfileView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/04/2022.
//

import SwiftUI
import FirebaseAuth

enum ActiveSheet: Identifiable {
    case first, second, third
    
    var id: Int {
        hashValue
    }
}

struct ProfileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var seeDetails: ActiveSheet?
    @State private var toLogout: Bool = false
    
    var body: some View {
        ZStack {
            // Background ???
            VStack {
                
                if sessionService.userDetails.profilePicture.isEmpty {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75)
                } else {
                    AsyncImage(url: URL(string: "\(sessionService.userDetails.profilePicture)")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.red.frame(width: 125)
                    }
                    .scaledToFit()
                    .frame(width: 125)
                    .clipShape(Circle())
                }
                
                    HStack {
                        Text("\(sessionService.userDetails.firstName) ") + Text("\(sessionService.userDetails.surName)")
                    }
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    
                Text("\(sessionService.userDetails.extNickName)")
                        .font(.system(size: 12, weight: .light, design: .serif))
                    
                    Rectangle()
                        .foregroundColor(.secondary)
                        .frame(height: 3)
                List {
                    ChevronButtonView(title: "Update Profile", subTitle: "Profile Info", foreground: .white, background: .blue) {
                        self.seeDetails = .first
                    }
                    
                    ChevronButtonView(title: "Update Security", subTitle: "Password Cred.", foreground: .white, background: .blue) {
                        self.seeDetails = .second
                    }
                    
                    ChevronButtonView(title: "Update Account", subTitle: "Security Info", foreground: .white, background: .blue) {
                        self.seeDetails = .third
                    }
                    
                    Toggle("With Contacts ?", isOn: $sessionService.userDetails.withContact)
                        .padding(.horizontal, 15)
                        .frame(height: 55)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(.black, lineWidth: 3)
                        )
                }
                .listStyle(.plain)
                
                ActionButtonView(title: "Logout", foreground: .white, background: .red, sfSymbols: "power") {
                    self.toLogout = true
                }
                .padding(.all, 10)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $toLogout) {
                Alert(title: Text("Logging Out"), message: Text("Are you sure ?"), primaryButton: .cancel(
                        Text("Cancel"),
                    action: {
                        self.toLogout = false
                    }
                ), secondaryButton:
                    .destructive(
                        Text("Logout"),
                    action: {
                        sessionService.logout()
                    })
                )
            }
            .sheet(item: $seeDetails) { item in
                switch item {
                case .first:
                    ProfileChangeView()
                case .second:
                    ProfilePwdChangeView()
                case .third:
                    ProfileAccountView()
                }
                
            }
            .onAppear {
                sessionService.handleRefresh(with: Auth.auth().currentUser!.uid)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
    }
}
