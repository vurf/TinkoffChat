//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var themeService: IThemeService {get}
    var communicationManager: ICommunicationManager {get}
    var userStorageService: IUserStorageService {get}
    var coreDataService: ICoreDataService {get}
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var themeService: IThemeService = ThemeService(defaults: UserDefaults.standard)
    
    lazy var communicationManager: ICommunicationManager = CommunicationManager(storage : self.coreAssembly.communicatorStorageService, communicator: self.coreAssembly.multipeerCommuncator)
    
    lazy var userStorageService: IUserStorageService = UserCoreDataStorage(dataStack: self.coreAssembly.coreDataStack)
    
    lazy var coreDataService: ICoreDataService = CoreDataService(coreData: self.coreAssembly.coreDataStack)
}
