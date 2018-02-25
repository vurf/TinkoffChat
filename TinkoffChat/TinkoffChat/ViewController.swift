//
//  ViewController.swift
//  TinkoffChat
//
//  Created by rangemotions on 2/25/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.log(function: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.log(function: #function)
    }
    
    override func viewWillLayoutSubviews() {
        self.log(function: #function)
    }
    
    override func viewDidLayoutSubviews() {
        self.log(function: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.log(function: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.log(function: #function)
    }

    func log(function: String) {
        print("\n\nViewController : \(function)")
    }
}

