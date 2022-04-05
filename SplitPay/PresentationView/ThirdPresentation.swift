//
//  ThirdPresentation.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 29/03/2022.
//

import SwiftUI

struct ThirdPresentation: View {
    var body: some View {
        ZStack {
            Image("SecondPresentation")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Text("Third Presentation")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

struct ThirdPresentation_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPresentation()
    }
}
