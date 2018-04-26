//
//  ConversationDataProvider.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/24/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ConversationDataProvider : NSObject {
    
    let fetchedResultsController: NSFetchedResultsController<Message>
    let tableView: UITableView
    
    init(tableView: UITableView, conversationId: String) {
        self.tableView = tableView
        
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        
        let predicate = NSPredicate(format: "conversation.conversationId == %@", conversationId)
        fetchRequest.predicate = predicate
        
        let sortByTimestamp = NSSortDescriptor(key: "date",ascending: false)
        fetchRequest.sortDescriptors = [sortByTimestamp]
        
        self.fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.rootAssembly.presentationAssembly.coreDataFacade.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        self.fetchedResultsController.delegate = self
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationDataProvider : NSFetchedResultsControllerDelegate {
    
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
