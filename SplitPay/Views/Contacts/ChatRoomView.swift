//
//  ContactsView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/06/2022.
//

import SwiftUI
import FirebaseAuth

enum ActiveFriendSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct ChatRoomView: View {
    
    @StateObject var vm = ChatViewModelImpl(service: ChatServiceImpl())
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var mSockets: () = SocketHandler.shared.establishConnection()
    
    @State var chatUser: SessionUserDetails?
    @State var shouldNavigateToChatLogView: Bool = false
    
    @State private var seeChatDetails: ActiveFriendSheet?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
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
                    }
                    .onTapGesture {
                        self.seeChatDetails = .second
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
                
                ScrollView {
                    LazyVStack(alignment: .center, spacing: 5) {
                        ForEach(sessionService.userArray, id: \.id) { user in
                            NavigationLink {
                                CurrentChatLogView(chatUser: user)
                            } label: {
                                ForEach(sessionService.chatMessageArray, id: \.id) { item in
                                    
                                    if Auth.auth().currentUser?.uid == item.fromUid && user.id == item.toUid {
                                        LastMessage(pictureBool: user.profilePicture.isEmpty, pictureString: user.profilePicture, firstName: user.firstName, surName: user.surName, textMessage: item.message, sinceLastMsg: item.sinceLastMsg)
                                        
                                    } else if Auth.auth().currentUser?.uid == item.toUid && user.id == item.fromUid  {
                                        LastMessage(pictureBool: user.profilePicture.isEmpty, pictureString: user.profilePicture, firstName: user.firstName, surName: user.surName, textMessage: item.message, sinceLastMsg: item.sinceLastMsg)
                                    }
                                    
                                }
                            }
                            .onAppear {
                                self.sessionService.fetchLastMessage(with: Auth.auth().currentUser?.uid ?? "N/A User")
                            }
                        }
                    }
                }
                
                ActionButtonView(title: "New Message", foreground: .white, background: .blue, sfSymbols: "plus") {
                    seeChatDetails = .first
                }
                .padding([.horizontal, .vertical], 10)
                
            }
            .navigationTitle("Chat Room").navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $seeChatDetails) { item in
                switch item {
                    case .first:
                        CreateNewMessagesView(didStartConversation: { user in
                            print(user.email)
                            self.shouldNavigateToChatLogView.toggle()
                            self.chatUser = user
                        })
                        .environmentObject(sessionService)
                    case .second:
                        FriendRequestView()
                }
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


// MARK: - View Components
extension ChatRoomView {
    struct LastMessage: View {
        var pictureBool: Bool
        var pictureString: String
        var firstName: String
        var surName: String
        var textMessage: String
        var sinceLastMsg: String
        
        var body: some View {
            HStack {
                if pictureBool {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                } else {
                    AsyncImage(url: URL(string: "\(pictureString)")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.red.frame(width: 125)
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .scaledToFit()
                }
                
                LazyVStack(alignment: .leading, spacing: 6) {
                    Text("\(firstName) \(surName)")
                        .font(.headline)
                    Text(textMessage)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                
                Text("\(sinceLastMsg)")
            }
            .padding()
        }
    }
}
