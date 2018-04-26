//
//  CoreDataService.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataService {
    var mainContext: NSManagedObjectContext {get}
    var saveContext: NSManagedObjectContext {get}
     func performSave(context: NSManagedObjectContext, completionHandler: (()-> Void)?)
}

class CoreDataService: ICoreDataService {
    
    private var coreData: ICoreDataStack
    
    var mainContext: NSManagedObjectContext {
        get { return self.coreData.mainContext }
    }
    
    var saveContext: NSManagedObjectContext {
        get { return self.coreData.saveContext }
    }
    
    init(coreData: ICoreDataStack) {
        self.coreData = coreData
    }
    
    func performSave(context: NSManagedObjectContext, completionHandler: (()-> Void)?) {
        self.coreData.performSave(context: context, completionHandler: completionHandler)
    }
    
}
