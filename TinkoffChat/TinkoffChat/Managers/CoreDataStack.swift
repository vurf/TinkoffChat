//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/9/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let dataModelName = "Model"
    let dataModelExtension = "momd"
    
    var storeUrl : URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsUrl.appendingPathComponent("Store.sqlite")
    }
    
    lazy var managedObjectModel : NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)!
        
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    lazy var persistentStoreCoordinator : NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        
        return coordinator
    }()
    
    lazy var masterContext : NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        
        return masterContext
    }()
    
    lazy var mainContext : NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        
        return mainContext
    }()
    
    lazy var saveContext : NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        
        return saveContext
    }()
    
    func performSave(context : NSManagedObjectContext, completionHandler: (()-> Void)?) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
            }
        } else {
            completionHandler?()
        }
    }
    
}
