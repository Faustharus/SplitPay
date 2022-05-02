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
                VStack {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(.black, lineWidth: 3)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 5)
                            .shadow(color: .black, radius: 5, x: 1, y: 10)
                        VStack {
                            HStack {
                                Text("\(Date().formatted())")
                                
                                Spacer()
                                    .frame(maxWidth: 50)
                                
                                Text("Currency: \(item.currencyName)")
                            }
                            .font(.system(.headline))
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Initial Amount: \(item.initialAmount, specifier: "%.2f") €")
                                    Text("Percentage Applied: \(item.percentages) %")
                                }
                                Rectangle()
                                    .frame(width: 1, height: 50)
                                    .foregroundColor(.gray)
                                
                                Text("N° of Persons: \(item.indexOfPersons)")
                            }
                            .padding(.vertical, 10)
                            
                            Text("Splited Amount: \(item.splitedAmount, specifier: "%.2f") €")
                        }
                    }
                    
                }
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
