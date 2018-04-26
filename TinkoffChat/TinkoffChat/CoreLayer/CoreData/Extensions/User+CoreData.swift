//
//  User+CoreData.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/24/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    static func insertUser(with Id: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userId = Id
            return user
        }
        
        return nil
    }
    
    static func findOrInsertUser(with Id: String, in context:NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        
        var user : User?
        guard let fetchRequest = User.fetchRequestUser(with: Id, model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Appuser found!")
            if let foundUser = results.first{
                user = foundUser
            }
        } catch {
            print ("Failed to fetch user: \(error)")
        }
        
        if user == nil {
            user = User.insertUser(with: Id, in: context)
        }
        
        return user
        
    }
    
    static func fetchRequestUser(with Id: String, model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "UserById"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["userId" : Id]) as? NSFetchRequest<User> else {
            assert(false,"No template with name \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
}
