//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/27/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class OperationDataManager : IUserStorageService {
    
    let userManager : UserFileStorage = UserFileStorage()
    
    func saveUser(user: ProfileUser, completionClosure: @escaping (Bool) -> ()) {
        let operationQueue = OperationQueue()
        let saveOperation = SaveUserOperation(userManager: self.userManager, user: user)
        saveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completionClosure(saveOperation.hasError)
            }
        }
        
        operationQueue.addOperation(saveOperation)
    }
    
    func loadUser(completionClosure: @escaping (ProfileUser?) -> ()) {
        let operationQueue = OperationQueue()
        let loadOperation = LoadUserOperation(userManager: self.userManager)
        loadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completionClosure(loadOperation.user)
            }
        }
        
        operationQueue.addOperation(loadOperation)
    }
}

class SaveUserOperation : Operation {
    
    private let userManager : UserFileStorage
    private let user : ProfileUser
    
    var hasError : Bool = false
    
    init(userManager : UserFileStorage, user : ProfileUser) {
        self.userManager = userManager
        self.user = user
        super.init()
    }
    
    override func main() {
        if self.isCancelled { return }
        self.hasError = self.userManager.save(user: self.user)
    }
}

class LoadUserOperation : Operation {
    
    private let userManager : UserFileStorage
    
    var user : ProfileUser?
    
    init(userManager : UserFileStorage) {
        self.userManager = userManager
        super.init()
    }
    
    override func main() {
        if self.isCancelled { return }
        self.user = self.userManager.get()
    }
}
