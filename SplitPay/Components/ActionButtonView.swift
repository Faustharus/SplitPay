//
//  ActionButtonView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/03/2022.
//

import SwiftUI

struct ActionButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    let title: String
    let foreground: Color
    let background: Color
    let sfSymbols: String?
    let handler: ActionHandler
    
    init(title: String, foreground: Color, background: Color, sfSymbols: String, handler: @escaping ActionButtonView.ActionHandler) {
        self.title = title
        self.foreground = foreground
        self.background = background
        self.sfSymbols = sfSymbols
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler) {
            HStack {
                Text(title)
                
                Image(systemName: sfSymbols ?? "")
            }
            .foregroundColor(foreground)
            .font(.system(.title3, design: .serif).weight(.semibold))
        }
        .frame(maxWidth: .infinity, maxHeight: 55)
        .background(background)
        .cornerRadius(7)
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView(title: "Login", foreground: .white, background: .blue, sfSymbols: "rectangle.portrait.and.arrow.right", handler: {})
    }
}
