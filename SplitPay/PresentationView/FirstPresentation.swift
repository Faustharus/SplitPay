//
//  FirstPresentation.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/03/2022.
//

import SwiftUI

struct FirstPresentation: View {
    var body: some View {
        ZStack {
            Image("MainBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Text("Welcome to SplitPay")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

struct FirstPresentation_Previews: PreviewProvider {
    static var previews: some View {
        FirstPresentation()
    }
}
