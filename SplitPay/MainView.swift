//
//  MainView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import SwiftUI

enum PageSelected: String {
    case split, review, profile
}

struct MainView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        TabView {
            SplitView()
                .tabItem {
                    Image(systemName: "banknote")
                    Text("Split")
                }
                .tag(PageSelected.split)
            
            HistoricSplitView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Review")
                }
                .tag(PageSelected.review)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(PageSelected.profile)
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SessionServiceImpl())
    }
}
