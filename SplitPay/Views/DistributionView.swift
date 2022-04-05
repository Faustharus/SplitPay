//
//  DistributionView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 03/04/2022.
//

import SwiftUI

struct DistributionView: View {
    
    @State private var globalAmount: Double = 180
    @State var totalSum: Double = 180
    let numOfPersons: [Double] = [1, 2, 3, 4, 5, 6]
    let sumOfPersons: [Double] = [1, 1, 1, 1, 1, 1]
    
    var body: some View {
        ZStack {
            // Background ???
            VStack {
                TextField("", value: $globalAmount, format: .number)
                    .frame(height: 55)
                    .multilineTextAlignment(.center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(.black, lineWidth: 2)
                    )
                    .padding()
                
                Text("Total expected: \(totalSum)€")
                
                ForEach(numOfPersons, id: \.self) { item in
                    DetailDistributionView(userNum: Int(item), globalAmount: globalAmount, amount: totalExpected)
                }
                
                Button(action: {
                    // TODO: More Code Later
                }) {
                    Text("Send")
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 55)
                        .background(.green)
                        .cornerRadius(7)
                        .padding(.horizontal, 15)
                }
                
                
            }
        }
    }
    
    var totalExpected: Double {
        let initialAmount = globalAmount
        let sumPeople = sumOfPersons.reduce(0, { x, y in
            x + y
        })
        let total = initialAmount / sumPeople
        return total
    }
    
    var numOfPersonsHere: Double {
        let sumPeople = sumOfPersons.reduce(0, { x, y in
            x + y
        })
        return sumPeople
    }
    
}

struct DistributionView_Previews: PreviewProvider {
    static var previews: some View {
        DistributionView()
    }
}

struct DetailDistributionView: View {
    
    var userNum: Int
    var globalAmount: Double
    @State var amount: Double
    
    var body: some View {
        let binding = Binding(
            get: { self.amount },
            set: { self.amount = $0 }
        )
        ZStack {
            // Background ???
            VStack {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                    Text("Person \(userNum) - \(amount, specifier: "%.2f")€")
                        .font(.system(size: 16, design: .serif))
                }
                Slider(value: binding, in: 0...globalAmount, step: 0.01) {
                    Text("Test")
                } minimumValueLabel: {
                    Text("0€")
                } maximumValueLabel: {
                    Text("\(globalAmount, specifier: "%.2f")€")
                }
                
            }
            .padding()
        }
    }
}
