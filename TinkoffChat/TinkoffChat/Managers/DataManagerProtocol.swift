//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/28/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    
    // Сохранить пользователя
    func saveUser(user : ProfileUser, completionClosure: @escaping (_ withError : Bool) -> ())
    
    // Загрузить пользователя
    func loadUser(completionClosure: @escaping (_ user : ProfileUser?) -> ())
}
