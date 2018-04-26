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
            
    override func viewWillAppear(_ animated: Bool) {
        if let selectedColor = UserDefaults.standard.colorForKey(key: "selectedColor") {
            self.view.backgroundColor = selectedColor
        }
    }
}
