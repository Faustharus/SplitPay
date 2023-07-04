//
//  FriendProfileDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/06/2023.
//

import SwiftUI

struct FriendProfileDetails: View {
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width, height: geo.size.height * 0.2)
                
                Text("Rodney McKay")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                
                Text("Rod#5155")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                
                Spacer().frame(height: UIScreen.main.bounds
                    .height * 0.05)
                
                VStack {
                    ButtonActionView(tapButton: .constant(false), title: "Send Request", foreground: .white, background: [Color(red: 0.15, green: 0.6, blue: 1)], sfSymbols: "paperplane", width: geo.size.width * 0.9, height: 65) {
                        // TODO: More Code Later
                    }
                    
                    Spacer().frame(height: geo.size.height * 0.03)
                    
                    ButtonActionView(tapButton: .constant(false), title: "Block Rodney", foreground: .white, background: [.red], sfSymbols: "xmark", width: geo.size.width * 0.9, height: 65) {
                        // TODO: More Code Later
                    }
                }
                .font(.system(size: 24, weight: .semibold, design: .default))
                .imageScale(.large)
                .clipped()
            }
        }
    }
}

struct FriendProfileDetails_Previews: PreviewProvider {
    static var previews: some View {
        FriendProfileDetails()
    }
}
