//
//  SplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/03/2022.
//

import SwiftUI

struct SplitView: View {
    
    @State private var amount: Double = 0
    @State private var percentPosition: Int = 0
    let percentage = [0, 10, 15, 20, 25]
    @State private var currencyPosition: Int = 0
    let currencySigns = ["eurosign.circle", "dollarsign.circle", "sterlingsign.circle", "yensign.circle", "indianrupeesign.circle", "pesosign.circle", "brazilianrealsign.circle"]
    //let currencyNames = ["Euro", "Dollar", "Pounds", "Yen", "Indian Rupee", "Pesos", "Brazilian Real"]
    let currencyCode = ["EUR", "USD", "GBP", "JPY", "INR", "MXN", "BRL"]
    @State private var numOfPersons = [Double]()
    
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        ZStack {
            // Background ???
            
            VStack {
                
                VStack {
                    Picker("", selection: $currencyPosition) {
                        ForEach(0 ..< currencySigns.count, id: \.self) { item in
                            Text("\(currencyCode[item])")
                        }
                    }
                    .pickerStyle(.menu)
                    
                    HStack {
                        Image(systemName: "\(currencySigns[currencyPosition])")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                        
                        
                        TextField("\(amount, specifier: "%2.f")", value: $amount, format: .number)
                            .frame(height: 55)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .focused($amountIsFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(.black, lineWidth: 3)
                            )
                        
                        
                    }
                }
                .padding(.all, 10)
                
                
                
                // MARK: - Number of Persons
                HStack {
                    Button(action: {
                        numOfPersons.append(1)
                    }) {
                        Circle()
                            .stroke(.black, lineWidth: 3)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22)
                                    .foregroundColor(.black)
                            )
                    }
                    .padding(.horizontal, 10)

                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(numOfPersons, id: \.self) { item in
                                VStack {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44)
                                    Text("Person")
                                        .font(.subheadline)
                                }
                                .onTapGesture {
                                    numOfPersons.removeAll(keepingCapacity: true)
                                }
                            }
                        }
                    }
                }
                .padding(.all, 15)
                
                
                
                // MARK: - Percentage
                Picker("", selection: $percentPosition) {
                    ForEach(0 ..< percentage.count, id: \.self) {
                        Text("\(percentage[$0])%")
                    }
                }
                .pickerStyle(.segmented)
                .padding(.all, 15)
                
                // MARK: - Buttons
                HStack {
                    Button {
                        // TODO: More Code Later
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "plus")
                                .offset(x: UIScreen.main.bounds.width * 0.07, y: -10)
                                .zIndex(1)
                            VStack {
                                Text("Create Group")
                                
                            }
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .frame(maxWidth: 200, maxHeight: 55)
                        .background(.blue)
                        .cornerRadius(7)
                        .padding(.all, 5)
                    }
                    
                    Button {
                        amountIsFocused = false
                        self.amount = 0.0
                        percentPosition = 0
                        numOfPersons.removeAll()
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "trash")
                                .offset(x: UIScreen.main.bounds.width * 0.16, y: -10)
                                .zIndex(1)
                            VStack {
                                Text("Reset")
                                
                            }
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .frame(maxWidth: 200, maxHeight: 55)
                        .background(.red)
                        .cornerRadius(7)
                        .padding(.all, 5)
                    }
                }
                
                Spacer()
                
                Button {
                    // TODO: More Code Later
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "checkmark")
                            .offset(x: UIScreen.main.bounds.width * 0.09, y: -10)
                            .zIndex(1)
                        VStack {
                            Text("Calculating")
                            
                        }
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .frame(maxWidth: 200, maxHeight: 55)
                    .background(amount == 0 || numOfPersons.isEmpty ? .gray : .green)
                    .cornerRadius(7)
                    .padding(.all, 5)
                }
                .disabled(amount == 0 || numOfPersons.isEmpty)
                
                Spacer()
                Text("Result in \(Image(systemName: currencySigns[currencyPosition])) : \(billWithTips, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .semibold, design: .serif))
                
                Text("Without Tips : \(billWithoutTips, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .semibold, design: .serif))
                
            }
            
            
        }
        .navigationBarHidden(true)
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
    }
}


// MARK: - Computed Properties
extension SplitView {
    
    var billWithTips: Double {
        let price = amount
        let peopleCount = numOfPersons
        let currentPercent = Double(percentage[percentPosition])

        if peopleCount.isEmpty {
            return 0.0
        } else {
            let priceDivided = price / peopleCount.reduce(0, { x, y in
                x + y
            })
            let priceTiped = priceDivided * (currentPercent / 100.0)
            let result = priceDivided + priceTiped

            return result
        }
    }
    
    var billWithoutTips: Double {
        let price = amount
        let peopleCount = numOfPersons
        
        if peopleCount.isEmpty {
            return 0.0
        } else {
            let priceDivided = price / peopleCount.reduce(0, { x, y in
                x + y
            })
            return priceDivided
        }
    }
    
}
