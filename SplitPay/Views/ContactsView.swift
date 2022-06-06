//
//  ContactsView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/06/2022.
//

import SwiftUI

struct SearchContactsView: View {
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            Text("\(searchText)")
                .searchable(text: $searchText, prompt: "Search...")
        }
        
    }
}


struct ContactsView: View {
    
    let names = ["John Doe", "Jane Doe", "Monsieur X", "Madame Y", "I'm Everyone"]
    
    var body: some View {
        VStack {
            List(names, id: \.self) { item in
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                    
                    VStack(alignment: .leading) {
                        Text("\(item)")
                            .font(.title2).bold()
                        Text("New message !")
                    }
                }
            }
            .listStyle(.plain)
            
            NavigationButtonView(title: "New Contact", foreground: .white, background: .blue, sfSymbols: "person") {
                SearchContactsView()
            }
            .padding(.all, 10)
            
        }
        
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
