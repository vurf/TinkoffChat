//
//  BaseViewController.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/20/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    
    var emitter: Emitter?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedColor = UserDefaults.standard.colorForKey(key: "selectedColor") {
            self.view.backgroundColor = selectedColor
        }
        
        self.emitter = Emitter(superView: self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.emitter = nil
    }
}
