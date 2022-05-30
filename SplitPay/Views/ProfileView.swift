//
//  ProfileView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/04/2022.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var seeDetails: Bool = false
    
    var body: some View {
        ZStack {
            // Background ???
            VStack {
                
                AsyncImage(url: URL(string: "\(sessionService.userDetails.profilePicture)")) { image in
                    image.resizable()
                } placeholder: {
                    Color.red.frame(width: 125)
                }
                .scaledToFit()
                .frame(width: 125)
                .clipShape(Circle())
                
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
                    Button(action: {
                        self.seeDetails = true
                    }) {
                        HStack {
                            VStack {
                                Text("Security Section")
                                    .font(.headline.weight(.bold))
                                Text("Password, Name, Picture")
                                    .font(.subheadline.weight(.semibold))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 20)
                        }
                        .padding(.horizontal, 15)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .background(.blue)
                        .cornerRadius(7)
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
                    sessionService.logout()
                }
                .padding(.all, 10)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $seeDetails) {
                ProfileChangeView()
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
