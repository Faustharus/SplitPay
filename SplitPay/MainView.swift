//
//  MainView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import SwiftUI

enum PageSelected: String {
    case split, profile
}

struct MainView: View {
    var body: some View {
        TabView {
            SplitView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Split")
                }
                .tag(PageSelected.split)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
                .tag(PageSelected.profile)
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
