//
//  InputWithoutIconTextFieldView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 03/08/2022.
//

import SwiftUI

struct InputDoubleWithoutIconTextFieldView: View {
    
    @Binding var values: Double
    var title: String
    var placeholder: String?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 7)
            .stroke(.black, lineWidth: 3)
            .overlay(
                VStack {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                    TextField(placeholder ?? "", value: $values, format: .number)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                }
            )
    }
}

struct InputDoubleWithoutIconTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InputDoubleWithoutIconTextFieldView(values: .constant(0), title: "Current Amount :")
    }
}
