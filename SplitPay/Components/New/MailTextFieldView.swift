//
//  MailTextFieldView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 08/05/2023.
//

import SwiftUI

struct MailTextFieldView: View {
    
    @Binding var email: String
    let placeholder: String?
    let sfSymbols: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(LinearGradient(colors: [Color.yellow.opacity(1), Color.yellow.opacity(0.7)], startPoint: .top, endPoint: .bottom).shadow(.inner(color: .black, radius: 2, x: 2, y: -2)))
            HStack {
                Image(systemName: sfSymbols).foregroundColor(.white)
                ZStack(alignment: .leading) {
                    TextField(placeholder ?? "", text: $email)
                        .foregroundColor(.white)
                        .font(.headline)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                    VStack {
                        Text(email.isEmpty ? "Email" : "")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct MailTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MailTextFieldView(email: .constant("email@example.com"), placeholder: "Email", sfSymbols: "envelope", width: 300, height: 45)
    }
}
