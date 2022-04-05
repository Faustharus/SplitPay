//
//  ContentView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 26/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var startPosY: CGFloat = UIScreen.main.bounds.height * 0.90
    @State private var currentPosY: CGFloat = 0
    @State private var endPosY: CGFloat = 0
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.black, .purple, .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                CredentialsView()
                    .offset(y: startPosY)
                    .offset(y: currentPosY)
                    .offset(y: endPosY)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.spring()) {
                                    currentPosY = value.translation.height
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring()) {
                                    if currentPosY < -150 {
                                        endPosY = -startPosY
                                    } else if endPosY != 0 && startPosY > 150 {
                                        endPosY = 0
                                    }
                                    currentPosY = 0
                                }
                            }
                )
            }
            .zIndex(1)
            
            TabView {
                FirstPresentation()
                    .tag(1)
                
                SecondPresentation()
                    .tag(2)
                
                ThirdPresentation()
                    .tag(3)
                
            }
            .tabViewStyle(.page)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
