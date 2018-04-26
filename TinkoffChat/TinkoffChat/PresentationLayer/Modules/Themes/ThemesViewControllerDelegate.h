//
//  ThemesViewControllerDelegate.h
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/19/18.
//  Copyright © 2018 TCS. All rights reserved.
//
//

@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>
-(void)themesViewController:(ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;
@end
