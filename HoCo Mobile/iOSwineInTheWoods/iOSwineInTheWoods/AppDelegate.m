//
//  AppDelegate.m
//  iOSwineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/13/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <NewRelicAgent/NewRelicAgent.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NewRelicAgent startWithApplicationToken:@"AA8269004153c59d62e9729f698974a54efdf98eeb"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
    [barButtonAppearance setTintColor:[UIColor blackColor]];
    
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSCalendar *gregCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponent = [gregCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    [dateComponent setYear:2013];
    [dateComponent setMonth:05];
    [dateComponent setDay:18];
    [dateComponent setHour:9];
    [dateComponent setMinute:30];
    
    UIDatePicker *dd = [[UIDatePicker alloc]init];
    [dd setDate:[gregCalendar dateFromComponents:dateComponent]];
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    [notification setAlertBody:@"Today Wine in the Woods!"];
    //[notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    [notification setFireDate:dd.date];
    
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    [application setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
