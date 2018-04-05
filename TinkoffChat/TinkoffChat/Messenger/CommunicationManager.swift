//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/3/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class CommunicationManager : NSObject, CommuncatorDelegate {
    
    var multipeerCommunicator : MultipeerCommunicator
    weak var conversationDelegate : ConversationDelegate?
    weak var conversationsDelegate : ConversationsDelegate?
    
    override init() {
        self.multipeerCommunicator = MultipeerCommunicator()
        super.init()
        self.multipeerCommunicator.delegate = self
        self.multipeerCommunicator.start()
    }
    
    deinit {
        self.multipeerCommunicator.stop()
    }
    
    func didFoundUser(userID: String, userName: String?) {
        self.conversationDelegate?.didFoundUser(userID: userID, userName: userName)
        self.conversationsDelegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        self.conversationDelegate?.didLostUser(userID: userID)
        self.conversationsDelegate?.didLostUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        self.conversationsDelegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        self.conversationsDelegate?.failedToStartAdvertising(error: error)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        self.conversationDelegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
        self.conversationsDelegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func didSendMessage(text: String, toUser: String) {
        self.conversationsDelegate?.didSendMessage(text: text, toUser: toUser)
    }
}
