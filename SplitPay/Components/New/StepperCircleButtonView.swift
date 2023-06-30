//
//  StepperCircleButtonView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 28/06/2023.
//

import SwiftUI

struct StepperCircleButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    let width: CGFloat
    let sfSymbols: String
    let isDisabled: Bool
    let handler: ActionHandler
    
    init(width: CGFloat, sfSymbols: String, isDisabled: Bool, handler: @escaping StepperCircleButtonView.ActionHandler) {
        self.width = width
        self.sfSymbols = sfSymbols
        self.isDisabled = isDisabled
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler) {
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 2)
                    .frame(width: width)
                VStack {
                    Image(systemName: sfSymbols)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .imageScale(.medium)
                        .bold()
                }
            }
            .background(Color.yellow.opacity(0.85))
            .clipShape(Circle())
        }
        .shadow(color: .black.opacity(0.85), radius: 5, x: 2, y: 2)
        .buttonStyle(.plain)
        .disabled(isDisabled)
        
    }
}

struct StepperCircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StepperCircleButtonView(width: 60, sfSymbols: "plus", isDisabled: false) { }
    }
}
