//
//  ThemeServiceTests.swift
//  ThemeServiceTests
//
//  Created by rangemotions on 2/25/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class ThemeServiceTests: XCTestCase {
    
    var themeService : ThemeService!
    
    override func setUp() {
        super.setUp()
        self.themeService = ThemeService(defaults: UserDefaults.standard)
    }
    
    override func tearDown() {
        self.themeService = nil
        super.tearDown()
    }
    
    let testCaseSource = [UIColor.black, UIColor.yellow, UIColor.blue, UIColor.cyan, UIColor.darkGray]
    
    //MARK: - test save theme
    func testSaveColor() {
        
        // given
        for color in self.testCaseSource {
            self.testSaveColorInternal(expectedColor: color)
        }
    }
    
    func testSaveColorInternal(expectedColor: UIColor) {
        
        // when
        self.themeService.saveTheme(color: expectedColor)
        let resultColor = self.themeService.getSavedTheme()
        
        // then
        XCTAssertEqual(expectedColor, resultColor)
    }
    
    // MARK: - test apply theme
    func testApplyTheme() {
        
        // given
        for color in self.testCaseSource {
            self.testApplyThemeInternal(expectedColor: color)
        }
    }
    
    func testApplyThemeInternal(expectedColor: UIColor) {
        
        // given
        let expectedInverseColor = expectedColor.isLight() ? UIColor.black : UIColor.white
        
        // when
        self.themeService.applyTheme(color: expectedColor)
        
        // then
        let titleColor = UINavigationBar.appearance().titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor
        
        XCTAssertEqual(expectedColor, UINavigationBar.appearance().barTintColor)
        XCTAssertEqual(expectedInverseColor, UINavigationBar.appearance().tintColor)
        XCTAssertEqual(expectedInverseColor, titleColor)
    }
}
