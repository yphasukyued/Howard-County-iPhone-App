//
//  MainViewController.m
//  HCdigCom
//
//  Created by Yongyuth Phasukyued on 3/27/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"
#import "MasterViewController.h"

@interface MainViewController () {
    NSMutableArray *json;
    NSURLConnection *postConnection;
    NSString *newtext;
    NSString *result;
    CustomAlertView *alertViewer;
}

@end

@implementation MainViewController

@synthesize startButton,emailText,emailLabel,aboutTextView,aboutView,closeInfoBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.emailText.text = [defaults objectForKey:@"SaveEmailAddress"];
    
    self.emailText.delegate = self;
    
    self.navigationItem.title = @"Center for Digital Government";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Main" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [startButton setBackgroundColor:[UIColor blackColor]];
    [startButton makeGlossy];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = startButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [startButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [startButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    
    
    [closeInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeInfoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [closeInfoBtn setBackgroundColor:[UIColor blackColor]];
    [closeInfoBtn makeGlossy];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient1 = [CAGradientLayer layer];
    btnGradient1.frame = closeInfoBtn.bounds;
    btnGradient1.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [closeInfoBtn.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer1 = [closeInfoBtn layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer1 setBorderWidth:1.0f];
    [btnLayer1 setBorderColor:[[UIColor blackColor] CGColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:candidate];
}

- (IBAction)signIn:(id)sender {
    
    //[self.view endEditing:YES];
    if ([emailText.text isEqualToString:@""]) {
        emailLabel.hidden = NO;
        emailLabel.text = @"Please enter email";
        //alertViewer = [[CustomAlertView alloc] initWithTitle:@"Invalid Email Format" message:@"Please enter valid email" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        //[alertViewer show];
    }
    else
    {
        if([self validateEmail:[emailText text]] ==1)
        {
            NSString *noCaps = [emailText.text lowercaseString];
            NSLog(@"%@",noCaps);
            
            NSString *str;
            str = [NSString stringWithFormat:@"http://data.howardcountymd.gov/iOSdigCom/checkPWD.asp?pwd=%@", noCaps];
            NSURL *url = [NSURL URLWithString:str];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSError *error;
            
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            for (int i = 0; i < [json count]; i++) {
                NSDictionary *info = [json objectAtIndex:0];
                result = [info objectForKey:@"result"];
            }
            
            if ([result isEqualToString:@"success"]) {
            
                emailLabel.hidden = YES;
                emailLabel.text = @"";
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.emailText.text forKey:@"SaveEmailAddress"];
                [defaults synchronize];
                
                MasterViewController *masterVC = [[MasterViewController alloc]init];
                masterVC.loginItem = noCaps;
                masterVC.memberItem = @"YES";
                
                CATransition *transition = [CATransition animation];
                transition.duration = 1;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = @"rippleEffect";
                transition.subtype = kCATransitionFromTop;
                transition.delegate = self;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                [[self navigationController]pushViewController:masterVC animated:YES];
            
            
            } else if ([result isEqualToString:@"failed"]) {
                
                emailLabel.hidden = YES;
                emailLabel.text = @"";
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.emailText.text forKey:@"SaveEmailAddress"];
                [defaults synchronize];
                
                MasterViewController *masterVC = [[MasterViewController alloc]init];
                masterVC.loginItem = noCaps;
                masterVC.memberItem = @"NO";
                
                CATransition *transition = [CATransition animation];
                transition.duration = 1;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = @"rippleEffect";
                transition.subtype = kCATransitionFromTop;
                transition.delegate = self;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                [[self navigationController]pushViewController:masterVC animated:YES];
            }
            
        }
        else{
            emailLabel.hidden = NO;
            emailLabel.text = @"Please enter valid email";
        }
        
    }
    

}
- (IBAction)openInfo:(id)sender {
    self.navigationItem.title = @"About App.";
    aboutTextView.text = @"CENTER FOR DIGITAL GOVERNMENT\nVersion: 1.0\n\nDeveloped By\nTechnology and Communication Services\nHoward County Maryland";
    [UIView animateWithDuration:1.0 animations:^{
        aboutView.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        aboutView.frame = CGRectMake(0, 0, 320, 548);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            aboutView.alpha = 1.0;
            self.closeInfoBtn.alpha = 1.0;
            self.aboutTextView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (IBAction)closeInfo:(id)sender {
    self.navigationItem.title = @"Center for Digital Government";
    [UIView animateWithDuration:1.0 animations:^{
        aboutView.hidden = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        aboutView.frame = CGRectMake(0, 0, 320, 548);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            aboutView.alpha = 1.0;
            self.closeInfoBtn.alpha = 1.0;
            self.aboutTextView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
@end
