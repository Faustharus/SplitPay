//
//  EmptyHistoricSplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/05/2022.
//

import SwiftUI

struct EmptyHistoricSplitView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Historic Split")
                .font(.title.bold())
            
            Spacer().frame(height: 10)
            
            Text("Vous voyez ici l'historique de tous vos splits")
            Text("Pour ajouter votre 1er split")
            Text("Rendez-vous sur la section Split.")
        }
        .font(.headline.italic())
        .multilineTextAlignment(.center)
    }
}

struct EmptyHistoricSplitView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyHistoricSplitView()
    }
}
