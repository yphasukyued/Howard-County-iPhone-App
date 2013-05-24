//
//  RadioViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 3/21/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "RadioViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"

@interface RadioViewController () {
    NSTimer *timer;
    NSTimer *timer1;
    NSMutableArray *json;
    NSMutableArray *json1;
    NSURLConnection *postConnection;
    NSString *newtext;
}

@end

@implementation RadioViewController

@synthesize webView,playButton,scrollLabel;

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
    self.navigationItem.title = @"HoCo LIVE!";
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [playButton setBackgroundColor:[UIColor blackColor]];
    [playButton makeGlossy];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = playButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [playButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [playButton layer];
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

- (IBAction)PlayRadio:(id)sender {
    
    NSString *urlstr;
    
    urlstr = @"http://data.howardcountymd.gov/iOScontact/getRadio.asp";
    
    NSURL *myurl = [NSURL URLWithString:urlstr];
    
    NSData *mydata = [NSData dataWithContentsOfURL:myurl];
    
    NSError *error;
    
    json1 = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
    
    NSString *radioURL;
    
    for (int i = 0; i < [json1 count]; i++) {
        NSDictionary *info = [json1 objectAtIndex:i];
        radioURL = [info objectForKey:@"URL"];
    }
    
    webView.hidden = NO;
    //NSString *str = [NSString stringWithFormat:@"http://cent4.serverhostingcenter.com/tunein.php/mdehaven/playlist.pls"];
    //NSString *str = [NSString stringWithFormat:@"http://www.bbc.co.uk/radio/listen/live/r1.pls"];
    NSURL *url = [NSURL URLWithString:radioURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
@end
