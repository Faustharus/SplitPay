//
//  MainView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import SwiftUI

enum PageSelected: String {
    case split, chat, review, profile
}

struct MainView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var mSocket = SocketHandler.shared.getSocket()
    
    var body: some View {
        TabView {
            SplitView()
                .tabItem {
                    Image(systemName: "banknote")
                    Text("Split")
                }
                .tag(PageSelected.split)
            
            ChatRoomView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Chat")
                }
                .tag(PageSelected.chat)
            
            HistoricSplitView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Review")
                }
                .tag(PageSelected.review)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gearshape.2")
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
