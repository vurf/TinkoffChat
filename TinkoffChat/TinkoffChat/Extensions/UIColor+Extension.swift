//
//  UIColor+Extension.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/20/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIColor
{
    func isLight() -> Bool
    {
        let components = self.cgColor.components
        let brightness = ((components![0] * 299) + (components![1] * 587) + (components![2] * 114)) / 1000
        
        return brightness >= 0.5
    }
}
