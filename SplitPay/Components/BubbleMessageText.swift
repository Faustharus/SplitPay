//
//  BubbleMessageText.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 21/12/2022.
//

import SwiftUI
import Firebase

struct BubbleMessageText: View {
    
    @State private var postDateSent: Bool = false
    @State private var postDateReceived: Bool = false
    
    @Binding var performDelete: Bool
    
    let uid: String
    let text: SessionChatMessageDetails
    
    //let performDelete: ()
    
    var body: some View {
        VStack(alignment: text.fromUid == uid ? .trailing : .leading) {
            if text.fromUid == uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(text.message)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                        /** Delete Func doable only with the server-side coded */
//                            .onTapGesture(count: 2) {
//                                performDelete = true
//                            }

                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(7)
                }
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.35)) {
                        self.postDateSent.toggle()
                        self.postDateReceived = false
                    }
                }
                
                HStack { Spacer() }
                
                if postDateSent {
                    VStack {
                        Text("Send \(text.timestamp.dateValue().formatted(date: .numeric, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 1)
                    .padding(.trailing, 5)
                }
            } else {
                HStack {
                    HStack {
                        Text(text.message)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(7)
                    
                    Spacer()
                }
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.35)) {
                        self.postDateReceived.toggle()
                        self.postDateSent = false
                    }
                }
                
                HStack { Spacer() }
                
                if postDateReceived {
                    VStack {
                        Text("Received \(text.timestamp.dateValue().formatted(date: .numeric, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 1)
                    .padding(.leading, 5)
                }
            }
        }
        .padding(.horizontal, 6)
    }
}

struct BubbleMessageText_Previews: PreviewProvider {
    static var previews: some View {
        BubbleMessageText(performDelete: .constant(false), uid: "", text: SessionChatMessageDetails.init(id: "", fromUid: "", toUid: "", message: "Test Message", timestamp: Timestamp()))
    }
}
