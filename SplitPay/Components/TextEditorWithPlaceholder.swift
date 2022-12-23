//
//  TextEditorWithPlaceholder.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 02/12/2022.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text("Write something...")
                        .padding(.top, 28)
                        .padding(.leading, 6)
                        .opacity(0.8)
                    Spacer()
                }
            }
            
            VStack(alignment: .center) {
                TextEditor(text: $text)
                    .opacity(text.isEmpty ? 0.85 : 1)
                    .clipShape(RoundedRectangle(cornerRadius: 7)).overlay(VStack{RoundedRectangle(cornerRadius: 7).stroke(.black, lineWidth: 3)})
                    .frame(minHeight: 40, maxHeight: 75)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 250)
            .frame(minHeight: 40, maxHeight: 75)
        }
    }
}

struct TextEditorWithPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorWithPlaceholder(text: .constant("Hello"))
            .previewLayout(.sizeThatFits)
    }
}
