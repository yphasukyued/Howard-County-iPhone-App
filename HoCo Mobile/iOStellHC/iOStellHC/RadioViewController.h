//
//  RadioViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 3/21/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioViewController : UIViewController
- (IBAction)PlayRadio:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

@end
