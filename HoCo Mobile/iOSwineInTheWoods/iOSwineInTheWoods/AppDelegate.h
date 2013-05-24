//
//  AppDelegate.h
//  iOSwineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/13/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) MainViewController *viewController;
@end
