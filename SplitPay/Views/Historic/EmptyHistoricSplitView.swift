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
                .font(.title)
            
            Text("Vous voyez ici l'historique de tous vos splits. \n Pour ajouter votre premier split - rendez-vous sur la section Split.")
                .multilineTextAlignment(.center)
        }
    }
}

struct EmptyHistoricSplitView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyHistoricSplitView()
    }
}
