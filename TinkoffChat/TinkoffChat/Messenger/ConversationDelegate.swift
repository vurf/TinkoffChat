//
//  ConversationDelegate.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/5/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol ConversationDelegate : class {
    
    // Discovering
    func didFoundUser(userID : String, userName : String?)
    
    func didLostUser(userID : String)
    
    // Messages
    func didReceiveMessage(text : String, fromUser : String, toUser : String)
}
