//
//  SearchPlanMainViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/17/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "SearchPlanMainViewController.h"
#import "SearchPlanViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"
#import "WebViewController.h"

@interface SearchPlanMainViewController () {
    NSTimer *timer;
    NSTimer *timer1;
    NSMutableArray *json;
    NSURLConnection *postConnection;
    NSString *newtext;
}

@end

@implementation SearchPlanMainViewController
@synthesize startButton,popupContainer,popupTextView,arrowImage,closeButton,scrollLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self popupOff];
}

-(void)viewDidAppear:(BOOL)animated {
    [self getMessages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Search Plans";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Main" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    //UIBarButtonItem *tutorialButton = [[UIBarButtonItem alloc]initWithTitle:@"Tutorial" style:UIBarButtonItemStylePlain target:self action:@selector(openTutorial)];
    //[self.navigationItem setRightBarButtonItem:tutorialButton];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    
    [popupTextView setDelegate:self];
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
    webVC.urlItem = @"http://www.youtube.com/embed/-Zf3rUHsWmU";
    webVC.titleItem = @"Tutorial";
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"alignedCube";
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[self navigationController]pushViewController:webVC animated:YES];
}

- (IBAction)psButton:(id)sender {

    popupTextView.text = @"Presubmission Community Meetings\n\nC01-99: Conditional Use\nM01-99: Zoning Map Amendment Request\nN01-99: Non-Residential Development\nV01-99: Columbia Village Redevelopment\nR01-99: Residential Development\nT01-99: Down Town Columbia\n\nThese meetings are held by the applicant prior to submitting a plan or application to the Department of Planning and Zoning.";
    
    popupContainer.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    closeButton.frame = CGRectMake(222, 124, 20, 20);
    popupTextView.frame = CGRectMake(15, 120, 230, 220);
    arrowImage.frame = CGRectMake(0, 130, 15, 40);
    [UIView commitAnimations];
}

- (IBAction)phButton:(id)sender {
    popupTextView.text = @"Public Hearings\n\nB01-99: Board of Appeals\nD01-99: Administrative Adj, Temporary Uses, Non-Conforming Uses\nH01-99: Hearing Examiner\nP01-99: Planning Board\nZ01-99: Zoning Board";
    
    popupContainer.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    closeButton.frame = CGRectMake(222, 164, 20, 20);
    popupTextView.frame = CGRectMake(15, 160, 230, 170);
    arrowImage.frame = CGRectMake(0, 170, 15, 40);
    [UIView commitAnimations];
}

- (IBAction)sdpButton:(id)sender {
    popupTextView.text = @"Site Development Plans\n\nResidential and non-residential site development plans. Current year plans are those under review or signed within the current year. Past year plans include plans signed during that year.";
    
    popupContainer.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    closeButton.frame = CGRectMake(222, 204, 20, 20);
    popupTextView.frame = CGRectMake(15, 200, 230, 130);
    arrowImage.frame = CGRectMake(0, 210, 15, 40);
    [UIView commitAnimations];
}

- (IBAction)sipButton:(id)sender {
    popupTextView.text = @"Subdivision Plans\n\nResidential and non-residential subdivision plans. Current year plans are those under review or recorded within the current year. Past year plans include plans recorded during that year. ";
    
    popupContainer.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    closeButton.frame = CGRectMake(222, 204, 20, 20);
    popupTextView.frame = CGRectMake(15, 200, 230, 130);
    arrowImage.frame = CGRectMake(0, 250, 15, 40);
    [UIView commitAnimations];
}

- (IBAction)wpButton:(id)sender {
    popupTextView.text = @"Waiver Petitions\n\nCurrent year waiver petitions are those under review or decided upon within the current year. Past year waiver petitions include those with decisions made during that year. ";
    
    popupContainer.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    closeButton.frame = CGRectMake(222, 214, 20, 20);
    popupTextView.frame = CGRectMake(15, 210, 230, 130);
    arrowImage.frame = CGRectMake(0, 290, 15, 40);
    [UIView commitAnimations];
}

- (void)popupOff {
    [UIView animateWithDuration:1.0 animations:^{
        self.closeButton.alpha = 0.0;
        self.popupTextView.alpha = 0.0;
        self.arrowImage.alpha = 0.0;
    } completion:^(BOOL finished) {
        popupContainer.hidden = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.closeButton.alpha = 1.0;
        self.popupTextView.alpha = 1.0;
        self.arrowImage.alpha = 1.0;
        closeButton.frame = CGRectMake(222, 24, 20, 20);
        popupTextView.frame = CGRectMake(15, 20, 230, 130);
        arrowImage.frame = CGRectMake(0, 30, 15, 40);
        [UIView commitAnimations];
    }];
}

- (IBAction)closePopup:(id)sender {
    [self popupOff];
}

- (IBAction)startButton:(id)sender {
    [self popupOff];
    SearchPlanViewController *spVC = [[SearchPlanViewController alloc]init];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"alignedCube";
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[self navigationController]pushViewController:spVC animated:YES];
}
@end
