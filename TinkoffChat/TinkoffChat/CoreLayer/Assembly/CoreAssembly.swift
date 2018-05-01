//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: ICoreDataStack {get}
    var multipeerCommuncator: ICommunicator {get}
    var communicatorStorageService: ICommunicatorStorageService {get}
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var coreDataStack: ICoreDataStack = CoreDataStack()
    lazy var multipeerCommuncator: ICommunicator = MultipeerCommunicator()
    lazy var communicatorStorageService: ICommunicatorStorageService = CommunicatorStorageService(dataStack: self.coreDataStack, communicator: self.multipeerCommuncator)    
    lazy var requestSender: IRequestSender = RequestSender()
}
