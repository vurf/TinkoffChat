//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    
    var themeFacade: IThemeFacade {get}
    var userStorageFacade: IUserStorageFacade {get}
    var communicationFacade: ICommunicationFacade {get}
    var coreDataFacade: ICoreDataFacade {get}
    
    func profileViewController() -> ProfileViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    lazy var themeFacade : IThemeFacade = ThemeFacade(themeService: self.serviceAssembly.themeService)
 
    lazy var userStorageFacade: IUserStorageFacade = UserStorageFacade(userStorageService: self.serviceAssembly.userStorageService, userCoreDataStorage: self.serviceAssembly.userStorageService as! UserCoreDataStorage)
    
    lazy var communicationFacade: ICommunicationFacade = CommunicationFacade(communicationManager: self.serviceAssembly.communicationManager)
    
    lazy var coreDataFacade: ICoreDataFacade = CoreDataFacade(coreData: self.serviceAssembly.coreDataService)
    
    func profileViewController() -> ProfileViewController {
        return ProfileViewController(userStorageFacade: self.userStorageFacade)
    }
}
