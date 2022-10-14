//
//  SearchContactsView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 04/08/2022.
//

import SwiftUI
import FirebaseAuth

struct SearchContactsView: View {
    
    @State private var searchText: String = ""
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    let detailsArray: [SessionUserDetails]
    
    var body: some View {
        VStack {
            Text("\(searchText)")
                .searchable(text: $searchText, prompt: "Search...")
            
            //Text("List of all contacts in the app")
            if !searchText.isEmpty {
                List {
                    ForEach(searchContacts, id: \.self) { item in
                        NavigationLink(destination: RequestingContactView(user: item)) {
                            HStack {
                                Text(item.firstName)
                                
                                Spacer().frame(width: 3)
                                
                                Text(item.surName)
                            }
                        }.swipeActions(edge: .trailing) {
                            Button {} label: { Image(systemName: "plus") }.background(Color.blue)
                        }
//                        NavigationLink {
//                            RequestingContactView(user: item)
//                        } label: {
//                            HStack {
//                                Text(item.firstName)
//
//                                Spacer().frame(width: 3)
//
//                                Text(item.surName)
//                            }
//                        }
                    }
                }
            }
        }
    }
}

struct SearchContactsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchContactsView(detailsArray: [SessionUserDetails.init(id: "", email: "", firstName: "", surName: "", nickName: "", extNickName: "", profilePicture: "", withContact: false)])
            .environmentObject(SessionServiceImpl())
    }
}

// MARK: - Computed Properties
extension SearchContactsView {
    
    var searchContacts: [SessionUserDetails] {
        if searchText.isEmpty {
            return detailsArray
        } else {
            return detailsArray.filter { $0.extNickName == searchText }
        }
    }
    
}
