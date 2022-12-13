//
//  CurrentChatLogView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 02/12/2022.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CurrentChatLogView: View {
    
    @ObservedObject var vm = ChatViewModelImpl(service: ChatServiceImpl())
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    let chatUser: SessionUserDetails?
    
    init(chatUser: SessionUserDetails?) {
        self.chatUser = chatUser
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(sessionService.chatMessageArray) { text in
                    Text(text.message)
//                    HStack {
//                        Spacer()
//                        HStack {
//                            Text(text.message)
//                                .font(.system(size: 18, weight: .medium, design: .serif))
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(7)
//                    }
//
//                    HStack { Spacer() }
                    
                }
                .padding([.horizontal, .vertical], 6)
            }
            .onAppear {
                self.sessionService.fetchMessages(with: Auth.auth().currentUser?.uid ?? "N/A User", and: chatUser?.id ?? "N/A Other User")
            }
            //.background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button {
                        let _ = print(sessionService.chatMessageArray)
                        let _ = print(sessionService.chatMessageArray.count)
                        // TODO: More Code Later
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .imageScale(.medium)
                    }
                    
                    TextEditorWithPlaceholder(text: $vm.chatMessage.message)
                        .frame(width: 250, height: 50)
                        .keyboardType(.default)
                    
                    Button {
                        vm.sendNewMessage(with: chatUser!.id, and: vm.chatMessage)
                        //sessionService.fetchMessages(with: Auth.auth().currentUser!.uid, and: chatUser!.id)
                    } label: {
                        Text("Send")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 70, height: 45)
                            .background(vm.chatMessage.message.isEmpty ? Color.gray : Color.blue)
                            .shadow(color: vm.chatMessage.message.isEmpty ? .gray : .blue, radius: 2, x: 0, y: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                    .disabled(vm.chatMessage.message.isEmpty)
                }
                .frame(height: 50)
                .padding([.horizontal, .vertical], 10)
                .background(Color(.systemBackground))
            }
            
        }
        .navigationTitle("\(chatUser?.extNickName ?? "N/A")")
    }
}

struct CurrentChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentChatLogView(chatUser: SessionUserDetails(id: "", email: "Example@email.com", firstName: "Rodney", surName: "McKay", nickName: "Rod", extNickName: "Rod#5355", profilePicture: "", withContact: false))
            .environmentObject(SessionServiceImpl())
    }
}

extension CurrentChatLogView {
    
//    func sendNewMessage() {
//        sessionService.sendingMessages(with: chatUser!)
//        sessionService.userTextMessage = ""
//    }
    
}
