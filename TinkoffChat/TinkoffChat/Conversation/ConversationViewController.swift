//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: BaseViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton : UIButton!
    
    var communicationManager : CommunicationManager?
    var currentUserID : String?
    private var personalMessages : [MessageData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.communicationManager?.conversationDelegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 66
    }
    
    @IBAction func sendTouch(_ sender: UIButton) {
        guard let messageText = self.messageTextField.text else {
            return
        }
        
        self.communicationManager?.multipeerCommunicator.sendMessage(string: messageText, to: self.currentUserID!, completionHandler: { (success, error) in
            if success {
                let message = MessageData(text: messageText, isIncoming: false)
                self.appendMessage(messageData: message)
               
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.messageTextField.text = ""
                }                
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.personalMessages = ConversationsListViewController.messages[self.currentUserID!]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let personalMessagesUnwrapped = self.personalMessages, !personalMessagesUnwrapped.isEmpty {
            self.tableView.scrollToRow(at: IndexPath(item: personalMessagesUnwrapped.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ConversationsListViewController.messages[self.currentUserID!] = self.personalMessages
    }
    
    func appendMessage(messageData : MessageData) {
        if self.personalMessages == nil {
            self.personalMessages = [messageData]
        } else {
            self.personalMessages?.append(messageData)
        }
    }
    
}

extension ConversationViewController : ConversationDelegate {
    
    func didFoundUser(userID: String, userName: String?) {
        self.sendButton.isEnabled = userID == self.currentUserID
    }
    
    func didLostUser(userID: String) {
        self.sendButton.isEnabled = !(userID == self.currentUserID)
    }
        
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        let message = MessageData(text: text, isIncoming: true)
        self.appendMessage(messageData: message)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: Data Source
extension ConversationViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personalMessages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dequeuedCell : MessageTableViewCell
        let message = self.personalMessages![indexPath.row]
        if message.isIncoming {
            dequeuedCell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.incomingIdenfitifier, for: indexPath) as! MessageTableViewCell
        } else {
            dequeuedCell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.outgoingIdenfitifier, for: indexPath) as! MessageTableViewCell
        }
        
        dequeuedCell.setConfiguration(configuration: message)
        
        return dequeuedCell
    }
    
}
