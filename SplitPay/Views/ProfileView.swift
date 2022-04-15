//
//  ProfileView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/04/2022.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        ZStack {
            // Background ???
            VStack {
                
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75)
                    HStack {
                        Text("\(sessionService.userDetails.firstName) ") + Text("\(sessionService.userDetails.surName)")
                            
                    }
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    
                Text("\(sessionService.userDetails.nickName)#\(String(sessionService.userDetails.extNickName))")
                        .font(.system(size: 12, weight: .light, design: .serif))
                    
                    Rectangle()
                        .foregroundColor(.secondary)
                        .frame(height: 3)
                List {
                    Button(action: {
                        // TODO: More Code Later
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
                    
                    Toggle("No Contacts Yet ?", isOn: $sessionService.userDetails.withoutContact)
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
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
    }
}
