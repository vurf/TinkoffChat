//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/3/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol StorageManagerProtocol: class {
    func recieveMessage(text: String, fromUser: String,toUser:String)
    func didFoundUser(userID:String,userName:String?)
    func didLostUser(userID:String)
}

class CommunicationManager : NSObject, CommuncatorDelegate {
    
    let multipeerCommunicator : MultipeerCommunicator = MultipeerCommunicator()
    var storage : StorageManagerProtocol
    
    init(storage : StorageManagerProtocol) {
        self.storage = storage
        super.init()
        self.multipeerCommunicator.delegate = self
        self.multipeerCommunicator.start()
    }
    
    deinit {
        self.multipeerCommunicator.stop()
    }
    
    func didFoundUser(userID: String, userName: String?) {
        self.storage.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        self.storage.didLostUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        // Ignore
    }
    
    func failedToStartAdvertising(error: Error) {
        // Ignore
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        self.storage.recieveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func didSendMessage(text: String, toUser: String, completion: ((Bool, Error?) -> ())?) {
        self.storage.recieveMessage(text: text, fromUser: MultipeerCommunicator.myDisplayName, toUser: toUser)
        self.multipeerCommunicator.sendMessage(string: text, to: toUser, completionHandler: completion)
    }
}
