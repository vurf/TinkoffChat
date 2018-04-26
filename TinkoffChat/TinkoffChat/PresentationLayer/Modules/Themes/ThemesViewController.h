//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/19/18.
//  Copyright © 2018 TCS. All rights reserved.
//

@import UIKit;
@class Themes;
@protocol ThemesViewControllerDelegate;

@interface ThemesViewController : UIViewController {
    id<ThemesViewControllerDelegate> _delegate;
    Themes *_model;
}

@property (nonatomic, retain) id<ThemesViewControllerDelegate> delegate;

@property (nonatomic, retain) Themes *model;

@end
