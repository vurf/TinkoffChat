//
//  MessageData.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class MessageWrapper {
    
    init(text: String?, isIncoming: Bool) {
        self.text = text
        self.isIncoming = isIncoming
    }
    
    var text: String? 
    
    var isIncoming: Bool
    
}
