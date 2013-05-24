//
//  WebViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 2/2/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView,urlItem,spinner,titleItem;

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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",titleItem];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    NSString *str = [NSString stringWithFormat:@"%@", urlItem];
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [webView setScalesPageToFit:YES];
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(stopSpinner) userInfo:nil repeats:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotate) name:UIDeviceOrientationDidChangeNotification object:nil];

    
}

#define degreesToRadian(x) (M_PI * (x) / 180.0)

-(void)rotate{
    
    self.view.bounds = CGRectMake(0, 0, 0, 0);
    
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait){
        
        
        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(0));
        landscapeTransform = CGAffineTransformTranslate (landscapeTransform, 0.0, 0.0);
        
        self.view.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 320, 480);
        
        [self.view setTransform:landscapeTransform];
        
        
    } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        
        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
        landscapeTransform = CGAffineTransformTranslate (landscapeTransform, 0.0, 0.0);
        
        self.view.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 320, 480);
        
        [self.view setTransform:landscapeTransform];
        
    } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight){
        
        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(90));
        
        landscapeTransform = CGAffineTransformTranslate (landscapeTransform, 0.0, 0.0);
        self.view.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 480, 320);
        
        
        [self.view setTransform:landscapeTransform];
        
    }else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft){
        
        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(270));
        
        landscapeTransform = CGAffineTransformTranslate (landscapeTransform, 0.0, 0.0);
        self.view.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 480, 320);
        
        [self.view setTransform:landscapeTransform];
    }
    
}

- (void)stopSpinner {
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
