//
//  ContactsView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/06/2022.
//

import SwiftUI

struct ContactsView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    let names = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"]
    
    var body: some View {
        VStack {
            HStack {
                if sessionService.userDetails.profilePicture.isEmpty {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
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
                VStack(alignment: .leading, spacing: 0) {
                    Text(sessionService.userDetails.nickName)
                        .font(.title).bold()
                    HStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 15, height: 15)
                        Text("Online")
                            .font(.subheadline)
                    }
                }
                .padding(.all, 0)
                
                Spacer()
                
                NavigationLink {
                    SearchContactsView()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
            }
            .padding(.horizontal)
            
            List(names, id: \.self) { item in
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    VStack(alignment: .leading) {
                        Text("Username")
                            .font(.headline).bold()
                        HStack {
                            Text("Message sent to user")
                                .foregroundColor(.secondary)
                                .font(.caption)
                            
                            Spacer()
                            
                            Text("22d")
                                .font(.subheadline)
                        }
                        
                    }
                    .padding(.all, 0)
                    
                }
                .padding(.horizontal, 0)
            }
            .listStyle(.plain)
            
            ActionButtonView(title: "New Message", foreground: .white, background: .blue, sfSymbols: "plus") {
                // TODO: More Code Later
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 1)
        }
        
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
            .environmentObject(SessionServiceImpl())
    }
}
