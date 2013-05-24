//
//  MainViewController.m
//  iOSkeyContact
//
//  Created by Yongyuth Phasukyued on 4/13/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"
#import "DepartmentViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize startButton,myTextView;

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
    self.navigationItem.title = @"Howard County Maryland";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Main" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    myTextView.text = @"KEY CONTACT\nVersion: 1.0\n\nDeveloped By\nTechnology and Communication Services\nHoward County Maryland";
    
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
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        DepartmentViewController *deptVC = [[DepartmentViewController alloc]init];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"cube";
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [[self navigationController]pushViewController:deptVC animated:YES];
    } completion:^(BOOL finished) {

    }];
}
@end
