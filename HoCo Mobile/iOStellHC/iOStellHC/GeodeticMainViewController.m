//
//  GeodeticMainViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/17/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "GeodeticMainViewController.h"
#import "GeodeticViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"
#import "WebViewController.h"

@interface GeodeticMainViewController () {
    NSTimer *timer;
    NSTimer *timer1;
    NSMutableArray *json;
    NSURLConnection *postConnection;
    NSString *newtext;
}

@end

@implementation GeodeticMainViewController

@synthesize startButton,scrollLabel;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Geodetic Controls";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Main" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    //UIBarButtonItem *tutorialButton = [[UIBarButtonItem alloc]initWithTitle:@"Tutorial" style:UIBarButtonItemStylePlain target:self action:@selector(openTutorial)];
    //[self.navigationItem setRightBarButtonItem:tutorialButton];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    
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

- (void)getMessages {
    NSString *str;
    
    str = @"http://data.howardcountymd.gov/iOScontact/getMessages.asp";
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i = 0; i < [json count]; i++) {
        NSDictionary *info = [json objectAtIndex:i];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openTutorial
{
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.urlItem = @"http://www.youtube.com/embed/sPOlcHv7XNg";
    webVC.titleItem = @"Tutorial";
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[self navigationController]pushViewController:webVC animated:YES];
}

- (IBAction)startButton:(id)sender {
    GeodeticViewController *geoVC = [[GeodeticViewController alloc]init];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[self navigationController]pushViewController:geoVC animated:YES];
}
@end
