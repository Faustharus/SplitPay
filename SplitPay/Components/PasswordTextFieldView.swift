//
//  PasswordTextFieldView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/03/2022.
//

import SwiftUI

struct PasswordTextFieldView: View {
    
    @Binding var password: String
    @Binding var toSeePassword: Bool
    let placeholder: String
    let sfSymbols: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 7).stroke(.black, lineWidth: 3)
            .frame(maxWidth: .infinity, maxHeight: 55)
            .overlay(
                HStack {
                    Image(systemName: sfSymbols)
                    if toSeePassword {
                        TextField(placeholder, text: $password)
                            .keyboardType(.default)
                    } else {
                        SecureField(placeholder, text: $password)
                            .keyboardType(.default)
                    }
                    
                    Button {
                        toSeePassword.toggle()
                    } label: {
                        Image(systemName: toSeePassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    .buttonStyle(.plain)
                    .zIndex(1)
                }
                    .padding(.horizontal, 5)
            )
    }
}

struct PasswordTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextFieldView(password: .constant(""), toSeePassword: .constant(false), placeholder: "Password", sfSymbols: "lock")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
