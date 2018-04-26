//
//  MessageCellConfiguration.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol MessageCellConfiguration : class {
    
    var text : String? {get set}
    
    var isIncoming : Bool {get set}
}
