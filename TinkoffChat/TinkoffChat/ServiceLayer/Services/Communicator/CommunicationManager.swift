//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/3/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol IUserFoundDelegate : class {
    func didFoundUser(userID : String, userName : String?)
    func didLostUser(userID : String)
}

protocol ICommunicationManager : class {
    
    var delegate: IUserFoundDelegate? {get set}
    
    var displayName: String {get}
    
    func start()
    func stop()
    
    // Discovering
    func didFoundUser(userID : String, userName : String?)
    func didLostUser(userID : String)
    
    // Errors
    func failedToStartBrowsingForUsers(error : Error)
    func failedToStartAdvertising(error : Error)
    
    // Messages
    func didReceiveMessage(text : String, fromUser : String, toUser : String)
    func sendMessage(text : String, toUser : String, completion: ((Bool, Error?) -> ())?)
}

class CommunicationManager : NSObject, ICommunicationManager {
    
    weak var delegate: IUserFoundDelegate?
    private var communicator : ICommunicator
    private var storage : ICommunicatorStorageService
    
    var displayName: String
    
    init(storage : ICommunicatorStorageService, communicator: ICommunicator) {
        self.storage = storage
        self.communicator = communicator        
        self.displayName = self.communicator.myDisplayName
        super.init()
        self.communicator.delegate = self
    }
    
    func start() {
        self.communicator.start()
    }
    
    func stop() {
        self.communicator.stop()
    }
    
    func didFoundUser(userID: String, userName: String?) {
        self.storage.didFoundUser(userID: userID, userName: userName)
        self.delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        self.storage.didLostUser(userID: userID)
        self.delegate?.didLostUser(userID: userID)
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
    
    func sendMessage(text: String, toUser: String, completion: ((Bool, Error?) -> ())?) {
        self.storage.recieveMessage(text: text, fromUser: communicator.myDisplayName, toUser: toUser)
        self.communicator.sendMessage(string: text, to: toUser, completionHandler: completion)
    }
}
