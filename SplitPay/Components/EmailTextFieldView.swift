//
//  EmailTextFieldView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/03/2022.
//

import SwiftUI

struct EmailTextFieldView: View {
    
    @Binding var email: String
    let placeholder: String
    let sfSymbols: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 7).stroke(.black, lineWidth: 3)
            .frame(maxWidth: .infinity, maxHeight: 55)
            .overlay(
                HStack {
                    Image(systemName: sfSymbols)
                    TextField(placeholder, text: $email)
                }
                    .padding(.leading, 5)
            )
    }
}

struct EmailTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        EmailTextFieldView(email: .constant(""), placeholder: "Email", sfSymbols: "envelope")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
