//
//  ThemeService.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol IThemeService {
    
    func saveTheme(color: UIColor)
    
    func getSavedTheme() -> UIColor
    
    func applyTheme(color: UIColor)
    
    func removeSavedTheme()
}

class ThemeService: IThemeService {
    
    private var defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func saveTheme(color: UIColor) {
        self.defaults.setColor(color: color, forKey: "selectedColor")
    }
    
    func getSavedTheme() -> UIColor {
        return self.defaults.colorForKey(key: "selectedColor") ?? UIColor.white
    }
    
    func applyTheme(color: UIColor) {
        let inverseColor = color.isLight() ? UIColor.black : UIColor.white
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor = inverseColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: inverseColor]
    }
    
    func removeSavedTheme() {
        self.defaults.setColor(color: nil, forKey: "selectedColor")
    }
}
