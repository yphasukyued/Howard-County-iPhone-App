//
//  AppDelegate.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 12/11/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HomeViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
