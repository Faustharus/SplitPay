//
//  NavigationButtonView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/06/2022.
//

import SwiftUI

struct NavigationButtonView<Content>: View where Content: View {
    
    let content: () -> Content
    
    let title: String
    let foreground: Color
    let background: Color
    let sfSymbols: String?
    
    init(title: String, foreground: Color, background: Color, sfSymbols: String, @ViewBuilder _ content: @escaping () -> Content) {
        self.title = title
        self.foreground = foreground
        self.background = background
        self.sfSymbols = sfSymbols
        self.content = content
    }
    
    var body: some View {
        NavigationLink {
            content()
        } label: {
            HStack {
                Text(title)

                Image(systemName: sfSymbols ?? "")
            }
            .foregroundColor(foreground)
            .font(.system(.title3, design: .serif).weight(.semibold))
        }
        .frame(maxWidth: .infinity, maxHeight: 55)
        .background(background)
        .cornerRadius(7)
 
    }
}

//struct NavigationButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationButtonView<SearchContactsView>(title: "New Contact", foreground: .white, background: .blue, sfSymbols: "person") { SearchContactsView(detailsArray: [SessionUserDetails.init(id: "", email: "", firstName: "", surName: "", nickName: "", extNickName: "", profilePicture: "", withContact: false)]) }
//    }
//}
