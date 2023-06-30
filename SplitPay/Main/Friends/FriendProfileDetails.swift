//
//  FriendProfileDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/06/2023.
//

import SwiftUI

struct FriendProfileDetails: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 5)
            
            Text("John Doe")
                .font(.system(size: 24, weight: .bold, design: .serif))
            
            Spacer().frame(height: UIScreen.main.bounds
                .height * 0.05)
            
            HStack {
                Button {
                    // TODO: More Code Later
                } label: {
                    Image(systemName: "checkmark.circle")
                }
                
                Spacer().frame(width: UIScreen.main.bounds.width * 0.3)
                
                Button {
                    // TODO: More Code Later
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }
            .font(.system(size: 24, weight: .semibold, design: .default))
            .imageScale(.large)
            .symbolRenderingMode(.multicolor)
            .clipped()
        }
    }
}

struct FriendProfileDetails_Previews: PreviewProvider {
    static var previews: some View {
        FriendProfileDetails()
    }
}
