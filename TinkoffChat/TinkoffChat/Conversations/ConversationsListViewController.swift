//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/10/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class ConversationsListViewController: BaseViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var communicationManager : CommunicationManager?
    
    static var conversations : [[ConversationData]] = [[ConversationData]]()
    static var messages : [String : [MessageData]] = [String : [MessageData]]() // UserID : Messages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Append empty online
        ConversationsListViewController.conversations.append([ConversationData]())
        
        // Append empty offline
        ConversationsListViewController.conversations.append([ConversationData]())
        self.communicationManager = CommunicationManager()
        self.communicationManager?.conversationsDelegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sortConversationsAndReloadData()
    }
    
    @IBAction func showProfileScreen() {
        let profileViewController = ProfileViewController.init(nibName: "ProfileViewController", bundle: nil)
        let navigationProfileViewController = UINavigationController(rootViewController: profileViewController)
        self.present(navigationProfileViewController, animated: true, completion: nil)
    }
    
    @IBAction func showThemesViewController() {
        let themesViewController = ThemesViewController.init(nibName: "ThemesViewController", bundle: nil)
        themesViewController.delegate = self
        themesViewController.model = Themes()
        let navigationThemesViewController = UINavigationController(rootViewController: themesViewController)
        self.present(navigationThemesViewController, animated: true, completion: nil)
    }
    
    @objc func cancelBarButtonItemTapped(sender : UIBarButtonItem!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? ConversationsTableViewCell {
            if let selectedIndexPath = self.tableView.indexPath(for: selectedCell) {
                self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                let conversationViewController = segue.destination as? ConversationViewController
                conversationViewController?.title = selectedCell.configuration?.name
                conversationViewController?.communicationManager = self.communicationManager
                ConversationsListViewController.conversations[selectedIndexPath.section][selectedIndexPath.row].hasUnreadedMessages = false
                conversationViewController?.currentUserID = ConversationsListViewController.conversations[selectedIndexPath.section][selectedIndexPath.row].userID
            }
        }
    }    
}

// MARK: Conversation Delegate
extension ConversationsListViewController : ConversationsDelegate {
    
    func didFoundUser(userID: String, userName: String?) {
        let findedConversationIndex = ConversationsListViewController.conversations[0].index(where: {$0.userID == userID})
        if findedConversationIndex == nil {
            let conversation = ConversationData(userID: userID, name: userName, message: nil, date: nil, online: true, hasUnreadedMessages: false)
            ConversationsListViewController.conversations[0].append(conversation)
            self.sortConversationsAndReloadData()
        }
    }
    
    func didLostUser(userID: String) {
        if let findedConversationIndex = ConversationsListViewController.conversations[0].index(where: {$0.userID == userID}) {
            ConversationsListViewController.conversations[0].remove(at: findedConversationIndex)
            self.sortConversationsAndReloadData()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        let message = MessageData(text: text, isIncoming: true)
        if let findedConversationIndex = ConversationsListViewController.conversations[0].index(where: {$0.userID == fromUser}) {
            let conversation = ConversationsListViewController.conversations[0][findedConversationIndex]
            conversation.message = message.text
            conversation.hasUnreadedMessages = true
            conversation.online = true
            conversation.userID = fromUser
            conversation.date = Date()
            ConversationsListViewController.conversations[0][findedConversationIndex] = conversation
            self.sortConversationsAndReloadData()
        }
        
        self.appendMessage(messageData: message, userID: fromUser)
    }
    
    func didSendMessage(text: String, toUser: String) {
        let message = MessageData(text: text, isIncoming: false)
        if let findedConversationIndex = ConversationsListViewController.conversations[0].index(where: {$0.userID == toUser}) {
            let conversation = ConversationsListViewController.conversations[0][findedConversationIndex]
            conversation.message = message.text
            conversation.hasUnreadedMessages = false
            conversation.online = true
            conversation.userID = toUser
            conversation.date = Date()
            ConversationsListViewController.conversations[0][findedConversationIndex] = conversation
            self.sortConversationsAndReloadData()
        }
        
        self.appendMessage(messageData: message, userID: toUser)
    }
    
    func appendMessage(messageData : MessageData, userID : String) {
        if ConversationsListViewController.messages[userID] == nil {
            ConversationsListViewController.messages[userID] = [messageData]
        } else {
            ConversationsListViewController.messages[userID]!.append(messageData)
        }
    }
    
    func sortConversationsAndReloadData() {
        let sortedConversations = ConversationsListViewController.conversations[0].sorted(by: { (first, second) -> Bool in
            
            if first.date == nil {
                if let firstName = first.name, let secondName = second.name {
                    return firstName < secondName
                }
            }
            
            if let firstDate = first.date, let secondDate = second.date {
                return firstDate > secondDate
            }
            
            return true
        })
        
        ConversationsListViewController.conversations[0] = sortedConversations
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: Data Source
extension ConversationsListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ConversationsListViewController.conversations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationsListViewController.conversations[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableViewCell.idenfitifier, for: indexPath) as! ConversationsTableViewCell
        
        dequeuedCell.setConfiguration(configuration: ConversationsListViewController.conversations[indexPath.section][indexPath.row])
        
        return dequeuedCell
    }
    
}

// MARK : ThemesViewControllerDelegate
extension ConversationsListViewController : ThemesViewControllerDelegate {
    
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        self.logThemeChanging(selectedTheme: selectedTheme)
        self.saveAndApplySelectedColor(selectedColor: selectedTheme)
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print("Был выбран новый цвет = \(selectedTheme)")
    }
    
    func saveAndApplySelectedColor(selectedColor : UIColor) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            UserDefaults.standard.setColor(color: selectedColor, forKey: "selectedColor")
            DispatchQueue.main.async {
                self.view.backgroundColor = selectedColor
                let inverseColor = selectedColor.isLight() ? UIColor.black : UIColor.white
                UINavigationBar.appearance().barTintColor = selectedColor
                UINavigationBar.appearance().tintColor = inverseColor
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: inverseColor]
            }
        }
    }
    
}
