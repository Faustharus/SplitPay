//
//  InfoTextFieldView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 10/05/2023.
//

import SwiftUI

struct InfoTextFieldView: View {
    
    @Binding var candidateText: String
    let candidateInfo: String
    let placeholder: String?
    let sfSymbols: String?
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(LinearGradient(colors: [Color.yellow.opacity(1), Color.yellow.opacity(0.7)], startPoint: .top, endPoint: .bottom).shadow(.inner(color: .black, radius: 2, x: 2, y: -2)))
            HStack {
                Image(systemName: sfSymbols ?? "").foregroundColor(.white)
                ZStack(alignment: .leading) {
                    TextField(placeholder ?? "", text: $candidateText)
                        .foregroundColor(.white)
                        .font(.headline)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                    VStack {
                        Text(candidateText.isEmpty ? candidateInfo : "")
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

struct InfoTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InfoTextFieldView(candidateText: .constant("Last Name"), candidateInfo: "Last Name", placeholder: "", sfSymbols: "person.crop.circle", width: 300, height: 45)
    }
}
