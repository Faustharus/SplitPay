//
//  SecondPresentation.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/03/2022.
//

import SwiftUI

struct SecondPresentation: View {
    var body: some View {
        ZStack {
            Image("FirstPresentation")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Text("Second Presentation")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

struct SecondPresentation_Previews: PreviewProvider {
    static var previews: some View {
        SecondPresentation()
    }
}
