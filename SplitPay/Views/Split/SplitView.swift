//
//  SplitView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/03/2022.
//

import SwiftUI

struct SplitView: View {
    
    enum Field {
        case totalAmount
        case nbPersons
    }
    
    @StateObject private var vm = SplitingViewModelImpl(service: SplitingServiceImpl())
    
    @State private var amount: Double = 0
    @State private var currencyPosition: Int = 0
    @State private var numOfPersons = [Int]()
    @State private var changeCurrency: Bool = false
    
    @FocusState private var amountIsFocused: Field?
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        ZStack {
            // Background ???
            
            VStack {
                
                ScrollView {
                    DisclosureGroup("Choose a Currency", isExpanded: $changeCurrency) {
                        VStack {
                            ForEach(vm.options, id: \.self) { item in
                                Text(item)
                                    .foregroundColor(vm.selectedOptions == item ? .blue : .black)
                                    .onTapGesture {
                                        self.vm.selectedOptions = ("\(item)")
                                        withAnimation {
                                            self.changeCurrency.toggle()
                                        }
                                    }
                                    .padding(.vertical, 1)
                            }
                        }
                        .padding()
                    }
                    .frame(width: 350)
                    List {
                        ForEach(vm.currencies) { item in
                            HStack {
                                Image(systemName: item.symbols)
                                Text(item.names)
                                Spacer()
                                Text(item.code)
                            }
                        }
                    }
                    .frame(height: 50)
                    .listStyle(.plain)
                    
                    Spacer().frame(height: 15)
                    
                    Section(header: Text("Tips Percentage").font(.system(size: 16, weight: .bold, design: .serif))) {
                        Picker("", selection: $vm.splitDetails.percentages) {
                            ForEach(SplitingDetails.percentArray, id: \.self) {
                                Text("\($0.reelValue)%")
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 10)
                    }
                    
                    Spacer().frame(height: 25)
                    
                    HStack {
                        InputDoubleWithoutIconTextFieldView(values: $vm.splitDetails.initialAmount, title: "Current Amount :")
                            .focused($amountIsFocused, equals: .totalAmount)
                            .submitLabel(.next)
                        
                        InputIntWithoutIconTextFieldView(values: $vm.splitDetails.indexOfPersons, title: "Nb of Persons :")
                            .focused($amountIsFocused, equals: .nbPersons)
                            .submitLabel(.join)
                    }
                    .padding(.horizontal, 10)
                    .frame(width: 400, height: 100)
                    
                    Spacer().frame(height: 25)
                    
                    HStack {
                        IconActionButtonView(title: "Continue", foreground: .white, background: vm.splitDetails.initialAmount == 0 || numOfPersons.isEmpty && vm.splitDetails.indexOfPersons == 0 ? .gray : .green, sfSymbols: "checkmark.circle", offsetSymbols: 0.09) {
                            vm.addSplitToReview()
                        }
                        .disabled(vm.splitDetails.initialAmount == 0 || numOfPersons.isEmpty && vm.splitDetails.indexOfPersons == 0)
                        
                        IconActionButtonView(title: "Reset", foreground: .white, background: .red, sfSymbols: "trash", offsetSymbols: 0.15) {
                            reset()
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(width: 400, height: 100)
                    
                    NavigationButtonView(title: "Calculating", foreground: .white, background: vm.splitDetails.initialAmount == 0 || numOfPersons.isEmpty && vm.splitDetails.indexOfPersons == 0 ? .gray : .blue, sfSymbols: "plus.forwardslash.minus") {
                        DistributionView()
                    }
                    .disabled(vm.splitDetails.initialAmount == 0 || numOfPersons.isEmpty && vm.splitDetails.indexOfPersons == 0)
                    .padding(.horizontal, 10)
                    .frame(width: 400, height: 100)
                    
                }
                .padding(.all, 5)
                
                // MARK: - Add People Section
//                if sessionService.userDetails.withContact {
//                HStack {
//                    Button(action: {
//                        numOfPersons.append(1)
//                    }) {
//                        Circle()
//                            .stroke(.black, lineWidth: 3)
//                            .frame(width: 44, height: 44)
//                            .overlay(
//                                Image(systemName: "plus")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 22)
//                                    .foregroundColor(.black)
//                            )
//                    }
//                    .padding(.horizontal, 10)
//
//                    ScrollView(.horizontal) {
//                        HStack {
//                            ForEach(numOfPersons, id: \.self) { item in
//                                VStack {
//                                    Image(systemName: "person.crop.circle")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 44)
//                                    Text("Person")
//                                        .font(.subheadline)
//                                }
//                                .onTapGesture {
//                                    numOfPersons.removeAll(keepingCapacity: true)
//                                }
//                            }
//                        }
//                    }
//                }
//                .onAppear(perform: personReset)
//                .frame(maxHeight: 66)
//                .padding(.all, 15)
//
//                } else {
//
//                    VStack {
//                        HStack {
//                            Image(systemName: "person.3.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 44)
//                            TextField("", value: $vm.splitDetails.indexOfPersons, format: .number)
//                                .frame(height: 55)
//                                .keyboardType(.decimalPad)
//                                .multilineTextAlignment(.center)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 7)
//                                        .stroke(.black, lineWidth: 3)
//                                )
//                        }
//                    }
//                    .onAppear(perform: personReset)
//                    .frame(maxHeight: 66)
//                    .padding(.all, 10)
//
//                }
                
                Spacer()
                
                Text("Result in : \(sessionService.userDetails.withContact ? billArrayWithTips : billWithTips, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .semibold, design: .serif))
                
                
                Text("Without Tips : \(sessionService.userDetails.withContact ? billArrayWithoutTips : billWithoutTips, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .semibold, design: .serif))
                
            }
            .navigationTitle("Split")
            .navigationBarTitleDisplayMode(.inline)
        
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
            .environmentObject(SessionServiceImpl())
    }
}


// MARK: - Computed Prop & Func
extension SplitView {
    
    // Reset all
    func reset() {
        //amountIsFocused = false
        vm.splitDetails.initialAmount = 0.0
        vm.splitDetails.percentages = PercentageDetails.init(reelValue: 0, position: 0)
        vm.splitDetails.indexOfPersons = 0
        numOfPersons.removeAll()
    }
    
    // Reset number of persons added on the calculation
    func personReset() {
        if sessionService.userDetails.withContact {
            vm.splitDetails.indexOfPersons = 0
        } else {
            numOfPersons.removeAll()
        }
    }
    
    var billArrayWithTips: Double {
        let price = amount
        let peopleArrayCount = numOfPersons as? [Double]
        let currentPercent = SplitingDetails.percentArray[vm.splitDetails.percentages.position]
        
        if peopleArrayCount == nil {
            return 0.0
        } else {
            let priceDivided = price / (peopleArrayCount?.reduce(0, { x, y in
                x + y
            }) ?? 0.0)
            let priceTiped = priceDivided * (Double(currentPercent.reelValue) / 100.0)
            let result = priceDivided + priceTiped

            return result
        }
    }
    
    var billArrayWithoutTips: Double {
        let price = amount
        let peopleArrayCount = numOfPersons as? [Double]
        
        if peopleArrayCount == nil {
            return 0.0
        } else {
            let priceDivided = price / (peopleArrayCount?.reduce(0, { x, y in
                x + y
            }) ?? 0.0)
            return priceDivided
        }
    }
    
    var billWithTips: Double {
        let price = vm.splitDetails.initialAmount
        let peopleCount = vm.splitDetails.indexOfPersons
        let currentPercent = SplitingDetails.percentArray[vm.splitDetails.percentages.position]

        if peopleCount == 0 {
            return 0.0
        } else {
            let priceDivided = price / Double(peopleCount)
            let priceTiped = priceDivided * (Double(currentPercent.reelValue) / 100.0)
            let result = priceDivided + priceTiped
            
            return result
        }
    }
    
    var billWithoutTips: Double {
        let price = vm.splitDetails.initialAmount
        let peopleCount = vm.splitDetails.indexOfPersons
        
        if peopleCount == 0 {
            return 0.0
        } else {
            let priceDivided = price / Double(peopleCount)
            return priceDivided
        }
    }
    
}


// MARK: - View Components
extension SplitView {
    
//    @ViewBuilder
//    var destinationView: some View {
//        if textFieldOrNot {
//            DistributionView()
//        } else {
//            HistoricSplitView()
//        }
//    }
    
}
