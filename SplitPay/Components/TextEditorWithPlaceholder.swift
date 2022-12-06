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
                        .padding(.top, 10)
                        .padding(.leading, 8)
                        .opacity(0.8)
                    Spacer()
                }
            }
            
            VStack {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(.black, lineWidth: 3)
                    .overlay(
                        ZStack {
                            TextEditor(text: $text)
                                .opacity(text.isEmpty ? 0.85 : 1)
                                .frame(width: 230, height: 35)
                        }
                    )
                Spacer()
            }
            .frame(width: 250, height: 50)
        }
    }
}

struct TextEditorWithPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorWithPlaceholder(text: .constant("Hello"))
            .previewLayout(.sizeThatFits)
    }
}
