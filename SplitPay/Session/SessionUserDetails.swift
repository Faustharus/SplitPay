//
//  SessionUserDetails.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 06/04/2022.
//

import Foundation
import UIKit

struct SessionUserDetails: Hashable {
    var id: String
    var email: String
    var firstName: String
    var surName: String
    var nickName: String
    var extNickName: String
    var picture: UIImage?
    var profilePicture: String
    var withContact: Bool
    //var friend: [String] = []
    //var isFriend: [Friends]
    var isSendingInvit: [SessionRequestSent] = []
    var isReceivingInvit: [SessionRequestReceived] = []
    
    //var isSendingInvit: Bool?
    //var isReceivingInvit: Bool?
    //var contacts: [SessionUserDetails]?
    //var isConnected: Bool
    //var conversation: [String]
    /* Vérifier le type de model applicable pour la var de Conversation ;
     ce sera probablement un tableau bi-dimensionnel.
     Le 1er correspondant aux contacts qui sont amis
      & le 2ème correspondant au tableau de chaines de charactères contenant la dite conversation */
}

struct SessionRequestSent: Identifiable, Hashable {
    var id: String
    var requestType: String
    var isSent: Bool
    //var whenIsSent: Timestamp
}

struct SessionRequestReceived: Identifiable, Hashable {
    var id: String
    var requestType: String
    var isReceived: Bool
    //var whenIsReceived: Timestamp
}
