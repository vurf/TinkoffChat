//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/9/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import CoreData

class StorageManager : DataManagerProtocol  {
    
    func saveUser(user: ProfileUser, completionClosure: @escaping (Bool) -> ()) {
        let context = CoreDataStack.instance.saveContext
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            
            if user.usernameWasEdited {
                appUser.name = user.username
            }
            
            if user.descriptionWasEdited {
                appUser.details = user.description
            }
            
            if user.avatarWasEdited {
                appUser.avatar = user.avatar
            }
            
            CoreDataStack.instance.performSave(context: context) {
                DispatchQueue.main.async {
                    completionClosure(false)
                }
            }
        }
    }
    
    func loadUser(completionClosure: @escaping (ProfileUser?) -> ()) {
        let context = CoreDataStack.instance.saveContext
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            if appUser.name == nil && appUser.details == nil && appUser.avatar == nil {
                completionClosure(nil)
            } else {
                let profileUser = ProfileUser(username: appUser.name, description: appUser.details, avatar: appUser.avatar as? UIImage)
                
                DispatchQueue.main.async {
                    completionClosure(profileUser)
                }
            }
        }
    }
}

// MARK: - StorageProtocol
extension StorageManager : StorageManagerProtocol {
    
    func recieveMessage(text: String, fromUser: String, toUser: String) {
        let context = CoreDataStack.instance.saveContext
        let message = Message.insertMessage(messageText: text, recieverId: toUser, senderId: fromUser, in: context)
        message?.isUnread = true
        message?.isIncoming = toUser == MultipeerCommunicator.myDisplayName
        let conversation = Conversation.findOrInsertConversation(with: Message.generateConversationId(id1: fromUser, id2: toUser), in: context)
        conversation?.lastMessage = message
        CoreDataStack.instance.performSave(context: context, completionHandler: nil)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        let currentUserName = MultipeerCommunicator.myDisplayName
        let context = CoreDataStack.instance.saveContext
        let user = User.findOrInsertUser(with: userID, in: context)
        user?.name = userName
        user?.isOnline = true
        let conversation = Conversation.findOrInsertConversation(with: Message.generateConversationId(id1: userID, id2: currentUserName), in: context)
        let me = User.findOrInsertUser(with: currentUserName, in: context)
        conversation?.addToUsers(user!)
        conversation?.addToUsers(me!)
        conversation?.isOnline = true
        CoreDataStack.instance.performSave(context: context, completionHandler: nil)
    }
    
    func didLostUser(userID: String) {
        let currentUserName = MultipeerCommunicator.myDisplayName
        let context = CoreDataStack.instance.saveContext
        let user = User.findOrInsertUser(with: userID, in: context)
        user?.isOnline = false
        let conversation = Conversation.findOrInsertConversation(with: Message.generateConversationId(id1: userID, id2: currentUserName), in: context)
        conversation?.isOnline = false
        CoreDataStack.instance.performSave(context: context, completionHandler: nil)
    }
}
