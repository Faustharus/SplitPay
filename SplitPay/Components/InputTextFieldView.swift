//
//  InputTextFieldView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import SwiftUI

struct InputTextFieldView: View {
    
    @Binding var text: String
    let placeholder: String
    let sfSymbols: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 7).stroke(.black, lineWidth: 3)
            .frame(maxWidth: .infinity, maxHeight: 55)
            .overlay(
                HStack {
                    Image(systemName: sfSymbols)
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.none)
                        .keyboardType(.default)
                }
                    .padding(.leading, 5)
            )
    }
}

struct InputTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InputTextFieldView(text: .constant(""), placeholder: "Name", sfSymbols: "person")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
