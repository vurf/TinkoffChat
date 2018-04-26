//
//  UserStorageFacade.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

enum UserStorageType {
    case coreDataStorage
    case gcdStorage
    case operation
}

protocol IUserStorageFacade {
    func selectStrategy(userStorageService: UserStorageType)
    func updateUser(user: ProfileUser, completionClosure: @escaping (_ withError : Bool) -> ())
    func getUser(completionClosure: @escaping (_ user : ProfileUser?) -> ())
}

class UserStorageFacade: IUserStorageFacade {
    
    private var userStorageService: IUserStorageService
    private var userCoreDataStorage: UserCoreDataStorage
    
    init(userStorageService: IUserStorageService, userCoreDataStorage: UserCoreDataStorage) {
        self.userStorageService = userStorageService
        self.userCoreDataStorage = userCoreDataStorage
    }
    
    func selectStrategy(userStorageService userStorageType: UserStorageType) {
        switch userStorageType {
            case .operation:
                self.userStorageService = OperationDataManager()
            case .gcdStorage:
                self.userStorageService = GCDDataManager()
            case .coreDataStorage:
                self.userStorageService = self.userCoreDataStorage
            default:
                self.userStorageService = OperationDataManager()
        }
    }
    
    func updateUser(user: ProfileUser, completionClosure: @escaping (_ withError : Bool) -> ()) {
        // need convert to display model
        self.userStorageService.saveUser(user: user, completionClosure: completionClosure)
    }
    
    func getUser(completionClosure: @escaping (_ user : ProfileUser?) -> ()) {
        // need convert to display model
        self.userStorageService.loadUser(completionClosure: completionClosure)
    }
}
