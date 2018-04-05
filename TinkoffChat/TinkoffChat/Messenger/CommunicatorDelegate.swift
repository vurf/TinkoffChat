//
//  CommunicatorDelegate.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/3/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol CommuncatorDelegate : class {
    
    // Discovering
    func didFoundUser(userID : String, userName : String?)
    
    func didLostUser(userID : String)
    
    // Errors
    func failedToStartBrowsingForUsers(error : Error)
    
    func failedToStartAdvertising(error : Error)
    
    // Messages
    func didReceiveMessage(text : String, fromUser : String, toUser : String)
    
    func didSendMessage(text : String, toUser : String)
}
