//
//  SettingProfileView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 20/06/2023.
//

import FirebaseAuth
import SwiftUI
//import SocketIO

enum ActiveSheet: Identifiable {
    case first, second, third

    var id: Int {
        hashValue
    }
}

struct SettingProfileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    //@ObservedObject var socketMain = SocketMain()
    
    @State private var seeDetails: ActiveSheet?
    @State private var toLogout: Bool = false
    
    @State private var isLoading: Bool = false
    @State private var tapButtonProfile: Bool = false
    @State private var tapButtonPwd: Bool = false
    @State private var tapButtonBlock: Bool = false
    @State private var tapButtonDelete: Bool = false
    @State private var tapButtonContact: Bool = false
    @State private var tapButtonGTU: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundGradient
                
                VStack {
                    AsyncImage(url: URL(string: "\(sessionService.userDetails.profilePicture)")) { phase in
                        switch phase {
                            case .empty:
                                if isLoading {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                        Spacer()
                                    }
                                    .frame(width: geo.size.width, height: geo.size.height * 0.15)
                                }
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .clipShape(Circle())
                                    .frame(width: geo.size.width, height: geo.size.height * 0.15)
                                    .overlay(
                                        Circle().stroke(Color(red: 1, green: 1, blue: 0).opacity(0.6), lineWidth: 1.5)
                                    )
                                    .shadow(color: .purple, radius: 4, x: 0, y: 5)

                            case .failure:
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .clipShape(Circle())
                                    .frame(width: geo.size.width, height: geo.size.height * 0.15)

                            @unknown default:
                                fatalError()
                        }
                    }
                    
                    ZStack {
                        Text("\(sessionService.userDetails.firstName) ") + Text("\(sessionService.userDetails.surName)")
                        HStack {
                            Text("\(sessionService.userDetails.firstName) ") + Text("\(sessionService.userDetails.surName)")
                        }
                        .foregroundColor(.white)
                        .offset(x: 1, y: 1)
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .bold()
                    
                    ZStack {
                        Text("\(sessionService.userDetails.extNickName)")
                        VStack {
                            Text("\(sessionService.userDetails.extNickName)")
                        }
                        .foregroundColor(.white.opacity(0.85))
                        .offset(x: 1, y: 1)
                    }
                    .foregroundColor(.black.opacity(0.55))
                    .font(.system(size: 12, weight: .light, design: .serif))
                    .italic()
                    
                    Spacer().frame(height: 15)
                    
                    Rectangle()
                        .foregroundColor(.secondary)
                        .frame(height: 3)
                    
                    Spacer().frame(height: 25)
                    
                    VStack(spacing: 8) {
                        ButtonChevronView(tapButton: $tapButtonProfile, title: "Profile Picture", description: "Change your style", foreground: .white, sfSymbols: "person.crop.circle", width: 300, height: 65) {
                            animationButton(_tapButtonProfile)
                            self.seeDetails = .first
                        }
                        
                        ButtonChevronView(tapButton: $tapButtonPwd, title: "Password", description: "Someone tried to sneak up on you", foreground: .white, sfSymbols: "lock", width: 300, height: 65) {
                            animationButton(_tapButtonPwd)
                            self.seeDetails = .second
                        }
                        
                        ButtonChevronView(tapButton: $tapButtonBlock, title: "Acc. Blocked", description: "Whose who bothered you", foreground: .white, sfSymbols: "nosign", width: 300, height: 65) {
                            animationButton(_tapButtonBlock)
                            // TODO: More Code Later
                        }
                        
                        ButtonChevronView(tapButton: $tapButtonDelete, title: "Delete your Acc.", description: "Everything will be gone", foreground: .white, sfSymbols: "exclamationmark.triangle", width: 300, height: 65) {
                            animationButton(_tapButtonDelete)
                            self.seeDetails = .third
                        }
                        
                        ButtonChevronView(tapButton: $tapButtonContact, title: "Contact Us", description: "Post your feedback", foreground: .white, sfSymbols: "questionmark", width: 300, height: 65) {
                            animationButton(_tapButtonContact)
                            // TODO: More Code Later
                        }
                        
                        ButtonChevronView(tapButton: $tapButtonGTU, title: "General Terms of Use", description: "Rules of SplitPay", foreground: .white, sfSymbols: "newspaper", width: 300, height: 65) {
                            animationButton(_tapButtonGTU)
                            // TODO: More Code Later
                        }
                        
                    }
                    
                    Spacer()
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.toLogout = true
                        } label: {
                            Image(systemName: "power.circle.fill")
                                .font(.system(size: 20))
                                .imageScale(.large)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(red: 1, green: 1, blue: 1), Color(red: 1, green: 0, blue: 0))
                                .shadow(color: Color(red: 0.5, green: 0, blue: 0.7), radius: 1.5, x: 0, y: 3)
                            
                        }
                    }
                }
                .alert(isPresented: $toLogout) {
                    Alert(title: Text("Logging Out"), message: Text("Are you sure ?"), primaryButton: .destructive(
                        Text("Logout"),
                        action: {
                            //socketMain.closeConnection()
                            sessionService.logout()
                        }
                    ), secondaryButton:
                        .cancel(
                            Text("Cancel"),
                        action: {
                            self.toLogout = false
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
}

struct SettingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SettingProfileView()
            .environmentObject(SessionServiceImpl())
    }
}


// MARK: - View Components
extension SettingProfileView {
    
    var backgroundGradient: some View {
        LinearGradient(colors: [Color(red: 0.2, green: 0, blue: 1).opacity(1), Color(red: 0.4, green: 0, blue: 1).opacity(0.8), Color(red: 0.3, green: 0, blue: 0.6).opacity(0.6), Color(red: 0.6, green: 0, blue: 0.8).opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.top)
    }
    
}



// MARK: - Function & Computed Properties
extension SettingProfileView {
    
    func animationButton(_ boolean: State<Bool>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation {
                boolean.wrappedValue = false
            }
        }
        withAnimation {
            boolean.wrappedValue = true
        }
    }
    
}
