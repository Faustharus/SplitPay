//
//  ProfileView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/04/2022.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            // Background ???
            ScrollView {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75)
                Text("John Doe")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                Text("JohnDoe#5487")
                    .font(.system(size: 12, weight: .light, design: .serif))
                
                Rectangle()
                    .foregroundColor(.secondary)
                    .frame(height: 3)
                
                Button(action: {
                    // TODO: More Code Later
                }) {
                    HStack {
                        VStack {
                            Text("Security Section")
                                .font(.headline.weight(.bold))
                            Text("Password, Name, Picture")
                                .font(.subheadline.weight(.semibold))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 20)
                    }
                    .padding(.horizontal, 15)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .background(.blue)
                    .cornerRadius(7)
                    .padding()
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
