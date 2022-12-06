//
//  CurrentChatLogView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 02/12/2022.
//

import SwiftUI

struct CurrentChatLogView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    let chatUser: SessionUserDetails?
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(0 ..< 10) { _ in
                    HStack {
                        Spacer()
                        HStack {
                            Text("Dummy Message")
                                .font(.system(size: 18, weight: .medium, design: .serif))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(7)
                    }
                    
                    HStack { Spacer() }
                }
                .padding([.horizontal, .vertical], 6)
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button {
                        // TODO: More Code Later
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .imageScale(.medium)
                    }
                    
                    TextEditorWithPlaceholder(text: $sessionService.userTextMessage)
                        .frame(width: 250, height: 50)
                        .keyboardType(.default)
                    
                    Button {
                        sendNewMessage()
                    } label: {
                        Text("Send")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 70, height: 45)
                            .background(sessionService.userTextMessage.isEmpty ? Color.gray : Color.blue)
                            .shadow(color: sessionService.userTextMessage.isEmpty ? .gray : .blue, radius: 2, x: 0, y: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                    .disabled(sessionService.userTextMessage.isEmpty)
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
    
    func sendNewMessage() {
        sessionService.sendingMessages(with: chatUser!)
        sessionService.userTextMessage = ""
    }
    
}
