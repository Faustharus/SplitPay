//
//  HistoricSplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 13/04/2022.
//

import FirebaseAuth
import SwiftUI

struct HistoricSplitView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        ScrollView {
            Text("Historic View")
                .font(.title.weight(.bold))
            
            // ForEach of the Split - Creating an Historic
            ForEach(sessionService.splitArray, id: \.self) { item in
                HistoricDetailsSplitView(currencyName: item.currencyName, initialAmount: item.initialAmount, percentageApplied: item.percentageApplied, nbOfPersons: item.nbOfPersons, splitedAmount: item.splitedAmount)
            }
            .onAppear {
                sessionService.splitRefresh(with: Auth.auth().currentUser!.uid)
            }
            // .onDelete built-in func needed
        }
    }
}

struct HistoricSplitView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricSplitView()
            .environmentObject(SessionServiceImpl())
    }
}
