//
//  SplitPayApp.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 26/03/2022.
//

import Firebase
import SwiftUI
//import SocketIO

@available(iOS 13.0, *)

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SplitPayApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    //@ObservedObject var socket = SocketMain() // Mauvais endroit <- A appliquer sur le login/signin et logout
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch sessionService.state {
                case .loggedIn:
                    MainView()
                        .environmentObject(sessionService)
                case .loggedOut:
                    CredentialsView()
                }
            }
        }
        //        WindowGroup {
        //            //InscriptionView()
        //            //ConnectionView()
        //        }
    }
}
