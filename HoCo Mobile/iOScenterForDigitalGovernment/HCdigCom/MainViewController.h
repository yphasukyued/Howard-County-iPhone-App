//
//  MainViewController.h
//  HCdigCom
//
//  Created by Yongyuth Phasukyued on 3/27/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@interface MainViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)signIn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
- (IBAction)openInfo:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closeInfoBtn;

@property (strong, nonatomic) IBOutlet UITextView *aboutTextView;
- (IBAction)closeInfo:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *aboutView;
@end
