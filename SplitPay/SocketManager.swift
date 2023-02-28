//
//  SocketManager.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 15/01/2023.
//

import Foundation
import SocketIO

class SocketHandler {
    
    static let shared = SocketHandler()
    
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
    
    var mSocket: SocketIOClient!
    
    init() {
        setupSocket()
        setupSocketEvents()
        manager.setConfigs([.secure(true), .log(true), .compress])
    }
    
    func setupSocket() {
        self.mSocket = manager.defaultSocket
    }
    
    func getSocket() -> SocketIOClient {
        return mSocket!
    }
    
    func setupSocketEvents() {
        mSocket.on(clientEvent: .connect, callback: { data, ack in
            print("Connected")
        })
    }
    
    func establishConnection() {
        mSocket.connect()
    }
    
    func closeConnection() {
        mSocket.disconnect()
    }
    
    
}
