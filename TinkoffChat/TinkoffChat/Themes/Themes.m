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

- (void) dealloc {
    printf("Themes destroyed");
    [[self theme1] release];
    [[self theme2] release];
    [[self theme3] release];
    [super dealloc];
}

@end
