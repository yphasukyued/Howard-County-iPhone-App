//
//  MainViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/8/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomAlertView.h"

@interface MainViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) id agreeItem;


- (IBAction)keyContact:(id)sender;
- (IBAction)tellHC:(id)sender;
- (IBAction)searchPlan:(id)sender;
- (IBAction)geodetic:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

@property (strong, nonatomic) IBOutlet UILabel *tellHCLabel;
@property (strong, nonatomic) IBOutlet UILabel *spLabel;
@property (strong, nonatomic) IBOutlet UILabel *geodeticLabel;
@property (strong, nonatomic) IBOutlet UIButton *spButton;
@property (strong, nonatomic) IBOutlet UIButton *tellHCButton;
@property (strong, nonatomic) IBOutlet UIButton *geodeticButton;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;
@property (strong, nonatomic) IBOutlet UIButton *radioButton;
@property (strong, nonatomic) IBOutlet UILabel *radioLabel;

@property (strong, nonatomic) IBOutlet UILabel *pwdLabel;
@property (strong, nonatomic) IBOutlet UILabel *scrollTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)chkPWD:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *scrollText;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;
- (IBAction)updateScrollText:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)backToMain:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *authoLabel;

- (IBAction)appInfo:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *popupTextView;
@property (strong, nonatomic) IBOutlet UIView *popupContainer;
- (IBAction)closePopup:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIView *agreeContainer;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *agreeButton;
- (IBAction)agreeButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *homeContainer;
@property (strong, nonatomic) IBOutlet UIButton *userAgreeButton;
- (IBAction)userAgreeButton:(id)sender;
- (IBAction)radioHoCo:(id)sender;

@end
