//
//  WebViewController.h
//  iOSwineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/18/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) id urlItem;
@property (strong, nonatomic) id titleItem;
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
