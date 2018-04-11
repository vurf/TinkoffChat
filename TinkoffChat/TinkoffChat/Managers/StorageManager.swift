//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/9/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class StorageManager : DataManagerProtocol {
    
    var coreDataStack : CoreDataStack = CoreDataStack()
        
    func saveUser(user: ProfileUser, completionClosure: @escaping (Bool) -> ()) {
        let context = self.coreDataStack.saveContext
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            
            if user.usernameWasEdited {
                appUser.username = user.username
            }
            
            if user.descriptionWasEdited {
                appUser.details = user.description
            }
            
            if user.avatarWasEdited {
                appUser.avatar = user.avatar
            }
            
            self.coreDataStack.performSave(context: context) {
                DispatchQueue.main.async {
                    completionClosure(false)
                }
            }
        }
    }
    
    func loadUser(completionClosure: @escaping (ProfileUser?) -> ()) {
        let context = self.coreDataStack.saveContext
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            if appUser.username == nil && appUser.details == nil && appUser.avatar == nil {
                completionClosure(nil)
            } else {
                let profileUser = ProfileUser(username: appUser.username, description: appUser.details, avatar: appUser.avatar as? UIImage)
                
                DispatchQueue.main.async {
                    completionClosure(profileUser)
                }
            }
        }
    }
    
}
