//
//  BubbleMessageText.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 21/12/2022.
//

import SwiftUI
import Firebase

struct BubbleMessageText: View {
    
    @State private var postDate: Bool = false
    
    let uid: String
    let text: SessionChatMessageDetails
    
    var body: some View {
        VStack(alignment: text.fromUid == uid ? .trailing : .leading) {
            if text.fromUid == uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(text.message)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(7)
                }
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.35)) {
                        self.postDate.toggle()
                    }
                }
                
                HStack { Spacer() }
                
                if postDate {
                    VStack {
                        Text("\(text.timestamp.dateValue().formatted(date: .numeric, time: .shortened))")
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
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(7)
                    
                    Spacer()
                }
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.35)) {
                        self.postDate.toggle()
                    }
                }
                
                HStack { Spacer() }
                
                if postDate {
                    VStack {
                        Text("\(text.timestamp.dateValue().formatted(date: .numeric, time: .shortened))")
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
        BubbleMessageText(uid: "", text: SessionChatMessageDetails.init(id: "", fromUid: "", toUid: "", message: "Test Message", timestamp: Timestamp()))
    }
}
