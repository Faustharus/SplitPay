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
    
    static let stringForScrollToId = "Empty"
    
    init(chatUser: SessionUserDetails?) {
        self.chatUser = chatUser
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        ForEach(sessionService.chatMessageArray, id: \.id) { text in
                            BubbleMessageText(uid: Auth.auth().currentUser?.uid ?? "N/A User", text: text)
                        }
                        
                        HStack { Spacer() }
                            .id(Self.stringForScrollToId)
                    }
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            proxy.scrollTo(Self.stringForScrollToId, anchor: .bottom)
                        }
                    }
                }
            }
            .onAppear {
                self.sessionService.fetchMessages(with: Auth.auth().currentUser?.uid ?? "N/A User", and: chatUser?.id ?? "N/A Other User")
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button {
                        let _ = print(sessionService.chatMessageArray)
                        let _ = print(sessionService.chatMessageArray.count)
                        //let _ = print(sessionService.chatMessageArray[0].id)
                        // TODO: More Code Later
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .imageScale(.medium)
                    }
                    
                    TextEditorWithPlaceholder(text: $vm.chatMessage.message)
                        .frame(width: 250)
                        .keyboardType(.default)
                    
                    Button {
                        vm.sendNewMessage(with: chatUser!.id, and: vm.chatMessage)
                        self.sessionService.fetchMessages(with: Auth.auth().currentUser?.uid ?? "N/A User", and: chatUser?.id ?? "N/A Other User")
                        vm.newLastMessage(with: chatUser!.id, and: vm.chatMessage)
                    } label: {
                        Text("Send")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 70, height: 45)
                            .background(vm.chatMessage.message.isEmpty || vm.chatMessage.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                            .shadow(color: vm.chatMessage.message.isEmpty || vm.chatMessage.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue, radius: 2, x: 0, y: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                    .disabled(vm.chatMessage.message.isEmpty || vm.chatMessage.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .frame(height: 80)
                .offset(x: 0, y: -3)
                .padding([.horizontal, .vertical], 10)
                .background(Color(.systemBackground))
            }
        }
        .navigationTitle("\(chatUser?.extNickName ?? "N/A")")
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
}

struct CurrentChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentChatLogView(chatUser: SessionUserDetails(id: "", email: "Example@email.com", firstName: "Rodney", surName: "McKay", nickName: "Rod", extNickName: "Rod#5355", profilePicture: "", withContact: false))
            .environmentObject(SessionServiceImpl())
    }
}
