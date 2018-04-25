//
//  ListDataProvider.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/24/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ConversationsDataProvider : NSObject {
    
    let fetchedResultsController : NSFetchedResultsController<Conversation>
    let tableView : UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        let sortByTimestamp = NSSortDescriptor(key: "conversationId", ascending: false)
        fetchRequest.sortDescriptors = [sortByTimestamp]
        self.fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest:
            fetchRequest, managedObjectContext: CoreDataStack.instance.mainContext, sectionNameKeyPath: nil,
                          cacheName: nil)
        
        super.init()
        self.fetchedResultsController.delegate = self
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationsDataProvider : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange  anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}
