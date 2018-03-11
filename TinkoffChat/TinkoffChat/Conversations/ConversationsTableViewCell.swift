//
//  ConversationsTableViewCell.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/10/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class ConversationsTableViewCell: UITableViewCell, ConversationCellConfiguration {
    
    static let idenfitifier : String = "ConversationsTableViewCell"
    
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    
    var configuration : ConversationCellConfiguration?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setConfiguration(configuration : ConversationCellConfiguration) {
        self.configuration = configuration
        self.name = configuration.name
        self.message = configuration.message
        self.date = configuration.date
        self.online = configuration.online
        self.hasUnreadedMessages = configuration.hasUnreadedMessages
    }
    
    var name : String? {
        didSet {
            self.usernameLabel.text = name
        }
    }
    
    var message : String? {
        didSet {
            if let messageValue = message {
                self.messageLabel.attributedText = NSAttributedString(string: messageValue, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: self.messageLabel.font.pointSize, weight: UIFont.Weight.light)])
            } else {
                self.messageLabel.attributedText = NSAttributedString(string: "No messages yet", attributes: [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: self.messageLabel.font.pointSize)])
            }
        }
    }
    
    var date : Date? {
        didSet {
            guard let newDate = date else {
                self.timeLabel.text = ""
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let currentDate = Date()
            let currentDateString = formatter.string(from: currentDate)
            let dateString = formatter.string(from: newDate)
            
            if currentDateString == dateString {
                formatter.dateFormat = "HH:mm"
            } else {
                formatter.dateFormat = "dd MMM"
            }
            
            self.timeLabel.text = formatter.string(from: newDate)
        }
    }
    
    var online : Bool = false {
        didSet {
            self.backgroundColor = online ? UIColor.init(red: 255, green: 255, blue: 0, alpha: 0.3) : UIColor.white
        }
    }
    
    var hasUnreadedMessages: Bool = false {
        didSet {
            if hasUnreadedMessages {
                self.messageLabel.attributedText = NSAttributedString(string: self.messageLabel.text!, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: self.messageLabel.font.pointSize, weight: UIFont.Weight.bold)])
            }
        }
    }

    
}
