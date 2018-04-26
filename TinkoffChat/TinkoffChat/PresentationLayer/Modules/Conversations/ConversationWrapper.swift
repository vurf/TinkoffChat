//
//  ConversationData.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/10/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class ConversationWrapper {
    
    init(userID: String, name: String?, message: String?, date: Date?, online: Bool, hasUnreadedMessages: Bool) {
        self.userID = userID
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadedMessages = hasUnreadedMessages
    }
    
    var userID: String?
    
    var name: String?
    
    var message: String?
    
    var date: Date?
    
    var online: Bool
    
    var hasUnreadedMessages: Bool
}
