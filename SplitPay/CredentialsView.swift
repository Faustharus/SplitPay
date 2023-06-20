//
//  CredentialsView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/03/2022.
//

import SwiftUI

struct CredentialsView: View {
    
    @State private var changePage: Bool = false
    
    var body: some View {
        VStack {
            if changePage {
                InscriptionView(changePage: $changePage)
            } else {
                ConnectionView(changePage: $changePage)
            }
        }
        .navigationBarHidden(true)
    }
}

struct CredentialsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CredentialsView()
        }
    }
}
