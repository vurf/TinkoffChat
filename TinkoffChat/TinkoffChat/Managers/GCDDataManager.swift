//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/27/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class GCDDataManager : DataManagerProtocol {
    
    let userManager : UserManager = UserManager()
    
    func saveUser(user : ProfileUser, completionClosure: @escaping (_ withError : Bool) -> ()) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            let hasError = self.userManager.save(user: user)
            DispatchQueue.main.async {
                completionClosure(hasError)
            }
        }
    }
    
    func loadUser(completionClosure: @escaping (_ user : ProfileUser?) -> ()) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            let loadedUser = self.userManager.get()
            DispatchQueue.main.async {
                completionClosure(loadedUser)
            }
        }
    }
    
}
