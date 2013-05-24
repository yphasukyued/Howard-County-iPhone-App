//
//  WebViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 2/2/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) id urlItem;
@property (strong, nonatomic) id titleItem;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
