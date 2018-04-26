//
//  CommunicatorStorageService.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol ICommunicatorStorageService {
    func recieveMessage(text: String, fromUser: String, toUser: String)
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
}

class CommunicatorStorageService: ICommunicatorStorageService {
    
    private var dataStack: ICoreDataStack
    private var communicator: ICommunicator
    
    init(dataStack: ICoreDataStack, communicator: ICommunicator) {
        self.dataStack = dataStack
        self.communicator = communicator
    }
    
    func recieveMessage(text: String, fromUser: String, toUser: String) {
        let context = self.dataStack.saveContext
        let message = Message.insertMessage(messageText: text, recieverId: toUser, senderId: fromUser, in: context)
        message?.isUnread = true
        message?.isIncoming = toUser == self.communicator.myDisplayName
        let conversation = Conversation.findOrInsertConversation(with: Message.generateConversationId(id1: fromUser, id2: toUser), in: context)
        conversation?.lastMessage = message
        self.dataStack.performSave(context: context, completionHandler: nil)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        let currentUserName = self.communicator.myDisplayName
        let context = self.dataStack.saveContext
        let user = User.findOrInsertUser(with: userID, in: context)
        user?.name = userName
        user?.isOnline = true
        let conversation = Conversation.findOrInsertConversation(with: Message.generateConversationId(id1: userID, id2: currentUserName), in: context)
        let me = User.findOrInsertUser(with: currentUserName, in: context)
        conversation?.addToUsers(user!)
        conversation?.addToUsers(me!)
        conversation?.isOnline = true
        self.dataStack.performSave(context: context, completionHandler: nil)
    }
    
    func didLostUser(userID: String) {
        let currentUserName = self.communicator.myDisplayName
        let context = self.dataStack.saveContext
        let user = User.findOrInsertUser(with: userID, in: context)
        user?.isOnline = false
        let conversation = Conversation.findOrInsertConversation(with: Message.generateConversationId(id1: userID, id2: currentUserName), in: context)
        conversation?.isOnline = false
        self.dataStack.performSave(context: context, completionHandler: nil)
    }
}
