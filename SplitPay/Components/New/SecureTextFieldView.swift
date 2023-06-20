//
//  SecureTextFieldView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 08/05/2023.
//

import SwiftUI

struct SecureTextFieldView: View {
    
    @Binding var password: String
    @Binding var toSeePassword: Bool
    let placeholder: String?
    let sfSymbols: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(LinearGradient(colors: [Color.yellow.opacity(1), Color.yellow.opacity(0.7)], startPoint: .bottom, endPoint: .top).shadow(.inner(color: .black, radius: 2, x: 2, y: -2)))
            HStack {
                Image(systemName: "lock").foregroundColor(.white)
                ZStack(alignment: .leading) {
                    if toSeePassword {
                        TextField("", text: $password)
                            .foregroundColor(.white)
                            .font(.headline)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.default)
                    } else {
                        SecureField("", text: $password)
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.default)
                    }
                    ZStack {
                        Text(password.isEmpty ? placeholder ?? "********" : "")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }

                Button {
                    toSeePassword.toggle()
                } label: {
                    Image(systemName: toSeePassword ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.white.opacity(0.8))
                }
                .buttonStyle(.plain)
                .zIndex(1)
            }
            .padding(.horizontal, 10)
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .padding(.vertical, 10)

    }
}

struct SecureTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SecureTextFieldView(password: .constant("********"), toSeePassword: .constant(false), placeholder: "Password", sfSymbols: "lock", width: 300, height: 45)
    }
}
