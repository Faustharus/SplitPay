//
//  CreateNewMessagesView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/11/2022.
//

import SwiftUI

struct CreateNewMessagesView: View {
    
    @ObservedObject var vm = ChatViewModelImpl(service: ChatServiceImpl())
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @Environment(\.dismiss) var dismiss
    
    let didStartConversation: (SessionUserDetails) -> ()
    
    var body: some View {
        //NavigationView {
        VStack(alignment: .center) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .padding(.leading, 10)
            
                List(sessionService.userArray, id: \.id) { item in
                    Button {
                        dismiss()
                        didStartConversation(item)
                        let _ = print(item.id)
                    } label: {
                        HStack {
                            if item.profilePicture.isEmpty {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 56, height: 56)
                            } else {
                                AsyncImage(url: URL(string: "\(item.profilePicture)")) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.red.frame(width: 125)
                                }
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                                .scaledToFit()
                            }
                            
                            Text("\(item.extNickName)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.grouped)
            }
//            .navigationTitle("Contact List").navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Text("Cancel")
//                    }
//                }
//            }
        //}
    }
}

struct CreateNewMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessagesView(didStartConversation: { item in })
            .environmentObject(SessionServiceImpl())
    }
}
