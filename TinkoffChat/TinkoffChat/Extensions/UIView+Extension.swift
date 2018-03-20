//
//  UIView+Extension.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/4/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func applyCornerRadius(radius : CGFloat) {
        self.layer.masksToBounds = radius > 0
        self.layer.cornerRadius = radius
    }
    
    func applyButtonStyle() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
}
