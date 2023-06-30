//
//  FriendSearchView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/06/2023.
//

import SwiftUI

struct FriendSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            
            
            Button {
                dismiss()
            } label: {
                Text("Back")
            }
        }
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FriendSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSearchView()
    }
}
