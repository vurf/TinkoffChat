//
//  MessageData.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    
    static func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UInt32.max)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UInt32.max))".data(using: String.Encoding.utf8)?.base64EncodedString()
        return string!
    }
    
    static func generateConversationId(id1: String, id2: String) -> String {
        if id1 > id2 {
            return id1 + id2
        } else{
            return id2 + id1
        }
    }
    
    static func insertMessage(messageText: String, recieverId: String, senderId: String, in context:NSManagedObjectContext) -> Message? {
        
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else {
            return nil
        }
        
        message.messageId = Message.generateMessageId()
        message.date = Date()
        message.text = messageText
        let generatedConversationId = Message.generateConversationId(id1: recieverId, id2: senderId)
        let conversation = Conversation.findConversation(with: generatedConversationId, in: context)
        message.conversation = conversation
        
        return message
    }
    
    static func findMessagesByConversation(with id: String, in context: NSManagedObjectContext) -> [Message]? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        
        var messages : [Message]?
        guard let fetchRequest = Message.fetchRequestMessageByConversation(with: id, model: model) else {
            return nil
        }
        
        do {
            messages = try context.fetch(fetchRequest)
        } catch {
            print ("Failed to fetch messages: \(error)")
        }
        
        return messages
    }
    
    static func fetchRequestMessageByConversation(with Id:String, model: NSManagedObjectModel) -> NSFetchRequest<Message>? {
        let templateName = "MessagesByConversationId"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["conversationId" : Id]) as? NSFetchRequest<Message> else {
            assert(false,"No template with name \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
}
