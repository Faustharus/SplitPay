//
//  SearchContactsView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/08/2022.
//

import SwiftUI

struct SearchContactsView: View {

    @State private var searchText: String = ""

    var body: some View {
        VStack {
            Text("\(searchText)")
                .searchable(text: $searchText, prompt: "Search...")

            Text("List of all contacts in the app")
        }

    }
}

struct SearchContactsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchContactsView()
    }
}
