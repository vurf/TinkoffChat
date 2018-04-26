//
//  ThemeModel.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/26/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol IThemeFacade {
    func saveAndApplyTheme(color: UIColor)
    func retriveAndApplyTheme()
}

class ThemeFacade: IThemeFacade {
    
    private var themeService: IThemeService
    
    init(themeService: IThemeService) {
        self.themeService = themeService
    }
    
    func saveAndApplyTheme(color: UIColor) {
        self.themeService.saveTheme(color: color)
        self.themeService.applyTheme(color: color)
    }
    
    func retriveAndApplyTheme() {
        self.themeService.applyTheme(color: self.themeService.getSavedTheme())
    }

}
