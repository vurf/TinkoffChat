//
//  ThemeFacadeTests.swift
//  TinkoffChatTests
//
//  Created by Илья Варфоломеев on 5/28/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class ThemeFacadeTests: XCTestCase {
    
    var themeFacade : ThemeFacade!
    
    var themeServiceMock: ThemeServiceMock!
    
    override func setUp() {
        super.setUp()
        self.themeServiceMock = ThemeServiceMock()
        self.themeFacade = ThemeFacade(themeService: self.themeServiceMock)
    }
    
    override func tearDown() {
        self.themeServiceMock = nil
        self.themeFacade = nil
        super.tearDown()
    }
    
    func testRetriveAndApplyTheme() {
        
        // given
        let expectedResult = self.themeServiceMock.performGetSavedThemeColorStub
        
        // when
        self.themeFacade.retriveAndApplyTheme()
        
        // then
        XCTAssertTrue(self.themeServiceMock.performApplyThemeCalled)
        XCTAssertTrue(self.themeServiceMock.performGetSavedThemeCalled)
        XCTAssertEqual(expectedResult, self.themeServiceMock.performApplyThemeColorParameter)
    }
    
    func testSaveAndApplyTheme() {
        
        // given
        let expectedResult = self.themeServiceMock.performGetSavedThemeColorStub
        
        // when
        self.themeFacade.saveAndApplyTheme(color: expectedResult)
        
        // then
        XCTAssertTrue(self.themeServiceMock.performSaveThemeCalled)
        XCTAssertTrue(self.themeServiceMock.performApplyThemeCalled)
        XCTAssertEqual(expectedResult, self.themeServiceMock.performSaveThemeColorParameter)
        XCTAssertEqual(expectedResult, self.themeServiceMock.performApplyThemeColorParameter)
    }
    
    // MARK: - Mock
    class ThemeServiceMock : IThemeService {
        
        var performGetSavedThemeColorStub: UIColor = UIColor.black
        var performSaveThemeColorParameter: UIColor!
        var performApplyThemeColorParameter: UIColor!
        var performSaveThemeCalled: Bool = false
        var performGetSavedThemeCalled: Bool = false
        var performApplyThemeCalled: Bool = false
        
        func saveTheme(color: UIColor) {
            self.performSaveThemeCalled = true
            self.performSaveThemeColorParameter = color
        }
        
        func getSavedTheme() -> UIColor {
            self.performGetSavedThemeCalled = true
            return self.performGetSavedThemeColorStub
        }
        
        func applyTheme(color: UIColor) {
            self.performApplyThemeCalled = true
            self.performApplyThemeColorParameter = color
        }
        
        func removeSavedTheme() {
            // without implementation
        }
    }
}


