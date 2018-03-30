//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/10/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class ConversationsListViewController: BaseViewController, UITableViewDataSource, ThemesViewControllerDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    
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
    
    /// MARK implementation ThemesViewControllerDelegate
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
