//
//  CommunicationFacade.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol IDisplayUserDelegate : class {
    func didFoundUser(userID : String, userName : String?)
    func didLostUser(userID : String)
}

protocol ICommunicationFacade {
    func setDelegate(delegate : IDisplayUserDelegate)
    func sendMessage(text : String, toUser : String, completion: ((Bool, Error?) -> ())?)
    var displayName: String {get}
    func start()
    func stop()
}

class CommunicationFacade: ICommunicationFacade {
    
    private weak var delegate: IDisplayUserDelegate?
    private var communicationManager: ICommunicationManager
    
    init(communicationManager: ICommunicationManager) {
        self.communicationManager = communicationManager
        self.communicationManager.delegate = self
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
    
    func setDelegate(delegate: IDisplayUserDelegate) {
        self.delegate = delegate
    }
}

extension CommunicationFacade: IUserFoundDelegate {
    func didFoundUser(userID: String, userName: String?) {
        self.delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        self.delegate?.didLostUser(userID: userID)
    }
    
}
