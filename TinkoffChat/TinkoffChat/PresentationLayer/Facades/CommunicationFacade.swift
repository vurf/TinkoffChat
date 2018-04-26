//
//  CommunicationFacade.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol ICommunicationFacade {
    func sendMessage(text : String, toUser : String, completion: ((Bool, Error?) -> ())?)
    var displayName: String {get}
    func start()
    func stop()
}

class CommunicationFacade: ICommunicationFacade {
    
    private var communicationManager: ICommunicationManager
    
    init(communicationManager: ICommunicationManager) {
        self.communicationManager = communicationManager
    }
    
    func sendMessage(text : String, toUser : String, completion: ((Bool, Error?) -> ())?) {
        self.communicationManager.sendMessage(text: text, toUser: toUser, completion: completion)
    }
    
    func start() {
        self.communicationManager.start()
    }
    
    func stop() {
        self.communicationManager.stop()
    }
    
    lazy var displayName: String = self.communicationManager.displayName
}
