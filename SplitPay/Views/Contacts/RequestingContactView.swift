//
//  RequestingContactView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 27/08/2022.
//

import SwiftUI

struct RequestingContactView: View {
    
    @StateObject var vm = FriendRequestViewModelImpl(service: FriendRequestServiceImpl())
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var isFriended: Bool = false
    //@Binding var isFriended: Bool
    
    let user: SessionUserDetails
    
    var body: some View {
        ZStack {
            //background ?
            VStack {
                
                if user.profilePicture.isEmpty {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125)
                } else {
                    AsyncImage(url: URL(string: "\(user.profilePicture)")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.red.frame(width: 125)
                    }
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                }
                
                VStack {
                    HStack {
                        Text("\(user.firstName)")
                            .font(.title)
                        Text("\(user.surName)")
                            .font(.title)
                    }
                    Text("\(user.extNickName)")
                        .font(.subheadline)
                    
                    
                    ActionButtonView(title: isFriended ? "Request Sent" : "Requesting as Contact", foreground: isFriended ? .blue : .white, background: isFriended ? .white : .blue, sfSymbols: "person.badge.plus") {
                        self.isFriended = true
                        //sessionService.newFriend(with: user.id)
                        vm.makeNewRequest(with: user.id)
                    }
                    
                    if isFriended {
                        ActionButtonView(title: "Cancel Request", foreground: .white, background: .red, sfSymbols: "xmark") {
                            self.isFriended = false
                        }
                    }
                    
                    HStack(spacing: 10) {
                        VStack(spacing: 5) {
                            Text("Inscrit depuis le :")
                                .font(.subheadline)
                            Text("27/08/22 à 17:38")
                                .font(.caption).bold()
                        }
                        
                        VStack(spacing: 5) {
                            Text("Nombre de SplitPay effectué :")
                                .font(.subheadline)
                            Text("100")
                                .font(.caption).bold()
                        }
                    }
                    .multilineTextAlignment(.center)
                    
                    //Spacer()
                }
            }
            .padding()
        }
    }
}

struct RequestingContactView_Previews: PreviewProvider {
    static var previews: some View {
        RequestingContactView(user: SessionUserDetails.init(id: "", email: "Example@email.com", firstName: "Rodney", surName: "McKay", nickName: "Rod", extNickName: "Rod#4826", profilePicture: "", withContact: false))
            .environmentObject(SessionServiceImpl())
    }
}
