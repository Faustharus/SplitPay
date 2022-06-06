//
//  ChevronButtonView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 31/05/2022.
//

import SwiftUI

struct ChevronButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    let title: String
    let subTitle: String
    let foreground: Color
    let background: Color
    let handler: ActionHandler
    
    init(title: String, subTitle: String, foreground: Color, background: Color, handler: @escaping ChevronButtonView.ActionHandler) {
        self.title = title
        self.subTitle = subTitle
        self.foreground = foreground
        self.background = background
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            HStack {
                VStack {
                    Text(title)
                        .font(.headline.weight(.bold))
                    Text(subTitle)
                        .font(.subheadline.weight(.semibold))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 20)
            }
            .padding(.horizontal, 15)
            .foregroundColor(foreground)
            .frame(height: 55)
            .background(background)
            .cornerRadius(7)
        })
    }
}

struct ChevronButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ChevronButtonView(title: "Update Profile", subTitle: "Name, Picture", foreground: .white, background: .blue) { }
    }
}
