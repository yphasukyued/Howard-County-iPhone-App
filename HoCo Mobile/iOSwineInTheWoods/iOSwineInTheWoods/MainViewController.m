//
//  MainViewController.m
//  iOSkeyContact
//
//  Created by Yongyuth Phasukyued on 4/13/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "MainViewController.h"
#import "NameViewController.h"
#import "WebViewController.h"
#import "MapViewController.h"
#import "ContactViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"

@interface MainViewController () {
    UIActionSheet *actionSht;
    NSString *typeName;
    NSString *urlStr;
    NSString *toggleinfo;
    NSString *bAddress;
    NSString *bCityStateZip;
    NSMutableData *responseData;
    CustomAlertView *alertViewer;
}

@end

@implementation MainViewController

@synthesize startButton,myTextView,welcomeImageView,bgImageView,coords,spinner,locationManager,weatherImage,weatherLabel,temp_FLabel,actionFoodButton,actionWineButton,actionMusicButton,actionCrafterButton,actionLayer,actionLayerTop,foodLabel,wineLabel,musicLabel,crafterLabel,cancelButton,actionMapButton,mapLabel,actionBusButton,actionDirectionButton,busLabel,directionLabel,actionSponsorsButton,sponsorsLabel,wineCheckButton,wineCheckLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    myTextView.hidden = NO;
    [self initial];
    [self stopSpinner];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Howard County Maryland";
    [self stopSpinner];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [myTextView setDelegate:self];
    
    [self initial];
    
    self.actionLayerTop.layer.shadowOffset = CGSizeMake(-2,-2);
    self.actionLayerTop.layer.shadowOpacity = 0.6;
    self.actionLayerTop.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionLayerTop.bounds].CGPath;
    
    self.actionFoodButton.layer.cornerRadius = 5.0;
    self.actionFoodButton.clipsToBounds = YES;
    self.actionFoodButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionFoodButton.layer.borderWidth = 2;
    self.actionFoodButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionFoodButton.layer.shadowOpacity = 0.9;
    self.actionFoodButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionFoodButton.bounds].CGPath;
    
    self.actionWineButton.layer.cornerRadius = 5.0;
    self.actionWineButton.clipsToBounds = YES;
    self.actionWineButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionWineButton.layer.borderWidth = 2;
    self.actionWineButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionWineButton.layer.shadowOpacity = 0.9;
    self.actionWineButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionWineButton.bounds].CGPath;
    
    self.actionMusicButton.layer.cornerRadius = 5.0;
    self.actionMusicButton.clipsToBounds = YES;
    self.actionMusicButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionMusicButton.layer.borderWidth = 2;
    self.actionMusicButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionMusicButton.layer.shadowOpacity = 0.9;
    self.actionMusicButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionMusicButton.bounds].CGPath;
    
    self.actionCrafterButton.layer.cornerRadius = 5.0;
    self.actionCrafterButton.clipsToBounds = YES;
    self.actionCrafterButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionCrafterButton.layer.borderWidth = 2;
    self.actionCrafterButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionCrafterButton.layer.shadowOpacity = 0.9;
    self.actionCrafterButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionCrafterButton.bounds].CGPath;
    
    self.actionMapButton.layer.cornerRadius = 5.0;
    self.actionMapButton.clipsToBounds = YES;
    self.actionMapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionMapButton.layer.borderWidth = 2;
    self.actionMapButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionMapButton.layer.shadowOpacity = 0.9;
    self.actionMapButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionMapButton.bounds].CGPath;
    
    self.actionDirectionButton.layer.cornerRadius = 5.0;
    self.actionDirectionButton.clipsToBounds = YES;
    self.actionDirectionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionDirectionButton.layer.borderWidth = 2;
    self.actionDirectionButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionDirectionButton.layer.shadowOpacity = 0.9;
    self.actionDirectionButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionDirectionButton.bounds].CGPath;
    
    self.actionBusButton.layer.cornerRadius = 5.0;
    self.actionBusButton.clipsToBounds = YES;
    self.actionBusButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionBusButton.layer.borderWidth = 2;
    self.actionBusButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionBusButton.layer.shadowOpacity = 0.9;
    self.actionBusButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionBusButton.bounds].CGPath;
    
    self.actionSponsorsButton.layer.cornerRadius = 5.0;
    self.actionSponsorsButton.clipsToBounds = YES;
    self.actionSponsorsButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionSponsorsButton.layer.borderWidth = 2;
    self.actionSponsorsButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionSponsorsButton.layer.shadowOpacity = 0.9;
    self.actionSponsorsButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionSponsorsButton.bounds].CGPath;
    
    self.wineCheckButton.layer.cornerRadius = 5.0;
    self.wineCheckButton.clipsToBounds = YES;
    self.wineCheckButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.wineCheckButton.layer.borderWidth = 2;
    self.wineCheckButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.wineCheckButton.layer.shadowOpacity = 0.9;
    self.wineCheckButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.wineCheckButton.bounds].CGPath;
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    //Define an NSMutableData object in your header (mine is called responseData).
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/e53791506569d725/conditions/forecast/q/%f,%f.json",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude]]];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc]
                                    initWithRequest:theRequest delegate:self];
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"failed");
    }
    
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
    [btnLayer setBorderWidth:2.0f];
    [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
  
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton makeGlossy];
    
    [cancelButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer1 = [cancelButton layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer1 setBorderWidth:2.0f];
    [btnLayer1 setBorderColor:[[UIColor whiteColor] CGColor]];
    
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
}

#pragma mark - Delegates for Weather Data

 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 {
 [responseData setLength:0];
 }
 
 -(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
 {
 [responseData appendData:data];
 }
 
 - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
 {
 NSString *msg = [NSString stringWithFormat:@"Failed: %@", [error description]];
 NSLog(@"%@",msg);
 }
 
 
 //All the data was loaded, let's see what we've got...
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection
 {
 NSError *myError = nil;
 NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves  error:&myError];
 NSArray *results =  [res objectForKey:@"current_observation"];
 NSArray *cur = [results valueForKey:@"weather"];
 NSArray *tmp = [results valueForKey:@"temp_f"];
 NSArray *icn = [results valueForKey:@"icon_url"];
 NSLog(@"Current conditions: %@, %@º %@", cur, tmp, icn);
 
 weatherLabel.text = [NSString stringWithFormat:@"Current coditions: %@", cur];
 temp_FLabel.text = [NSString stringWithFormat:@"%@ ºF", tmp];
 
 NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",icn]];
 NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
 UIImage *image = [UIImage imageWithData:imageData];
 weatherImage.image = image;
 
 }

- (void)initial {
    
    weatherImage.hidden = YES;
    weatherLabel.hidden = YES;
    temp_FLabel.hidden = YES;
    wineCheckButton.hidden = YES;
    wineCheckLabel.hidden = YES;
    
    
    myTextView.text = @"May 18-19, 2013\nS Y M P H O N Y   W O O D S\nColumbia, MD\n\nCelebrate the charm and character of an event that has aged to perfection! Sample Maryland’s finest wines from a souvenir glass; make food purchases from an abundance of high quality, distinctive restaurants and caterers; sharpen your palate by attending wine education seminars; enjoy exceptional works offered by invited artists and crafts persons; and revel in continuous live entertainment on the Purple and Green stages. The event runs from 11 AM-6 PM on Saturday and 11 AM-5 PM on Sunday. Learn about the designated driver program.\n\nWe recognize that parents may wish to bring their children to Wine in the Woods this year, however as this event is intended for anyone 21+ we are no longer offering face painting or other activities that may appeal to children. The admission fee for Non-Tasters, which includes anyone ages 3-20, is $25 on Saturday and $20 on Sunday.\n\nFor more information call 410-313-4700, or call 410-313-7275.";
    
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        myTextView.frame = CGRectMake(self.view.frame.origin.x + 5, self.view.frame.origin.y + 80, self.view.frame.size.width - 10, self.view.frame.size.height - 195);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            welcomeImageView.alpha = 1.0;
            myTextView.alpha = 1.0;
            startButton.alpha = 1.0;
            bgImageView.alpha = 1.0;
            self.navigationItem.title = @"Howard County Maryland";
        } completion:^(BOOL finished) {

        }];
    }];
    
    toggleinfo = @"yes";
}

- (void)startSpinner {
    [spinner startAnimating];
}

- (void)stopSpinner {
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {
    [self openMenu1];
}

- (void)openMenu1 {
    actionSht = [[UIActionSheet alloc]initWithTitle:nil delegate:self
                                  cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take me to the..."
                                  otherButtonTitles:@"Designated Drivers",@"Wine Check Service",@"Wine Education",@"FAQ",@"Contact Us",nil];
    CGRect myImageRect = CGRectMake(0, 0, 320, 548);
    [actionSht showFromRect:myImageRect inView:self.view animated:YES];
}

- (void)openTypicalInfo {
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        myTextView.frame = CGRectMake(self.view.frame.origin.x + 5, self.view.frame.origin.y + 80, self.view.frame.size.width - 10, self.view.frame.size.height - 260);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            welcomeImageView.alpha = 1.0;
            myTextView.alpha = 1.0;
            startButton.alpha = 1.0;
            bgImageView.alpha = 0;
            wineCheckButton.hidden = NO;
            wineCheckLabel.hidden = NO;
            weatherImage.hidden = YES;
            weatherLabel.hidden = YES;
            temp_FLabel.hidden = YES;
            self.navigationItem.title = [NSString stringWithFormat:@"%@", typeName];
        } completion:^(BOOL finished) {
            
        }];
    }];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Take me to the..."]) {
        [self openActionLayer];
    } else if ([buttonTitle isEqualToString:@"FAQ"]) {
        spinner.hidden = NO;
        [self startSpinner];
        typeName = @"FAQ";
        urlStr = @"http://www.wineinthewoods.com/information/frequently-asked-questions/";
        [self openWebView];
    } else if ([buttonTitle isEqualToString:@"Wine Education"]) {
        typeName = @"Wine Education";
        myTextView.text = @"WINE EDUCATION\n\nSaturday & Sunday\n\nWine education is part of your admission fee.\n\nPresenters: Dana Johnson, Yogi Barrett, Paul Bresson and Larry Elletson of the Tasters Guild Wine Education & Appreciation Society.\n\nNoon\n\nWine Tasting 101 – you will learn the basics of how to evaluate and appreciate wine, which wines to enjoy when, how to cellar your wine, how to preserve your wine and a wealth of other information.\n\n1:00 PM\n\nMaryland White Wines – you will learn the nuances of white wine, come to understand appropriate foods and events to enjoy white wine, proper serving temperature, learn the time frame most white wines should be consumed, plus an array of other information relating to white wines.\n\n2:00 PM\n\nMaryland Red Wines – how best to cellar your red wines, food selections to go with certain varietals of red wines, proper room temperature for serving red wine, why red wines are more age-worthy than white wines and much more.\n\n3:00 PM\n\nMaryland Sweet & Dessert Wines – during our final seminar we will show you the difference from a sweet wine as compared to a dessert wine, how sweet wines can be enjoyed and with what foods, how dessert wine fits into your meal planning so come enjoy the “stickies,” as our Aussie cousins refer to them.\n\nPlease note seating is limited.";
        [self openTypicalInfo];
    } else if ([buttonTitle isEqualToString:@"Wine Check Service"]) {
        typeName = @"Wine Check";
        myTextView.text = @"WINE CHECK SERVICE\n\nNo need to carry around your favorite wines of the day, you may 'check' your purchased wine with us! Bring your wine to the Wine Check tent, conveniently located in the middle of the festival and we’ll keep it safe until you are ready to leave. We will be there until the conclusion of the concert Saturday night and until the close of the festival onn Sunday. Be sure to keep your ticket in a safe place!";
        [self openTypicalInfo];
    } else if ([buttonTitle isEqualToString:@"Designated Drivers"]) {
        typeName = @"Designated Driver";
        myTextView.text = @"DESIGNATED DRIVERS\n\nBe a Hero for the Day\n\nThe Designated Driver wristband provides an alternative for Non-Tasters who wish to enjoy wonderful entertainment, crafts and food at Wine in the Woods. Your Non-Tasters admission entitles you to up to four complimentary beverages at our Designated Driver Booth.  Please present your wristband to the volunteers at our booth, any time during your visit and enjoy a beverage on us! The Designated Driver Tents are sponsored by Herb Gordon Subaru.";
        [self openTypicalInfo];
    } else if ([buttonTitle isEqualToString:@"Contact Us"]) {
        spinner.hidden = NO;
        [self startSpinner];
        [self openContactView];
    } else if ([buttonTitle isEqualToString:@"Cancel"]) {
        [self stopSpinner];
        [self initial];
    }
}

- (void)openContactView {
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            welcomeImageView.alpha = 0;
            startButton.alpha = 0;
        } completion:^(BOOL finished) {
            ContactViewController *contactVC = [[ContactViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 1;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"cube";
            transition.subtype = kCATransitionFromBottom;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [[self navigationController]pushViewController:contactVC animated:YES];
        }];
    }];
    myTextView.text = @"";
}

- (void)openWebView {
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            welcomeImageView.alpha = 0;
            startButton.alpha = 0;
        } completion:^(BOOL finished) {
            WebViewController *webVC = [[WebViewController alloc]init];
            webVC.urlItem = urlStr;
            webVC.titleItem = typeName;
            CATransition *transition = [CATransition animation];
            transition.duration = 1;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"cube";
            transition.subtype = kCATransitionFromBottom;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [[self navigationController]pushViewController:webVC animated:YES];
        }];
    }];
    myTextView.text = @"";
}

- (void)openNameView {
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            welcomeImageView.alpha = 0;
            startButton.alpha = 0;
        } completion:^(BOOL finished) {
            NameViewController *nameVC = [[NameViewController alloc]init];
            nameVC.typeItem = typeName;
            nameVC.tentItem = @"none";
            CATransition *transition = [CATransition animation];
            transition.duration = 1;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"cube";
            transition.subtype = kCATransitionFromBottom;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [[self navigationController]pushViewController:nameVC animated:YES];
        }];
    }];
    myTextView.text = @"";
}

- (void)openMapView {
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            welcomeImageView.alpha = 0;
            startButton.alpha = 0;
        } completion:^(BOOL finished) {
            MapViewController *mapVC = [[MapViewController alloc]init];
            mapVC.typeItem = typeName;
            mapVC.tentItem = @"none";
            CATransition *transition = [CATransition animation];
            transition.duration = 1;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"cube";
            transition.subtype = kCATransitionFromBottom;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [[self navigationController]pushViewController:mapVC animated:YES];
        }];
    }];
    myTextView.text = @"";
}

- (IBAction)toggleInfo:(id)sender {
    self.navigationItem.title = @"Howard County Maryland";
    if ([toggleinfo isEqualToString:@"no"]) {
        weatherImage.hidden = YES;
        weatherLabel.hidden = YES;
        temp_FLabel.hidden = YES;
        wineCheckButton.hidden = YES;
        wineCheckLabel.hidden = YES;
        myTextView.text = @"May 18-19, 2013\nS Y M P H O N Y   W O O D S\nColumbia, MD\n\nCelebrate the charm and character of an event that has aged to perfection! Sample Maryland’s finest wines from a souvenir glass; make food purchases from an abundance of high quality, distinctive restaurants and caterers; sharpen your palate by attending wine education seminars; enjoy exceptional works offered by invited artists and crafts persons; and revel in continuous live entertainment on the Purple and Green stages. The event runs from 11 AM-6 PM on Saturday and 11 AM-5 PM on Sunday. Learn about the designated driver program.\n\nWe recognize that parents may wish to bring their children to Wine in the Woods this year, however as this event is intended for anyone 21+ we are no longer offering face painting or other activities that may appeal to children. The admission fee for Non-Tasters, which includes anyone ages 3-20, is $25 on Saturday and $20 on Sunday.\n\nFor more information call 410-313-4700, or call 410-313-7275.";
        [UIView animateWithDuration:1.0 animations:^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            myTextView.frame = CGRectMake(self.view.frame.origin.x + 5, self.view.frame.origin.y + 80, self.view.frame.size.width - 10, self.view.frame.size.height - 195);
            [UIView commitAnimations];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.0 animations:^{
                welcomeImageView.alpha = 1.0;
                myTextView.alpha = 1.0;
                startButton.alpha = 1.0;
                bgImageView.alpha = 1.0;
            } completion:^(BOOL finished) {

            }];
        }];
        toggleinfo = @"yes";
    } else if ([toggleinfo isEqualToString:@"yes"]) {
        weatherImage.hidden = NO;
        weatherLabel.hidden = NO;
        temp_FLabel.hidden = NO;
        wineCheckButton.hidden = YES;
        wineCheckLabel.hidden = YES;
        myTextView.text = @"iPhone App: Wine in the Woods\nVersion: 1.0\n\nDeveloped By:\nDepartment of Recreation & Parks\nDepartment of Tech. & Comm. Services\nHoward County Maryland";
        [UIView animateWithDuration:1.0 animations:^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            myTextView.frame = CGRectMake(self.view.frame.origin.x + 5, self.view.frame.origin.y + 80, self.view.frame.size.width - 10, self.view.frame.size.height - 310);
            [UIView commitAnimations];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.0 animations:^{
                welcomeImageView.alpha = 1.0;
                myTextView.alpha = 1.0;
                startButton.alpha = 1.0;
                bgImageView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }];
        toggleinfo = @"no";
    }
}

- (void)getDirection {
    
    bAddress = @"5950 Symphony Woods Road";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *addressString = [NSString stringWithFormat:@"%@",bAddress];
    
    [geocoder geocodeAddressString:addressString
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     if (error) {
                         NSLog(@"Geocode failed with error: %@", error);
                         return;
                     }
                     
                     if (placemarks && placemarks.count > 0)
                     {
                         CLPlacemark *placemark = placemarks[0];
                         
                         CLLocation *location = placemark.location;
                         coords = location.coordinate;
                         coords = location.coordinate;
                         
                         [self showMap];
                     }
                 }];
}

-(void)showMap
{
    
    bCityStateZip = @"Columbia, MD 21044";
    NSArray *myArray = [bCityStateZip componentsSeparatedByString:@", "];
    
    NSString *city = [myArray objectAtIndex:0];
    NSString *statezip = [myArray objectAtIndex:1];
    
    NSArray *myArray1 = [statezip componentsSeparatedByString:@" "];
    
    NSString *state = [myArray1 objectAtIndex:0];
    NSString *zip = [myArray1 objectAtIndex:1];
    
    
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: bAddress,
                              (NSString *)kABPersonAddressCityKey: city,
                              (NSString *)kABPersonAddressStateKey: state,
                              (NSString *)kABPersonAddressZIPKey: zip
                              };
    
    MKPlacemark *place = [[MKPlacemark alloc]
                          initWithCoordinate:coords
                          addressDictionary:address];
    
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
    
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                              };
    
    [mapItem openInMapsWithLaunchOptions:options];
}

- (void)viewDidUnload {
    [self setSpinner:nil];
    [self setActionMapButton:nil];
    [self setMapLabel:nil];
    [self setActionDirectionButton:nil];
    [self setActionBusButton:nil];
    [self setDirectionLabel:nil];
    [self setBusLabel:nil];
    [self setActionSponsorsButton:nil];
    [self setSponsorsLabel:nil];
    [self setWineCheckButton:nil];
    [self setWineCheckLabel:nil];
    [super viewDidUnload];
}

- (void)openActionLayer {
    actionLayer.hidden = NO;
            myTextView.text = @"May 18-19, 2013\nS Y M P H O N Y   W O O D S\nColumbia, MD";
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        actionLayer.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            actionLayerTop.frame = CGRectMake(0, self.view.frame.size.height - 278, 320, 278);
            [UIView commitAnimations];
        } completion:^(BOOL finished) {
            wineCheckButton.hidden = YES;
            wineCheckLabel.hidden = YES;
        }];
    }];
}

- (IBAction)closeAction:(id)sender {
    actionLayer.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        actionLayer.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [self openMenu1];
        [self stopSpinner];
    }];
}

- (void)closeActionLayer {
    actionLayer.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        actionLayer.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [self initial];
        [self stopSpinner];
    }];
    
}

- (IBAction)actionFood:(id)sender {
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    typeName = @"Food";
    [self openNameView];
    [self closeActionLayer];
}

- (IBAction)actionWine:(id)sender {
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    typeName = @"Winery";
    [self openNameView];
    [self closeActionLayer];
}

- (IBAction)actionMusic:(id)sender {
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    typeName = @"Entertainment";
    [self openNameView];
    [self closeActionLayer];
}

- (IBAction)actionCrafter:(id)sender {
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    typeName = @"Crafter";
    [self openNameView];
    [self closeActionLayer];
}

- (IBAction)actionMap:(id)sender {
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    typeName = @"Event Map";
    [self openMapView];
    [self closeActionLayer];
}

- (IBAction)actionDirection:(id)sender {
    NSString *addressString = [NSString stringWithFormat:@"This will take you outside of the app, and get driving direction to: 5950 Symphony Woods Rd Columbia, MD 21044"];
    alertViewer = [[CustomAlertView alloc] initWithTitle:@"Leaving App" message:addressString delegate:self cancelButtonTitle:@"GO BACK" otherButtonTitles:@"CONTINUE",nil];
    [alertViewer show];
}

- (IBAction)actionBus:(id)sender {
    /*
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    typeName = @"Satellite Parking";
    urlStr = @"http://data.howardcountymd.gov/iOSwiw/WIWParkingMapWebPhoto.pdf";
    [self openWebView];
    [self closeActionLayer];
    */
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    typeName = @"Shuttle Stop";
    [self openNameView];
    [self closeActionLayer];
}

- (IBAction)actionSponsors:(id)sender {
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    typeName = @"Sponsors";
    [self openNameView];
    [self closeActionLayer];
}

- (IBAction)wineCheckLocation:(id)sender {
    myTextView.hidden = YES;
    spinner.hidden = NO;
    [self startSpinner];
    //typeName = @"Wine Check";
    [self openNameView];
    [self closeActionLayer];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"CONTINUE"]) {
        myTextView.hidden = YES;
        spinner.hidden = NO;
        [self startSpinner];
        [self getDirection];
        [self closeActionLayer];
    }
}
@end
