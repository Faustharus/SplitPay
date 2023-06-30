//
//  ButtonChevronView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 21/06/2023.
//

import SwiftUI

struct ButtonChevronView: View {
    
    typealias ActionHandler = () -> Void
    
    @Binding var tapButton: Bool
    
    var title: String
    var description: String
    var foreground: Color
    var sfSymbols: String
    var width: CGFloat
    var height: CGFloat
    var handler: ActionHandler
    
    init(tapButton: Binding<Bool>, title: String, description: String, foreground: Color, sfSymbols: String, width: CGFloat, height: CGFloat, handler: @escaping ActionButtonView.ActionHandler) {
        _tapButton = tapButton
        self.title = title
        self.description = description
        self.foreground = foreground
        self.sfSymbols = sfSymbols
        self.width = width
        self.height = height
        self.handler = handler
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(.black.opacity(0.5).shadow(tapButton ? .drop(color: .black, radius: 5, x: 5, y: 5) : .inner(color: .white, radius: 5, x: 2, y: 2) ))
            VStack {
                Button(action: handler) {
                    HStack {
                        Image(systemName: sfSymbols)
                            .imageScale(.large)
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.headline)
                            Text(description)
                                .font(.caption)
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal, 15)
                }
            }
        }
        .foregroundColor(foreground)
        .frame(width: width, height: height)
    }
}

struct ButtonChevronView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonChevronView(tapButton: .constant(false), title: "Profile Picture", description: "Change your style", foreground: .white, sfSymbols: "person.crop.circle", width: 300, height: 65) { }
    }
}
