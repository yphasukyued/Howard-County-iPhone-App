//
//  WebViewController.m
//  iOSwineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/18/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize urlItem,titleItem,myWebView,spinner;

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
    [myWebView loadRequest:request];
    [myWebView setScalesPageToFit:YES];
    
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(stopSpinner) userInfo:nil repeats:NO];
    
}


- (void)stopSpinner {
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
