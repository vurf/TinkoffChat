//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/3/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol Communicator {
    
    func sendMessage(string : String, to userID : String, completionHandler : ((_ success : Bool, _ error : Error?) -> ())?)
    
    var delegate : CommuncatorDelegate? {get set}
    
    var online : Bool {get set}
}
