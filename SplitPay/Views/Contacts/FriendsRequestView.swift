//
//  FriendsRequestView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 27/08/2022.
//

import SwiftUI

struct FriendsRequestView: View {
    
    let user: SessionUserDetails
    
    var body: some View {
        HStack {
            
            if user.profilePicture.isEmpty {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
            } else {
                AsyncImage(url: URL(string: "\(user.profilePicture)")) { image in
                    image.resizable()
                } placeholder: {
                    Color.red.frame(width: 125)
                }
                .scaledToFit()
                .frame(maxWidth: .infinity)
            }
            
            Text("\(user.firstName) \(user.surName)")
                .font(.title)
                .bold()
                .italic()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 55, height: 55)
                .foregroundColor(.green)
                .overlay(
                    VStack {
                        Button {
                            // TODO: More Code Later
                        } label: {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                )
                .shadow(color: .black, radius: 7, x: 0, y: 5)
            
            Spacer().frame(width: 20)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 55, height: 55)
                .foregroundColor(.red)
                .overlay(
                    VStack {
                        Button {
                            // TODO: More Code Later
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                )
                .shadow(color: .black, radius: 7, x: 0, y: 5)
            
            
        }
        .padding(.horizontal, 15)
    }
}

struct FriendsRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsRequestView(user: SessionUserDetails.init(id: "", email: "Example.email.com", firstName: "Rodney", surName: "McKay", nickName: "Rod", extNickName: "Rod#4826", profilePicture: "", withContact: false))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
