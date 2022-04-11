//
//  IconActionButtonView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import SwiftUI

struct IconActionButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    let title: String
    let foreground: Color
    let background: Color
    let sfSymbols: String
    let offsetSymbols: CGFloat
    let handler: ActionHandler
    
    init(title: String, foreground: Color, background: Color, sfSymbols: String, offsetSymbols: CGFloat, handler: @escaping ActionButtonView.ActionHandler) {
        self.title = title
        self.foreground = foreground
        self.background = background
        self.sfSymbols = sfSymbols
        self.offsetSymbols = offsetSymbols
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: sfSymbols)
                    .offset(x: UIScreen.main.bounds.width * offsetSymbols, y: -10)
                    .zIndex(1)
                VStack {
                    Text(title)
                    
                }
            }
            .foregroundColor(foreground)
            .font(.system(size: 18, weight: .bold, design: .serif))
            .frame(maxWidth: 200, maxHeight: 55)
            .background(background)
            .cornerRadius(7)
            .padding(.all, 5)
        }
        
    }
}

struct IconActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        IconActionButtonView(title: "Creating Group", foreground: .white, background: .blue, sfSymbols: "plus", offsetSymbols: 0.06, handler: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
