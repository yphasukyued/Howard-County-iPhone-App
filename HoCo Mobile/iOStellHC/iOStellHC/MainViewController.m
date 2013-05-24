//
//  MainViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/8/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "MainViewController.h"
#import "TellHCMainViewController.h"
#import "DepartmentViewController.h"
#import "SearchPlanMainViewController.h"
#import "GeodeticMainViewController.h"
#import "UIButton+Glossy.h"
#import "RadioViewController.h"

@interface MainViewController () {
    BOOL check;
    NSTimer *timer;
    NSTimer *timer1;
    NSMutableArray *json;
    NSMutableArray *json1;
    NSURLConnection *postConnection;
    NSString *newtext;
    NSString *result;
    CustomAlertView *alertViewer;
}

@end

@implementation MainViewController

@synthesize spLabel,tellHCLabel,geodeticLabel,spButton,tellHCButton,geodeticButton,popupTextView,popupContainer,closeButton,agreeButton,checkButton,agreeItem,agreeContainer,homeContainer,contactButton,contactLabel,userAgreeButton,scrollLabel,goButton,pwdTextField,scrollText,pwdLabel,updateButton,cancelButton,scrollTextLabel,authoLabel,radioButton,radioLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [self getMessages];
    self.geodeticLabel.alpha = 1.0;
    self.geodeticButton.alpha = 1.0;
    self.tellHCLabel.alpha = 1.0;
    self.tellHCButton.alpha = 1.0;
    self.spLabel.alpha = 1.0;
    self.spButton.alpha = 1.0;
    self.contactLabel.alpha = 1.0;
    self.contactButton.alpha = 1.0;
    self.radioLabel.alpha = 1.0;
    self.radioButton.alpha = 1.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"HoCo Mobile"];
    
    self.pwdTextField.delegate = self;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showPWD)];
    [self.navigationItem setRightBarButtonItem:editButton];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    
    
    //[self setAniLabel];
    agreeItem=@"No";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.agreeItem = [defaults objectForKey:@"Agreement"];
    
    if ([agreeItem isEqualToString:@"Yes"]) {
        agreeContainer.hidden=YES;
        homeContainer.hidden=NO;
        popupContainer.hidden=YES;
        [UIView animateWithDuration:2.0 animations:^ {
            agreeContainer.alpha=0.0;
            homeContainer.alpha=1.0;
            popupContainer.alpha=0.0;
        }];
    } else if ([agreeItem isEqualToString:@"No"]) {
        agreeContainer.hidden=NO;
        homeContainer.hidden=YES;
        popupContainer.hidden=YES;
        [UIView animateWithDuration:2.0 animations:^ {
            agreeContainer.alpha =1.0;
            homeContainer.alpha=0.0;
            popupContainer.alpha=0.0;
        }];
    } else {
        agreeContainer.hidden=NO;
        homeContainer.hidden=YES;
        popupContainer.hidden=YES;
        [UIView animateWithDuration:2.0 animations:^ {
            agreeContainer.alpha =1.0;
            homeContainer.alpha=0.0;
            popupContainer.alpha=0.0;
        }];
    }
    
    //Accept & continue button
    [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [agreeButton setBackgroundColor:[UIColor blackColor]];
    [agreeButton makeGlossy];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = agreeButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [agreeButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [agreeButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    //get user agreement view
    [userAgreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userAgreeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [userAgreeButton setBackgroundColor:[UIColor blackColor]];
    [userAgreeButton makeGlossy];
    
    [agreeButton.layer insertSublayer:btnGradient atIndex:1];
    
    // Round button corners
    CALayer *btnLayer1 = [userAgreeButton layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer1 setBorderWidth:1.0f];
    [btnLayer1 setBorderColor:[[UIColor blackColor] CGColor]];
    
    //go password button
    [goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [goButton setBackgroundColor:[UIColor blackColor]];
    [goButton makeGlossy];
    
    [goButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer2 = [goButton layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer2 setBorderWidth:1.0f];
    [btnLayer2 setBorderColor:[[UIColor blackColor] CGColor]];
    
    //update password button
    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [updateButton setBackgroundColor:[UIColor blackColor]];
    [updateButton makeGlossy];
    
    [updateButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer3 = [updateButton layer];
    [btnLayer3 setMasksToBounds:YES];
    [btnLayer3 setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer3 setBorderWidth:1.0f];
    [btnLayer3 setBorderColor:[[UIColor blackColor] CGColor]];
    
    //cancel password button
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton makeGlossy];
    
    [cancelButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer4 = [cancelButton layer];
    [btnLayer4 setMasksToBounds:YES];
    [btnLayer4 setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer4 setBorderWidth:1.0f];
    [btnLayer4 setBorderColor:[[UIColor blackColor] CGColor]];
    
    //cancel password button
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [closeButton setBackgroundColor:[UIColor blackColor]];
    [closeButton makeGlossy];
    
    [closeButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer5 = [closeButton layer];
    [btnLayer5 setMasksToBounds:YES];
    [btnLayer5 setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer5 setBorderWidth:1.0f];
    [btnLayer5 setBorderColor:[[UIColor blackColor] CGColor]];
    
    check=YES;
}

- (void)getMessages {
    NSString *str;
    
    str = @"http://data.howardcountymd.gov/iOScontact/getMessages.asp";
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i = 0; i < [json count]; i++) {
        NSDictionary *info = [json objectAtIndex:0];
        newtext = [info objectForKey:@"Messages"];
    }

    scrollLabel.text = newtext;
    CGRect bounds = scrollLabel.bounds;
    bounds.size = [newtext sizeWithFont:scrollLabel.font];
    scrollLabel.bounds = bounds;
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(getMessages) userInfo:nil repeats:YES];
    
}

- (void)time:(NSTimer *)theTimer {
    scrollLabel.center = CGPointMake(scrollLabel.center.x-2, scrollLabel.center.y);
    if (scrollLabel.center.x < -(scrollLabel.bounds.size.width/2)) {
        scrollLabel.center = CGPointMake(320 + (scrollLabel.bounds.size.width/2), scrollLabel.center.y);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)showPWD {
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            popupContainer.alpha = 0.0;
            homeContainer.alpha = 0.0;
            agreeContainer.alpha = 0.0;
            popupContainer.hidden = YES;
            homeContainer.hidden= YES;
            agreeContainer.hidden= YES;

        } completion:^(BOOL finished) {
            
        }];
    }];
    updateButton.hidden = YES;
    scrollText.hidden = YES;
    pwdTextField.hidden = NO;
    cancelButton.hidden = NO;
    goButton.hidden = NO;
    pwdLabel.hidden = NO;
    authoLabel.hidden = NO;
    pwdTextField.text = @"";
}

- (IBAction)chkPWD:(id)sender {
    if ([pwdTextField.text isEqualToString:@""]) {
        scrollText.hidden = YES;
        pwdTextField.hidden = NO;
        goButton.hidden = NO;
        cancelButton.hidden = NO;
        pwdLabel.hidden = NO;
        pwdLabel.text = @"Please enter password!";
        alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Please enter password!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alertViewer setDelegate:self];
        [alertViewer show];
    } else {
        
        NSString *str;
        str = [NSString stringWithFormat:@"http://data.howardcountymd.gov/iOScontact/checkPWD.asp?pwd=%@", pwdTextField.text];
        NSURL *url = [NSURL URLWithString:str];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        
        json1 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        for (int i = 0; i < [json1 count]; i++) {
            NSDictionary *info = [json1 objectAtIndex:0];
            result = [info objectForKey:@"result"];
        }
        
        if ([result isEqualToString:@"success"]) {
            [UIView animateWithDuration:1.0 animations:^{
            } completion:^(BOOL finished) {
                scrollText.text = scrollLabel.text;
                scrollText.hidden = NO;
                scrollTextLabel.hidden = NO;
                pwdTextField.hidden = YES;
                goButton.hidden = YES;
                cancelButton.hidden = NO;
                updateButton.hidden = NO;
                pwdLabel.hidden = YES;
            }];
        } else if ([result isEqualToString:@"failed"]) {
            scrollText.hidden = YES;
            pwdTextField.hidden = NO;
            goButton.hidden = NO;
            cancelButton.hidden = NO;
            pwdLabel.hidden = NO;
            pwdLabel.text = @"Incorrected Password!";
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Incorrected Password!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            
            [alertViewer setDelegate:self];
            [alertViewer show];
        }
    }
}

- (IBAction)updateScrollText:(id)sender {
    
    NSString *cleanedString=[scrollText.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOScontact/UpdateMessages.asp"];
    [postString appendString:[NSString stringWithFormat:@"?messages=%@", cleanedString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getMessages) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:1.0 animations:^{
        cancelButton.hidden = YES;
        updateButton.hidden = YES;
        scrollText.hidden = YES;
        scrollTextLabel.hidden = YES;
        pwdTextField.hidden = YES;
        goButton.hidden = YES;
        pwdLabel.hidden = YES;
        authoLabel.hidden = YES;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            popupContainer.alpha = 0.0;
            homeContainer.alpha = 1.0;
            agreeContainer.alpha = 0.0;
            popupContainer.hidden = YES;
            homeContainer.hidden= NO;
            agreeContainer.hidden= YES;
        } completion:^(BOOL finished) {
            
        }];
    }];
    [scrollText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAniLabel {
    // Create the keyframe animation object
    CAKeyframeAnimation *scaleAnimation =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    // Set the animation's delegate to self so that we can add callbacks if we want
    scaleAnimation.delegate = self;
    
    // Create the transform; we'll scale x and y by 1.5, leaving z alone
    // since this is a 2D animation.
    CATransform3D transform = CATransform3DMakeScale(5, 1, 1); // Scale in x and y
    
    // Add the keyframes.  Note we have to start and end with CATransformIdentity,
    // so that the label starts from and returns to its non-transformed state.
    [scaleAnimation setValues:[NSArray arrayWithObjects:
                               [NSValue valueWithCATransform3D:CATransform3DIdentity],
                               [NSValue valueWithCATransform3D:transform],
                               [NSValue valueWithCATransform3D:CATransform3DIdentity],
                               nil]];
    
    // set the duration of the animation
    [scaleAnimation setDuration: .5];
    
    // animate your label layer = rock and roll!
    [[self.spLabel layer] addAnimation:scaleAnimation forKey:@"Search Plans"];
    [[self.tellHCLabel layer] addAnimation:scaleAnimation forKey:@"tellHC"];
    [[self.geodeticLabel layer] addAnimation:scaleAnimation forKey:@"Geodetic"];
    [[self.contactLabel layer] addAnimation:scaleAnimation forKey:@"Key Department"];

}
- (IBAction)keyContact:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.geodeticLabel.alpha = 0.0;
        self.geodeticButton.alpha = 0.0;
        self.tellHCLabel.alpha = 0.0;
        self.tellHCButton.alpha = 0.0;
        self.spLabel.alpha = 0.0;
        self.spButton.alpha = 0.0;
        self.radioLabel.alpha = 0.0;
        self.radioButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        DepartmentViewController *departmentVC = [[DepartmentViewController alloc]init];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"rippleEffect";
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [[self navigationController]pushViewController:departmentVC animated:YES];
    }];
}

- (IBAction)tellHC:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.geodeticLabel.alpha = 0.0;
        self.geodeticButton.alpha = 0.0;
        self.spLabel.alpha = 0.0;
        self.spButton.alpha = 0.0;
        self.contactLabel.alpha = 0.0;
        self.contactButton.alpha = 0.0;
        self.radioLabel.alpha = 0.0;
        self.radioButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        TellHCMainViewController *thcVC = [[TellHCMainViewController alloc]init];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"rippleEffect";
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [[self navigationController]pushViewController:thcVC animated:YES];
    }];
}

- (IBAction)searchPlan:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.geodeticLabel.alpha = 0.0;
        self.geodeticButton.alpha = 0.0;
        self.tellHCLabel.alpha = 0.0;
        self.tellHCButton.alpha = 0.0;
        self.contactLabel.alpha = 0.0;
        self.contactButton.alpha = 0.0;
        self.radioLabel.alpha = 0.0;
        self.radioButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        SearchPlanMainViewController *spVC = [[SearchPlanMainViewController alloc]init];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"alignedCube";
        transition.subtype = kCATransitionFromLeft;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [[self navigationController]pushViewController:spVC animated:YES];
    }];
}

- (IBAction)geodetic:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.tellHCLabel.alpha = 0.0;
        self.tellHCButton.alpha = 0.0;
        self.spLabel.alpha = 0.0;
        self.spButton.alpha = 0.0;
        self.contactLabel.alpha = 0.0;
        self.contactButton.alpha = 0.0;
        self.radioLabel.alpha = 0.0;
        self.radioButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        GeodeticMainViewController *geoVC = [[GeodeticMainViewController alloc]init];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"cube";
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [[self navigationController]pushViewController:geoVC animated:YES];
    }];
}

- (IBAction)backToMain:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        cancelButton.hidden = YES;
        updateButton.hidden = YES;
        scrollText.hidden = YES;
        scrollTextLabel.hidden = YES;
        pwdTextField.hidden = YES;
        goButton.hidden = YES;
        pwdLabel.hidden = YES;
        authoLabel.hidden = YES;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            popupContainer.alpha = 0.0;
            homeContainer.alpha = 1.0;
            agreeContainer.alpha = 0.0;
            popupContainer.hidden = YES;
            homeContainer.hidden= NO;
            agreeContainer.hidden= YES;
        } completion:^(BOOL finished) {

        }];
    }];
    [scrollText resignFirstResponder];

}

- (IBAction)appInfo:(id)sender {
    popupTextView.text = @"A B O U T\n\nApp's Name: HoCo Mobile\nVersion: 1.0 / Updated: 03.01.2013\nDeveloped by:\nDept of Tech and Comm Services\nHoward County Maryland\n\nDescription: HoCo Mobile is the official Howard County government iPhone/iPad app portal to bring mobile ready information and services to the residents of Howard County Maryland. More services and web related content to be incorporated in the near future. Version 1.0 contains:\n\nContacts:\nFind contact information and make phone calls and emails directly from your phone.\n\nGeodetic\nIf you are a surveyor performing surveying work in Howard County, this interactive mapping app will let you find the nearest geodetic benchmarks and stations to your survey site.  Also, display Howard County Survey scanned recovery cards linked to each geodetic feature simply by clicking the feature and the feature’s link in the map or by list.\n\nHoCo LIVE! is a simulcast of Howard County’s 1700 AM radio station.  It provides locally focused weather and emergency information along with timely updates about special events and programs taking place in the County.\n\nSearch Plans:\nSearch for current and past Land Development Proposals as well as Presubmission Community Meetings and other land use related Public Hearings and Meetings in Howard County, MD. View PDF plan documents related to development, and email or call project planners and engineers directly from the app.\n\nTell HoCo:\nReport issues like potholes, graffiti, downed trees and other items directly from your smart phone.  Take a picture of the issue, check a few options, provide a brief description, and send it directly to Howard County.  You can also view other actively reported issues.  Additional Issue categories will be introduced as the app matures.\n\nThis app has been developed by Howard County and is not related to Third Party apps created for or contracted by Howard County.";
    [UIView animateWithDuration:1.0 animations:^{
        popupContainer.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        popupTextView.frame = CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + 30, self.view.frame.size.width - 20, self.view.frame.size.height - 95);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            popupContainer.alpha = 1.0;
            homeContainer.alpha = 0.0;
            agreeContainer.alpha = 0.0;
            homeContainer.hidden= YES;
            agreeContainer.hidden= YES;
            self.closeButton.alpha = 1.0;
            self.popupTextView.alpha = 1.0;
            self.userAgreeButton.alpha = 1.0;
        } completion:^(BOOL finished) {

        }];
    }];
}

- (void)popupOff {
    [UIView animateWithDuration:1.0 animations:^{
        self.closeButton.alpha = 0.0;
        self.popupTextView.alpha = 0.0;
        self.userAgreeButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            popupTextView.frame = CGRectMake(self.view.frame.origin.x + 10, self.view.frame.size.height, self.view.frame.size.width - 20, 0);
            homeContainer.alpha=1.0;
            popupContainer.alpha=0.0;
            agreeContainer.alpha=0.0;
            homeContainer.hidden=NO;
            agreeContainer.hidden=YES;
            popupContainer.hidden = YES;
            [UIView commitAnimations];
        } completion:^(BOOL finished) {
        }];
    }];
}

- (IBAction)closePopup:(id)sender {
        [self popupOff];
}
- (IBAction)checkButton:(id)sender {
    if (check==YES) {
        [checkButton setImage:[UIImage imageNamed:@"checkbox_checked_icon.png"]forState:UIControlStateNormal];
        check=NO;
        agreeButton.hidden=NO;
    }
    else if (check==NO) {
        [checkButton setImage:[UIImage imageNamed:@"checkbox_unchecked_icon.png"]forState:UIControlStateNormal];
        check=YES;
        agreeButton.hidden=YES;
    }
}
- (IBAction)agreeButton:(id)sender {
    agreeItem=@"Yes";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.agreeItem forKey:@"Agreement"];
    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 animations:^ {
        homeContainer.hidden=NO;
        agreeContainer.alpha=0.0;
        popupContainer.alpha=0.0;
        agreeContainer.hidden=YES;
        popupContainer.hidden=YES;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
        homeContainer.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }];
}
- (IBAction)userAgreeButton:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.closeButton.alpha = 0.0;
        self.popupTextView.alpha = 0.0;
        self.userAgreeButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            popupTextView.frame = CGRectMake(0, 548, 320, 0);
            homeContainer.alpha=0.0;
            popupContainer.alpha=0.0;
            agreeContainer.alpha=1.0;
            homeContainer.hidden=YES;
            agreeContainer.hidden=NO;
            popupContainer.hidden = YES;
            [UIView commitAnimations];
        } completion:^(BOOL finished) {
        }];
    }];
}

- (IBAction)radioHoCo:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.geodeticLabel.alpha = 0.0;
        self.geodeticButton.alpha = 0.0;
        self.tellHCLabel.alpha = 0.0;
        self.tellHCButton.alpha = 0.0;
        self.spLabel.alpha = 0.0;
        self.spButton.alpha = 0.0;
        self.contactLabel.alpha = 0.0;
        self.contactButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        RadioViewController *radioVC = [[RadioViewController alloc]init];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"alignedCube";
        transition.subtype = kCATransitionFromLeft;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [[self navigationController]pushViewController:radioVC animated:YES];
    }];
}
@end
