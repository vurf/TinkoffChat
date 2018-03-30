//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/27/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class OperationDataManager : DataManagerProtocol {
    
    let userManager : UserManager = UserManager()
    
    func saveUser(user: User, completionClosure: @escaping (Bool) -> ()) {
        let operationQueue = OperationQueue()
        let saveOperation = SaveUserOperation(userManager: self.userManager, user: user)
        saveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completionClosure(saveOperation.hasError)
            }
        }
        
        operationQueue.addOperation(saveOperation)
    }
    
    func loadUser(completionClosure: @escaping (User?) -> ()) {
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
    
    private let userManager : UserManager
    private let user : User
    
    var hasError : Bool = false
    
    init(userManager : UserManager, user : User) {
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
    
    private let userManager : UserManager
    
    var user : User?
    
    init(userManager : UserManager) {
        self.userManager = userManager
        super.init()
    }
    
    override func main() {
        if self.isCancelled { return }
        self.user = self.userManager.get()
    }
}
