//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 3/19/18.
//  Copyright © 2018 TCS. All rights reserved.
//

#import "Themes.h"
#import "ThemesViewController.h"
#import "ThemesViewControllerDelegate.h"

@implementation ThemesViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.title = @"Themes";
    
    // Вытаскиваем сохранненый цвет
    NSData *decodedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedColor"];
    if (decodedData != nil) {
        UIColor *selectedColor = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        self.view.backgroundColor = selectedColor;
    }    
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem animated:YES];
}

- (void) cancelAction {
    [self dismissViewControllerAnimated:true completion:nil];
}                                            
                                            
- (IBAction) selectTheme:(id) sender {
    UIButton *themeButton = (UIButton *)sender;
    if (themeButton == nil) {
        return;
    }
    
    if (![self.delegate respondsToSelector: @selector(themesViewController:didSelectTheme:)]) {
        return;
    }
    
    if (self.model == nil) {
        self.model = [[Themes alloc] init];
    }
    
    UIColor *selectedColor;
    if (themeButton.tag == 1) {
        // light theme
        selectedColor = [[self model] theme1];
    } else if (themeButton.tag == 2) {
        // dark theme
        selectedColor = [[self model] theme2];
    } else {
        // shampagne theme
        selectedColor = [[self model] theme3];
    }
    
    [self view].backgroundColor = selectedColor;
    [[self delegate] themesViewController:self didSelectTheme:selectedColor];
}

- (void) dealloc {
    printf("ThemesViewController destroyed");
    [[self model] release];
    [[self delegate] release];
    [super dealloc];
}
                                            
@end
