//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/10/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

protocol ConversationCellConfiguration : class {
    var name : String? {get set}
    
    var message : String? {get set}
    
    var date : Date? {get set}
    
    var online : Bool {get set}
    
    var hasUnreadedMessages : Bool {get set}
}
