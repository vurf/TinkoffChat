//
//  ConversationData.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/10/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class ConversationData: ConversationCellConfiguration {
    
    init(name: String?, message: String?, date: Date?, online: Bool, hasUnreadedMessages: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadedMessages = hasUnreadedMessages
    }
    
    var name: String?
    
    var message: String?
    
    var date: Date?
    
    var online: Bool
    
    var hasUnreadedMessages: Bool
    
    static var onlineConversations: [ConversationData] {
        get {
            var data = [ConversationData]()
            data.append(ConversationData(name: "Василий И.В.", message: nil, date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Василий Геннадьевич, который должен денег завтра после обеда", message: nil, date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Олег", message: "Saul Bass on", date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Парень с Украины", message: "Don’t get hung up on things that don’t fucking work. Sometimes it is appropriate to place various typographic elements on the outside of the fucking left margin of text to", date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Кирилл", message: "Saul Bass on failure: Failure is built into creativity… the", date: generateRandomDate(), online: true, hasUnreadedMessages: true))
            data.append(ConversationData(name: "Магомед Магомедович Нурсултанов", message: "Make your work consistent but not fucking predictable. To go partway is easy, but mastering", date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Джокер", message: "To surpass others is", date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Безруков", message: nil, date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Слепов Сергей", message: "The", date: generateRandomDate(), online: true, hasUnreadedMessages: true))
            data.append(ConversationData(name: "Джокер", message: "To surpass others is", date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Безруков", message: nil, date: generateRandomDate(), online: true, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Слепов Сергей", message: "Creativity is a fucking work-ethic. A good fucking composition is the result of a hierarchy consisting of clearly contrasting elements set with distinct alignments containing irregular intervals of negative space.", date: generateRandomDate(), online: true, hasUnreadedMessages: true))
            return data
        }
    }
    
    static var offlineConversations: [ConversationData] {
        get {
            var data = [ConversationData]()
            data.append(ConversationData(name: "Василий", message: nil, date: generateRandomDate(), online: false, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Василий Геннадьевич, который должен денег завтра после обеда", message: nil, date: generateRandomDate(), online: false, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Олег", message: "Saul Bass on", date: generateRandomDate(), online: false, hasUnreadedMessages: true))
            data.append(ConversationData(name: "Знакомый с ВУЗа, имя забыл", message: "Don’t get hung up on things that don’t fucking work. Sometimes it is appropriate to place various typographic elements on the outside of the fucking left margin of text to", date: generateRandomDate(), online: false, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Алешка Иванович Павлов и какая то длинная строка", message: "A good fucking composition is the result of a hierarchy consisting of clearly contrasting elements set with distinct alignments containing", date: generateRandomDate(), online: false, hasUnreadedMessages: true))
            data.append(ConversationData(name: "Молчаливая подруга", message: nil, date: generateRandomDate(), online: false, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Олег", message: "Saul Bass on", date: generateRandomDate(), online: false, hasUnreadedMessages: true))
            data.append(ConversationData(name: "Знакомый с ВУЗа, имя забыл", message: "Don’t get hung up on things that don’t fucking work. Sometimes it is appropriate to place various typographic elements on the outside of the fucking left margin of text to", date: generateRandomDate(), online: false, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Молчаливая подруга", message: nil, date: generateRandomDate(), online: false, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Олег", message: "Respect your fucking craft. When you sit down to work, external critics aren’t the enemy. It’s you who you must", date: generateRandomDate(), online: false, hasUnreadedMessages: true))
            data.append(ConversationData(name: "Василий", message: nil, date: generateRandomDate(), online: false, hasUnreadedMessages: false))
            data.append(ConversationData(name: "Василий Геннадьевич, который должен денег завтра после обеда", message: "Why are you fucking reading all of this? Get back to work. Creativity is a fucking work-ethic. While having drinks with Tibor Kalman one night, he told me, “When you", date: generateRandomDate(), online: false, hasUnreadedMessages: false))
            return data
        }
    }
    
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
