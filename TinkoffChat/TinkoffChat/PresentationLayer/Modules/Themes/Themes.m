//
//  Themes.m
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/19/18.
//  Copyright © 2018 TCS. All rights reserved.
//

#import "Themes.h"

@implementation Themes

- (id) init {
    // light theme
    self.theme1 = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
    
    // dark theme
    self.theme2 = [UIColor colorWithRed:0.22 green:0.28 blue:0.31 alpha:1.0];
    
    // shampagne theme
    self.theme3 = [UIColor colorWithRed:0.97 green:0.91 blue:0.81 alpha:1.0];
    
    return self;
}

- (UIColor *)theme1 {
    return _theme1;
}

- (void)setTheme1:(UIColor *)theme1 {
    [theme1 retain];
    [_theme1 release];
    _theme1 = theme1;
}

- (UIColor *)theme2 {
    return _theme2;
}

- (void)setTheme2:(UIColor *)theme2 {
    [theme2 retain];
    [_theme2 release];
    _theme2 = theme2;
}

- (UIColor *)theme3 {
    return _theme3;
}

- (void)setTheme3:(UIColor *)theme3 {
    [theme3 retain];
    [_theme3 release];
    _theme3 = theme3;
}

- (void) dealloc {
    printf("Themes destroyed");
    [_theme1 release]; _theme1 = nil;
    [_theme2 release]; _theme2 = nil;
    [_theme3 release]; _theme3 = nil;
    [super dealloc];
}

@end
