//
//  ChevronButtonActionView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 10/05/2023.
//

import SwiftUI

struct ChevronButtonActionView: View {
    
    typealias ActionHandler = () -> Void
    
    @Binding var tapButton: Bool
    
    var title: String
    var foreground: Color
    var background: [Color]
    var leftSfSymbols: String?
    var rightSfSymbols: String?
    var width: CGFloat
    var height: CGFloat
    var handler: ActionHandler
    
    init(tapButton: Binding<Bool>, title: String, foreground: Color, background: [Color], leftSfSymbols: String, rightSfSymbols: String, width: CGFloat, height: CGFloat, handler: @escaping ActionButtonView.ActionHandler) {
        _tapButton = tapButton
        self.title = title
        self.foreground = foreground
        self.background = background
        self.leftSfSymbols = leftSfSymbols
        self.rightSfSymbols = rightSfSymbols
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
                        Image(systemName: leftSfSymbols ?? "")
                            .bold()
                        Text(title)
                            .font(.title2)
                            .bold()
                        Image(systemName: rightSfSymbols ?? "")
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

struct ChevronButtonActionView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ChevronButtonActionView(tapButton: .constant(false), title: "Back", foreground: .white, background: [Color.red.opacity(0.9), Color.red.opacity(0.6), Color.red.opacity(0.3)], leftSfSymbols: "chevron.left", rightSfSymbols: "", width: 150, height: 45) { }
            
            Spacer().frame(width: 30)
            
            ChevronButtonActionView(tapButton: .constant(false), title: "Continue", foreground: .white, background: [Color.purple.opacity(0.9), Color.purple.opacity(0.6), Color.purple.opacity(0.3)], leftSfSymbols: "", rightSfSymbols: "chevron.right", width: 150, height: 45) { }
        }
    }
}
