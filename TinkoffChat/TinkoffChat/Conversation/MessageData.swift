//
//  MessageData.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class MessageData: MessageCellConfiguration {
    
    init(text: String?, isIncoming: Bool) {
        self.text = text
        self.isIncoming = isIncoming
    }
    
    var text: String? 
    
    var isIncoming: Bool
    
    static func getMessages() -> [MessageData] {
        var messages = [MessageData]()
        messages.append(MessageData(text: "C", isIncoming: true))
        messages.append(MessageData(text: "L", isIncoming: false))
        messages.append(MessageData(text: "Saul Bass on failure: Failure is built into creativity… the creative act involves this element of ‘newness’ and ‘experimentalism,’ then one must expect and accept the fucking possibility of failure. A good fucking composition is the result of a hierarchy consisting of clearly contrasting elements se", isIncoming: false))
        messages.append(MessageData(text: "Form follows fucking function. Practice won’t get you anywhere if you mindlessly fucking practice the same thing. Change only occurs when you work deliberately with purpose toward a goal. Think about all the fucking possibilities. Don’t fucking lie to yourself. Never, never assume that what you have ", isIncoming: true))
        messages.append(MessageData(text: "Don’t get hung up on graphic !", isIncoming: false))
        messages.append(MessageData(text: "The graphic designer’s first f", isIncoming: true))
        return messages
    }
}
