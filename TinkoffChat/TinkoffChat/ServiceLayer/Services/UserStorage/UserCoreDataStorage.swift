//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/9/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import CoreData

protocol IUserStorageService {
    
    // Сохранить пользователя
    func saveUser(user : ProfileUser, completionClosure: @escaping (_ withError : Bool) -> ())
    
    // Загрузить пользователя
    func loadUser(completionClosure: @escaping (_ user : ProfileUser?) -> ())
}

class UserCoreDataStorage : IUserStorageService  {
    
    private var dataStack: ICoreDataStack
    
    init(dataStack: ICoreDataStack) {
        self.dataStack = dataStack
    }
    
    func saveUser(user: ProfileUser, completionClosure: @escaping (Bool) -> ()) {
        let context = self.dataStack.saveContext
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            
            if user.usernameWasEdited {
                appUser.name = user.username
            }
            
            if user.descriptionWasEdited {
                appUser.details = user.description
            }
            
            if user.avatarWasEdited {
                appUser.avatar = user.avatar
            }
            
            self.dataStack.performSave(context: context) {
                DispatchQueue.main.async {
                    completionClosure(false)
                }
            }
        }
    }
    
    func loadUser(completionClosure: @escaping (ProfileUser?) -> ()) {
        let context = self.dataStack.saveContext
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            if appUser.name == nil && appUser.details == nil && appUser.avatar == nil {
                completionClosure(nil)
            } else {
                let profileUser = ProfileUser(username: appUser.name, description: appUser.details, avatar: appUser.avatar as? UIImage)
                
                DispatchQueue.main.async {
                    completionClosure(profileUser)
                }
            }
        }
    }
}
