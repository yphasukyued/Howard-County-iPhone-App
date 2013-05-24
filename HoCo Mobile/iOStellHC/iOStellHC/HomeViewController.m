//
//  HomeViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 12/11/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import "HomeViewController.h"
#import "Annotation.h"
#import "ListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"

@interface HomeViewController () {
    NSMutableData *responseData;
    NSTimer *timer;
    NSTimer *timer1;
    NSMutableArray *json1;
    NSURLConnection *postConnection;
    NSString *newtext;
}

@end


@implementation HomeViewController

@synthesize locationManager,mapView,geoCoder,addressLabel,emailText,weatherLabel,temp_FLabel,weatherImage,loginButton,scrollLabel;


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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.emailText.text = [defaults objectForKey:@"SaveEmailAddress"];
    
    self.emailText.delegate = self;

    locationManager = [[CLLocationManager alloc]init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    /*
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
    */
    
    [self.navigationItem setTitle:@"Login"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [loginButton setBackgroundColor:[UIColor blackColor]];
    [loginButton makeGlossy];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = loginButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [loginButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [loginButton layer];
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
    
    json1 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i = 0; i < [json1 count]; i++) {
        NSDictionary *info = [json1 objectAtIndex:i];
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

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Handle location updates
    [mapView setMapType:MKMapTypeSatellite];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    mapView.showsUserLocation = YES;
    
    MKCoordinateRegion region = {{0.0, 0.0},{0.0, 0.0}};
    region.center.latitude = newLocation.coordinate.latitude;
    region.center.longitude = newLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.0008f;
    region.span.longitudeDelta = 0.0008f;
    [mapView setRegion:region animated:NO];
    

    
    //NSLog(@"Longitude: %f", newLocation.coordinate.longitude);
    
    //Geocoding Block
    [self.geoCoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         //Print the location to console
         //NSLog(@"I am currently at %@",locatedAt);
         
         //Set the label text to current location
         [addressLabel setText:locatedAt];
         
     }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
}

#pragma mark - Delegates for Weather Data
/*
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
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)getLogin:(id)sender {
    [self.view endEditing:YES];
    if ([emailText.text isEqualToString:@""]) {
        CustomAlertView *alertViewer = [[CustomAlertView alloc] initWithTitle:@"Invalid Email" message:@"Please enter valid email" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    }
    else
    {
        if([self validateEmail:[emailText text]] ==1)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.emailText.text forKey:@"SaveEmailAddress"];
            [defaults synchronize];
            ListViewController *listVC = [[ListViewController alloc]init];
            listVC.emailItem = emailText.text;
            
            CATransition *transition = [CATransition animation];
            transition.duration = 1;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"rippleEffect";
            transition.subtype = kCATransitionFromTop;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            [[self navigationController]pushViewController:listVC animated:YES];
        }
        else{
            CustomAlertView *alertViewer = [[CustomAlertView alloc] initWithTitle:@"Invalid Email" message:@"Please enter valid email" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
        }
        
    }
}
@end
