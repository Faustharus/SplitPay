//
//  ButtonActionView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 08/05/2023.
//

import SwiftUI

struct ButtonActionView: View {
    
    typealias ActionHandler = () -> Void
    
    @Binding var tapButton: Bool
    
    var title: String
    var foreground: Color
    var background: [Color]
    var sfSymbols: String
    var width: CGFloat
    var height: CGFloat
    var handler: ActionHandler
    
    init(tapButton: Binding<Bool>, title: String, foreground: Color, background: [Color], sfSymbols: String, width: CGFloat, height: CGFloat, handler: @escaping ActionButtonView.ActionHandler) {
        _tapButton = tapButton
        self.title = title
        self.foreground = foreground
        self.background = background
        self.sfSymbols = sfSymbols
        self.width = width
        self.height = height
        self.handler = handler
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(LinearGradient(colors: background, startPoint: .topLeading, endPoint: .bottomTrailing).shadow(tapButton ? .inner(color: .black, radius: 5, x: 2, y: 2) : .drop(color: .black, radius: 5, x: 1, y: 1)))
            VStack {
                Button(action: handler) {
                    HStack {
                        Text(title)
                            .font(.title2)
                            .bold()
                        Image(systemName: sfSymbols)
                            .bold()
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: width, height: height)
    }
}

struct ButtonActionView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonActionView(tapButton: .constant(false), title: "Login", foreground: .white, background: [.blue, .purple], sfSymbols: "rectangle.portrait.and.arrow.right", width: 300, height: 45) { }
    }
}
