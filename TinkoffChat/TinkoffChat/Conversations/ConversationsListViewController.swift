//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/10/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class ConversationsListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    private var profileViewController : UIViewController?
    private var conversationsTemp: [[ConversationData]] = [[ConversationData]]()
    
    var conversations: [[ConversationData]] {
        get {
            if self.conversationsTemp.isEmpty {
                self.conversationsTemp.append(ConversationData.onlineConversations)
                self.conversationsTemp.append(ConversationData.offlineConversations)
            }
            
            return self.conversationsTemp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.tableFooterView = UIView()
        self.profileViewController = UIStoryboard(name: "ProfileScreen", bundle: nil).instantiateInitialViewController()!
    }
    
    @IBAction func showProfileScreen() {
        self.present(self.profileViewController!, animated: true, completion: nil)
    }
    
    /// MARK implementation UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations[section].count
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
        
        dequeuedCell.setConfiguration(configuration: self.conversations[indexPath.section][indexPath.row])
        
        return dequeuedCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? ConversationsTableViewCell {
            if let selectedIndexPath = self.tableView.indexPath(for: selectedCell) {
                self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                let conversationViewController = segue.destination as? ConversationViewController
                conversationViewController?.title = selectedCell.configuration?.name
            }
        }
    }
    
}
