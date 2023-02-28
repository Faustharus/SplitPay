//
//  FriendRequestView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 08/01/2023.
//

import SwiftUI

struct FriendRequestView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let reqReceivedCount = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"]
    
    var body: some View {
        GeometryReader { proxy in
            
            let width: CGFloat = proxy.size.width
            let height: CGFloat = proxy.size.height
            
            VStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .padding(.leading, 10)
                
                List(0 ..< reqReceivedCount.count, id: \.self) { _ in
                    VStack(alignment: .center) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width / 16, height: height / 16)
                                .foregroundColor(.red)
                                .padding(.horizontal, 15)
                            
                            Spacer()
                            
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width / 8, height: height / 8)
                            
                            VStack(alignment: .leading) {
                                Text("Rodney McKay")
                                    .font(.system(size: 18, weight: .bold, design: .serif))
                                Text("#Rod5155")
                                    .font(.system(size: 12, weight: .light, design: .monospaced))
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    // TODO: More Code Later
                                } label: {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: width / 16, height: height / 16)
                                    Text("Accept")
                                        .font(.system(size: 8, design: .rounded))
                                }
                            }
                            .tint(.green)
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    // TODO: More Code Later
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: width / 16, height: height / 16)
                                    Text("Decline")
                                        .font(.system(size: 8, design: .rounded))
                                }
                                .tint(.red)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width / 16, height: height / 16)
                                .foregroundColor(.green)
                                .padding(.horizontal, 15)
                        }
                    }
                    .frame(width: width, height: height / CGFloat(reqReceivedCount.count))
                }
                .listStyle(.grouped)
            }
        }
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView()
    }
}
