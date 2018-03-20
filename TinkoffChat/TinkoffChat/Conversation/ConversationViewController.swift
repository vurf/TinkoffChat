//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: BaseViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    var messagesTemp: [MessageData] = [MessageData]()
    
    var messages : [MessageData] {
        get {
            if self.messagesTemp.isEmpty {
                self.messagesTemp = MessageData.getMessages()
            }
            
            return self.messagesTemp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 66
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.messages.isEmpty {
            self.tableView.scrollToRow(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dequeuedCell : MessageTableViewCell
        let message = self.messages[indexPath.row]
        if message.isIncoming {
            dequeuedCell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.incomingIdenfitifier, for: indexPath) as! MessageTableViewCell
        } else {
            dequeuedCell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.outgoingIdenfitifier, for: indexPath) as! MessageTableViewCell
        }
        
        dequeuedCell.setConfiguration(configuration: message)
        
        return dequeuedCell
    }
}
