//
//  ConversationData.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/10/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class ConversationData: ConversationCellConfiguration {
    
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
    
    static func generateRandomDate() -> Date? {
        let daysBack : Int = 2
        let day = arc4random_uniform(UInt32(daysBack)) + 1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = -Int(day - 1)
        offsetComponents.hour = -Int(hour)
        offsetComponents.minute = -Int(minute)
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        
        return randomDate
    }
}
