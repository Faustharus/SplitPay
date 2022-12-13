//
//  ContactsView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/06/2022.
//

import SwiftUI

struct ChatRoomView: View {
    
    @StateObject var vm = ChatViewModelImpl(service: ChatServiceImpl())
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var chatUser: SessionUserDetails?
    @State var shouldNavigateToChatLogView: Bool = false
    
    @State private var aNewMessage: Bool = false
    
//    @State private var isToBeContacted: Bool = false
    
    let names = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    if sessionService.userDetails.profilePicture.isEmpty {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                    } else {
                        AsyncImage(url: URL(string: "\(sessionService.userDetails.profilePicture)")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.red.frame(width: 125)
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .scaledToFit()
                    }
                    VStack(spacing: 0) {
                        Text("\(sessionService.userDetails.firstName)")
                            .font(.title).bold()
                            .padding(.leading, 10)
                        
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.green)
                            Text("Online")
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal, 15)
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    CurrentChatLogView(chatUser: self.chatUser)
                        .environmentObject(sessionService)
                }
                
                List(names, id: \.self) { item in
                    VStack {
                        NavigationLink {
                            Text("Destination")
                            //CurrentChatLogView(chatUser: chatUser)
                        } label: {
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 56, height: 56)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Jane Doe")
                                            .font(.headline).bold()
                                        
                                        Spacer()
                                        
                                        Text("11/30/2022")
                                            .font(.subheadline).italic()
                                        
                                    }
                                    
                                    Text("Hello, There ! :)")
                                }
                            }
                        }
                    }
                }
                .listStyle(.inset)
                ActionButtonView(title: "New Message", foreground: .white, background: .blue, sfSymbols: "plus") {
                    // TODO: More Code Later
                    self.aNewMessage = true
                }
                .padding([.horizontal, .vertical], 10)
            }
            .navigationTitle("Chat Room").navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $aNewMessage) {
                CreateNewMessagesView(didStartConversation: { user in
                    print(user.email)
                    self.shouldNavigateToChatLogView = true
                    self.chatUser = user
                })
                .environmentObject(sessionService)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: More Code Later
                        // Friend Request
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                }
            }
        }
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView()
            .environmentObject(SessionServiceImpl())
    }
}
