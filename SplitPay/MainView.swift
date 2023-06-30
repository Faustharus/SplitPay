//
//  MainView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import SwiftUI

enum PageSelected: String, Identifiable {
    case split, test, review, profile
    //case split, chat, review, profile
    
    var id: Int {
        hashValue
    }
}

struct MainView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        TabView {
            NavigationStack {
                SplitShareView()
            }
            .tabItem {
                Image(systemName: "banknote")
                Text("Split")
            }
            .tag(PageSelected.split)
            
//            ChatRoomView()
//                .tabItem {
//                    Image(systemName: "person.3")
//                    Text("Chat")
//                }
//                .tag(PageSelected.chat)
            
            NavigationStack {
                HistoricSplitView()
            }
            .tabItem {
                Image(systemName: "chart.bar.xaxis")
                Text("Review")
            }
            .tag(PageSelected.review)
            
            NavigationStack {
                SettingProfileView()
            }
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
