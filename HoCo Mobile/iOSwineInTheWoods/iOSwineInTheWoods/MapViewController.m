//
//  MapViewController.m
//  iOSwineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/28/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "MapViewController.h"
#import "MainViewController.h"
#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TileOverlay.h"
#import "TileOverlayView.h"
#import "wiwAnnotation.h"
#import "tentAnnotation.h"
#import "sponsorsAnnotation.h"
#import "busAnnotation.h"
#import "Annotation.h"
#import "UIButton+Glossy.h"

@interface MapViewController (){
    NSMutableArray *json;
    NSMutableArray *json1;
    NSMutableArray *json2;
    NSTimer *timer;
    NSTimer *timer1;
    NSTimer *timer3;
    NSDate *destinationDate;
    NSString *typeName;
    NSString *tentName;
    NSString *imgname;
    NSString *mapDisplay;
    NSString *actionDisplay;
    UIActionSheet *actionSht;
    CustomAlertView *alertViewer;
    int startDD;
    int startMM;
    int startYY;
    int startHour;
    int startMin;
    int epochTime;
    NSString *newtext;
    UIImage *newImage;
    NSString *waddress;
    NSString *city;
    NSString *state;
    NSString *zip;
}

@end

@implementation MapViewController

@synthesize topLayer,layerPosition,myMapView,mapTypeSegment,locationManager,typeItem,nameTableView,scrollLabel,urlItem,latItem,lngItem,titleItem,myWebView,spinner,myTabBar,splitViewButton,tentItem,mapButton,phoneItem,actionLayer,actionLayerPosition,cancelButton,actionMapButton,actionWebButton,actionCallButton,actionCalendarButton,actionLayerTop,mapLabel,callLabel,webLabel,calendarLabel,coords,compassImage;

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define VIEW_HIDDEN 270
#define VIEW_SHOW 0

- (void)openTopLayer {
    
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        topLayer.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)openActionLayer {
    actionLayer.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        actionLayer.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+44, self.view.frame.size.width, self.view.frame.size.height-44);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            actionLayerTop.frame = CGRectMake(0, self.view.frame.size.height - 222, 320, 178);
            [UIView commitAnimations];
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    if ([typeItem isEqualToString:@"Winery"]) {
        [actionCalendarButton setImage:[UIImage imageNamed:@"actionDrive.png"] forState:UIControlStateNormal];
        actionCalendarButton.hidden = NO;
        actionCallButton.hidden = NO;
        calendarLabel.text = @"Drive To";
        calendarLabel.hidden = NO;
        callLabel.hidden = NO;
    } else if ([typeItem isEqualToString:@"Crafter"]
               || [typeItem isEqualToString:@"Sponsors"]
               ) {
        actionCalendarButton.hidden = YES;
        actionCallButton.hidden = YES;
        calendarLabel.hidden = YES;
        callLabel.hidden = YES;
    } else if ([typeItem isEqualToString:@"Green Stage"]
               || [typeItem isEqualToString:@"Purple Stage"]
               || [typeItem isEqualToString:@"Entertainment"]
               ) {
        [actionCalendarButton setImage:[UIImage imageNamed:@"actionCalendar.png"] forState:UIControlStateNormal];
        actionCalendarButton.hidden = NO;
        actionCallButton.hidden = YES;
        calendarLabel.text = @"Calendar";
        calendarLabel.hidden = NO;
        callLabel.hidden = YES;
        [timer invalidate];
        destinationDate = [NSDate dateWithTimeIntervalSince1970:epochTime];
        timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    } else {
        actionCalendarButton.hidden = YES;
        actionCallButton.hidden = YES;
        calendarLabel.hidden = YES;
        callLabel.hidden = YES;
    }
}

- (void)animateLayerToPoint:(CGFloat)x {
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.topLayer.frame;
                         frame.origin.x = x;
                         self.topLayer.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.layerPosition = self.topLayer.frame.origin.x;
                         [self stopSpinner];
                     }];
}

- (IBAction)panLayer:(UIPanGestureRecognizer *)pan {
    if(pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.topLayer];
        CGRect frame = self.topLayer.frame;
        frame.origin.x = self.layerPosition + point.x;
        if (frame.origin.x < 0) frame.origin.x = 0;
        self.topLayer.frame = frame;
        mapDisplay = @"on";
        splitViewButton.image = [UIImage imageNamed:@"arrow-right-icon.png"];
    }
    if(pan.state == UIGestureRecognizerStateEnded) {
        if (self.topLayer.frame.origin.x <= 160) {
            [self animateLayerToPoint:0];
        } else {
            [self animateLayerToPoint:VIEW_HIDDEN];
            mapDisplay = @"off";
            splitViewButton.image = [UIImage imageNamed:@"arrow-left-icon.png"];
        }
    }
}

- (void)openMap {
    if ([mapDisplay isEqualToString:@"off"]) {
        [self animateLayerToPoint:VIEW_SHOW];
        mapDisplay = @"on";
        splitViewButton.image = [UIImage imageNamed:@"arrow-right-icon.png"];
    } else if ([mapDisplay isEqualToString:@"on"]) {
        [self animateLayerToPoint:VIEW_HIDDEN];
        mapDisplay = @"off";
        splitViewButton.image = [UIImage imageNamed:@"arrow-left-icon.png"];
    }
}

-(void) getData:(NSData *) data {
    
    NSError *error;
    json1 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
}

-(void) start
{
    latItem = [[NSString stringWithFormat:@"39.2105178"]doubleValue];
    lngItem = [[NSString stringWithFormat:@"-76.8634293"]doubleValue];
    
    if ([typeItem isEqualToString:@"Winery"]) {
        NSLog(@"tent: %@", tentItem);
        if ([tentItem isEqualToString:@"none"]) {
            [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:1]];
            NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getWineryList.asp";
            NSURL *url = [NSURL URLWithString:str1];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [self getData:data];
        } else {
            [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:1]];
            NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getWineryTent.asp";
            NSString *str2 =[tentItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSString *str3 = [NSString stringWithFormat:@"%@?tentid=%@", str1, str2];
            NSURL *url = [NSURL URLWithString:str3];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [self getData:data];
        }
        
    } else if ([typeItem isEqualToString:@"Green Stage"]) {
        [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:2]];
        NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getEntertainerList.asp?stage=Green";
        NSURL *url = [NSURL URLWithString:str1];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
    } else if ([typeItem isEqualToString:@"Purple Stage"]) {
        [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:2]];
        NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getEntertainerList.asp?stage=Purple";
        NSURL *url = [NSURL URLWithString:str1];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
    } else if ([typeItem isEqualToString:@"Entertainment"]) {
        [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:2]];
        NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getEntertainerList.asp?stage=All";
        NSURL *url = [NSURL URLWithString:str1];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
    }  else if ([typeItem isEqualToString:@"Other"]
                || [typeItem isEqualToString:@"Event Map"]
                ) {
        [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:4]];
        NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getOthersList.asp";
        NSURL *url = [NSURL URLWithString:str1];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
        
    }  else if ([typeItem isEqualToString:@"Sponsors"]) {
        [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:4]];
        NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getOthersList.asp";
        NSURL *url = [NSURL URLWithString:str1];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
        
    } else if ([typeItem isEqualToString:@"Food"]) {
        [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:0]];
        NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getName.asp";
        NSString *str2 =[typeItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *str3 = [NSString stringWithFormat:@"%@?mytype=%@", str1, str2];
        NSURL *url = [NSURL URLWithString:str3];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
        
    } else if ([typeItem isEqualToString:@"Crafter"]) {
        [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:3]];
        NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getName.asp";
        NSString *str2 =[typeItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *str3 = [NSString stringWithFormat:@"%@?mytype=%@", str1, str2];
        NSURL *url = [NSURL URLWithString:str3];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
        
    } else {
        [myTabBar setSelectedItem:[[myTabBar items] objectAtIndex:4]];
        NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getName.asp";
        NSString *str2 =[typeItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *str3 = [NSString stringWithFormat:@"%@?mytype=%@", str1, str2];
        NSURL *url = [NSURL URLWithString:str3];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self getMessages];
    mapDisplay = @"off";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self stopSpinner];
    
    self.topLayer.layer.shadowOffset = CGSizeMake(-2,0);
    self.topLayer.layer.shadowOpacity = 0.9;
    self.topLayer.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.topLayer.bounds].CGPath;
    self.layerPosition = self.topLayer.frame.origin.x;
    
    self.actionLayerTop.layer.shadowOffset = CGSizeMake(-2,-2);
    self.actionLayerTop.layer.shadowOpacity = 0.6;
    self.actionLayerTop.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionLayerTop.bounds].CGPath;
    
    self.actionMapButton.layer.cornerRadius = 5.0;
    self.actionMapButton.clipsToBounds = YES;
    self.actionMapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionMapButton.layer.borderWidth = 2;
    self.actionMapButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionMapButton.layer.shadowOpacity = 0.9;
    self.actionMapButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionMapButton.bounds].CGPath;
    
    self.actionWebButton.layer.cornerRadius = 5.0;
    self.actionWebButton.clipsToBounds = YES;
    self.actionWebButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionWebButton.layer.borderWidth = 2;
    self.actionWebButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionWebButton.layer.shadowOpacity = 0.9;
    self.actionWebButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionWebButton.bounds].CGPath;
    
    self.actionCallButton.layer.cornerRadius = 5.0;
    self.actionCallButton.clipsToBounds = YES;
    self.actionCallButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionCallButton.layer.borderWidth = 2;
    self.actionCallButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionCallButton.layer.shadowOpacity = 0.9;
    self.actionCallButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionCallButton.bounds].CGPath;
    
    self.actionCalendarButton.layer.cornerRadius = 5.0;
    self.actionCalendarButton.clipsToBounds = YES;
    self.actionCalendarButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.actionCalendarButton.layer.borderWidth = 2;
    self.actionCalendarButton.layer.shadowOffset = CGSizeMake(-2,0);
    self.actionCalendarButton.layer.shadowOpacity = 0.9;
    self.actionCalendarButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.actionCalendarButton.bounds].CGPath;
    
    mapDisplay = @"off";
    actionDisplay = @"off";
    
    self.nameTableView.delegate = self;
    self.nameTableView.dataSource = self;
    self.myTabBar.delegate=self;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.headingFilter = 1;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    [myMapView setMapType:MKMapTypeStandard];
    [myMapView setZoomEnabled:YES];
    [myMapView setScrollEnabled:YES];
    myMapView.showsUserLocation = YES;
    myMapView.delegate = self;
    
    MKCoordinateRegion region = {{0.0, 0.0},{0.0, 0.0}};
    region.center.latitude = locationManager.location.coordinate.latitude;
    region.center.longitude = locationManager.location.coordinate.longitude;
    region.span.latitudeDelta = 0.0003f;
    region.span.longitudeDelta = 0.0003f;
    [myMapView setRegion:region animated:YES];
    
    NSString *tileDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WITW"];
    TileOverlay *overlay = [[TileOverlay alloc] initWithTileDirectory:tileDirectory];
    [myMapView addOverlay:overlay];
    
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton makeGlossy];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = cancelButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [cancelButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [cancelButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer setBorderWidth:2.0f];
    [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    
    [self start];
    [nameTableView reloadData];
    
    [self searchPointsList];
    [self setMapCenter];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
	// Convert Degree to Radian and move the needle
	float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
	float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
	CABasicAnimation *theAnimation;
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
	theAnimation.toValue=[NSNumber numberWithFloat:newRad];
	theAnimation.duration = 0.5f;
	[compassImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
	compassImage.transform = CGAffineTransformMakeRotation(newRad);
	NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:overlay];
    view.tileAlpha = 0.6;
    return view;
}

- (void)getMessages {
    NSString *str;
    
    str = @"http://data.howardcountymd.gov/iOSwiw/getMessages.asp?year=2013&month=5";
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i = 0; i < [json count]; i++) {
        NSDictionary *info = [json objectAtIndex:0];
        newtext = [info objectForKey:@"Messages"];
    }
    
    NSString *cleanedString=[newtext stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    scrollLabel.text = cleanedString;
    CGRect bounds = scrollLabel.bounds;
    bounds.size = [cleanedString sizeWithFont:scrollLabel.font];
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

- (IBAction)setMapType:(id)sender {
    switch(((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            myMapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            myMapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

-(void) searchPointsList {
    
    NSString *str1 = @"http://data.howardcountymd.gov/iOSwiw/getPointsList.asp";
    
    NSURL *url = [NSURL URLWithString:str1];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    json2 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    [self removeAllAnnotations];
    [self setPin];
    
    //[locationManager stopUpdatingLocation];
    
}

-(void)removeAllAnnotations
{
    id userAnnotation = self.myMapView.userLocation;
    
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.myMapView.annotations];
    [annotations removeObject:userAnnotation];
    
    [self.myMapView removeAnnotations:annotations];
}

- (void)setPin {
    
    [myMapView setMapType:MKMapTypeStandard];
    [myMapView setZoomEnabled:YES];
    [myMapView setScrollEnabled:YES];
    myMapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D location;
    
    for (int i = 0; i < [json2 count]; i++) {
        
        NSDictionary *loc = [json2 objectAtIndex:i];
        location.latitude = [[loc objectForKey:@"Y"]doubleValue];
        location.longitude = [[loc objectForKey:@"X"]doubleValue];
        
        if ([[loc objectForKey:@"TYPE"] isEqualToString:@"Winery"]
            || [[loc objectForKey:@"TYPE"] isEqualToString:@"Green Stage"]
            || [[loc objectForKey:@"TYPE"] isEqualToString:@"Purple Stage"]
            ) {
            tentAnnotation *ann1 = [[tentAnnotation alloc] init];
            ann1.title = [loc objectForKey:@"NAME"];
            ann1.subtitle = [loc objectForKey:@"DESCRIPTION"];
            ann1.coordinate = location;
            [myMapView addAnnotation:ann1];
        } else if ([[loc objectForKey:@"TYPE"] isEqualToString:@"Crafter"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Designated Driver"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Event Merchandise"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Information"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Sponsors"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Sponsors (car)"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Wine Education"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Wine Check"]
                   ) {
            sponsorsAnnotation *ann2 = [[sponsorsAnnotation alloc] init];
            ann2.title = [loc objectForKey:@"NAME"];
            ann2.subtitle = [loc objectForKey:@"URL2"];
            ann2.coordinate = location;
            [myMapView addAnnotation:ann2];
        } else if ([[loc objectForKey:@"TYPE"] isEqualToString:@"Shuttle Stop"]) {
            busAnnotation *ann3 = [[busAnnotation alloc] init];
            ann3.title = [loc objectForKey:@"NAME"];
            ann3.subtitle = [loc objectForKey:@"DESCRIPTION"];
            ann3.coordinate = location;
            [myMapView addAnnotation:ann3];
        } else if ([[loc objectForKey:@"TYPE"] isEqualToString:@"ATM"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"First Aid"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Photo Booth"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Recycle"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Restrooms"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Restaurants"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"Specialty Foods"]
                   || [[loc objectForKey:@"TYPE"] isEqualToString:@"VIP Tent"]
                   ) {
            wiwAnnotation *ann = [[wiwAnnotation alloc] init];
            ann.title = [loc objectForKey:@"NAME"];
            ann.subtitle = [loc objectForKey:@"DESCRIPTION"];
            ann.coordinate = location;
            [myMapView addAnnotation:ann];
        }
        
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[wiwAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString *annotationIdentifier1 = @"AnnotationIdentifier1";
        MKAnnotationView *pinView1 = (MKAnnotationView *) [myMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier1];
        if (!pinView1)
        {
            
            MKAnnotationView *annotationView1 = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:annotationIdentifier1];
            annotationView1.canShowCallout = YES;
            
            imgname = @"wiw.png";
            
            UIImage *pinImage = [UIImage imageNamed:imgname];
            
            CGRect resizeRect;
            
            resizeRect.size = pinImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [pinImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView1.image = resizedImage;
            annotationView1.opaque = NO;
            
            /*
             UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [annotation title]]]];
             iconView.layer.shadowColor=[UIColor grayColor].CGColor;
             iconView.layer.shadowOffset=CGSizeMake(2, 2);
             iconView.layer.shadowOpacity=0.9;
             annotationView1.leftCalloutAccessoryView = iconView;
             */
            
            annotationView1.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            return annotationView1;
            
        } else {
            pinView1.annotation = annotation;
        }
        return pinView1;
        
    } else if ([annotation isKindOfClass:[tentAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString *annotationIdentifier2 = @"AnnotationIdentifier2";
        MKAnnotationView *pinView2 = (MKAnnotationView *) [myMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier2];
        if (!pinView2)
        {
            
            MKAnnotationView *annotationView2 = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:annotationIdentifier2];
            annotationView2.canShowCallout = YES;
            
            imgname = @"wiw.png";
            
            UIImage *pinImage = [UIImage imageNamed:imgname];
            
            CGRect resizeRect;
            
            resizeRect.size = pinImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [pinImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView2.image = resizedImage;
            annotationView2.opaque = NO;
            
            
            //UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [annotation title]]]];
            //annotationView.leftCalloutAccessoryView = iconView;
            
            annotationView2.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            return annotationView2;
            
        } else {
            pinView2.annotation = annotation;
        }
        return pinView2;
    } else if ([annotation isKindOfClass:[sponsorsAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString *annotationIdentifier3 = @"AnnotationIdentifier3";
        MKAnnotationView *pinView3 = (MKAnnotationView *) [myMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier3];
        if (!pinView3)
        {
            
            MKAnnotationView *annotationView3 = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:annotationIdentifier3];
            annotationView3.canShowCallout = YES;
            
            imgname = @"wiw.png";
            
            UIImage *pinImage = [UIImage imageNamed:imgname];
            
            CGRect resizeRect;
            
            resizeRect.size = pinImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [pinImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView3.image = resizedImage;
            annotationView3.opaque = NO;
            
            /*
             UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [annotation title]]]];
             iconView.layer.shadowColor=[UIColor grayColor].CGColor;
             iconView.layer.shadowOffset=CGSizeMake(2, 2);
             iconView.layer.shadowOpacity=0.9;
             annotationView3.leftCalloutAccessoryView = iconView;
             */
            
            annotationView3.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            return annotationView3;
            
        } else {
            pinView3.annotation = annotation;
        }
        return pinView3;
    } else if ([annotation isKindOfClass:[busAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString *annotationIdentifier4 = @"AnnotationIdentifier4";
        MKAnnotationView *pinView4 = (MKAnnotationView *) [myMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier4];
        if (!pinView4)
        {
            
            MKAnnotationView *annotationView4 = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:annotationIdentifier4];
            annotationView4.canShowCallout = YES;
            
            imgname = @"Shuttle Stop.png";
            
            UIImage *pinImage = [UIImage imageNamed:imgname];
            
            CGRect resizeRect;
            
            resizeRect.size = pinImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [pinImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView4.image = resizedImage;
            annotationView4.opaque = NO;
            
            /*
             UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [annotation title]]]];
             iconView.layer.shadowColor=[UIColor grayColor].CGColor;
             iconView.layer.shadowOffset=CGSizeMake(2, 2);
             iconView.layer.shadowOpacity=0.9;
             annotationView3.leftCalloutAccessoryView = iconView;
             */
            
            annotationView4.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            return annotationView4;
            
        } else {
            pinView4.annotation = annotation;
        }
        return pinView4;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control {
    
    //this determines what kind of item was selected
    if ([control isKindOfClass:[UIButton class]]) {
        Annotation *theAnnotation = (Annotation *) pin.annotation;
        
        NSString *urlStr;
        NSArray *urlArray = [theAnnotation.subtitle componentsSeparatedByString:@"://"];
        urlStr = [urlArray objectAtIndex:0];
        
        if ([theAnnotation.subtitle isEqualToString:@"Winery"]
            || [theAnnotation.subtitle isEqualToString:@"Purple Stage"]
            || [theAnnotation.subtitle isEqualToString:@"Green Stage"]
            || [theAnnotation.subtitle isEqualToString:@"Designated Driver"]
            || [theAnnotation.subtitle isEqualToString:@"Event Merchandise"]
            || [theAnnotation.subtitle isEqualToString:@"Information"]
            || [theAnnotation.subtitle isEqualToString:@"Wine Education"]
            || [theAnnotation.subtitle isEqualToString:@"Wine Check"]
            || [theAnnotation.subtitle isEqualToString:@"ATM"]
            || [theAnnotation.subtitle isEqualToString:@"First Aid"]
            || [theAnnotation.subtitle isEqualToString:@"Photo Booth"]
            || [theAnnotation.subtitle isEqualToString:@"Recycle"]
            || [theAnnotation.subtitle isEqualToString:@"Restrooms"]
            || [theAnnotation.subtitle isEqualToString:@"Restaurants"]
            || [theAnnotation.subtitle isEqualToString:@"Specialty Foods"]
            || [theAnnotation.subtitle isEqualToString:@"VIP Tent"]
            ) {
            spinner.hidden = NO;
            [self startSpinner];
            typeItem = theAnnotation.subtitle;
            tentItem = theAnnotation.title;
            [self start];
            [nameTableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
            mapDisplay = @"on";
            [self openMap];
        } else {
            if ([urlStr isEqualToString:@"http"]) {
                spinner.hidden = NO;
                [self startSpinner];
                typeName = theAnnotation.title;
                tentName = theAnnotation.title;
                urlItem = theAnnotation.subtitle;
                self.navigationItem.title = [NSString stringWithFormat:@"%@", theAnnotation.title];
                mapDisplay = @"off";
                mapTypeSegment.hidden = YES;
                myMapView.hidden = YES;
                compassImage.hidden = YES;
                myWebView.hidden = NO;
                [self openWeb];
                mapButton.enabled = YES;
            } else {
                if ([theAnnotation.subtitle isEqualToString:@"At Purple Entrance"]
                    || [theAnnotation.subtitle isEqualToString:@"At Main Parking Lot"]
                    || [theAnnotation.subtitle isEqualToString:@"At Sterrett Place"]
                    || [theAnnotation.subtitle isEqualToString:@"At Century Plaza"]
                    || [theAnnotation.subtitle isEqualToString:@"At Howard Community College"]
                    ) {
                    spinner.hidden = NO;
                    [self startSpinner];
                    typeItem = @"Shuttle Stop";
                    tentItem = theAnnotation.title;
                    [self start];
                    [nameTableView reloadData];
                    self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
                    mapDisplay = @"on";
                    [self openMap];
                } else {
                    spinner.hidden = NO;
                    [self startSpinner];
                    typeItem = @"Food";
                    [self start];
                    [nameTableView reloadData];
                    self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
                    mapDisplay = @"on";
                    [self openMap];
                }
                
            }
        }
    }
}

- (void)setMapCenter {
    mapTypeSegment.selectedSegmentIndex=0;
    [self searchPointsList];
    mapTypeSegment.hidden = NO;
    myWebView.hidden = YES;
    MKCoordinateRegion region = {{0.0, 0.0},{0.0, 0.0}};
    region.center.latitude = latItem;
    region.center.longitude = lngItem;
    region.span.latitudeDelta = 0.0009f;
    region.span.longitudeDelta = 0.0009f;
    [myMapView setRegion:region animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = region.center;
    point.title = typeName;
    point.subtitle = tentName;
    
    [self.myMapView addAnnotation:point];
    
}

- (void)viewDidUnload {
    
    [self setMapButton:nil];
    [self setActionLayer:nil];
    [self setCancelButton:nil];
    [self setActionLayerTop:nil];
    [self setActionMapButton:nil];
    [self setActionWebButton:nil];
    [self setActionCallButton:nil];
    [self setActionLayerTop:nil];
    [self setActionCalendarButton:nil];
    [self setMapLabel:nil];
    [self setCallLabel:nil];
    [self setWebLabel:nil];
    [self setCalendarLabel:nil];
    [self setCompassImage:nil];
    [super viewDidUnload];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return json1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.imageView.layer.shadowColor=[UIColor grayColor].CGColor;
    cell.imageView.layer.shadowOffset=CGSizeMake(3, 3);
    cell.imageView.layer.shadowOpacity=0.9;
    NSDictionary *info = [json1 objectAtIndex:indexPath.row];
    if ([typeItem isEqualToString:@"Winery"]) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"NAME"]]];
        cell.textLabel.text = [info objectForKey:@"Wine_Maker"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", [info objectForKey:@"TentID"],[info objectForKey:@"City"],[info objectForKey:@"State"],[info objectForKey:@"Zip"]];
        cell.detailTextLabel.numberOfLines=2;
        return cell;
    } else if ([typeItem isEqualToString:@"Green Stage"]
               || [typeItem isEqualToString:@"Purple Stage"]
               || [typeItem isEqualToString:@"Entertainment"]
               ) {
        NSString *stime = [[info objectForKey:@"START_TIME"] stringByReplacingOccurrencesOfString:@":00.0000000" withString:@""];
        NSString *etime = [[info objectForKey:@"END_TIME"] stringByReplacingOccurrencesOfString:@":00.0000000" withString:@""];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"STAGE_NAME"]]];
        cell.textLabel.text = [info objectForKey:@"ENTERTAINER"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@ - %@-%@", [info objectForKey:@"GENRE"],[info objectForKey:@"DATE"],stime,etime];
        cell.detailTextLabel.numberOfLines=2;
        
        return cell;
    } else if ([typeItem isEqualToString:@"Other"]) {
        if ([[info objectForKey:@"TYPE"] isEqualToString:@"Sponsors"]
            || [[info objectForKey:@"TYPE"] isEqualToString:@"Specialty Foods"]
            ) {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"TEXTLABEL"]]];
            cell.textLabel.text = [info objectForKey:@"NAME"];
            cell.detailTextLabel.text = [info objectForKey:@"TYPE"];
            return cell;
        } else {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"NAME"]]];
            cell.textLabel.text = [info objectForKey:@"NAME"];
            cell.detailTextLabel.text = [info objectForKey:@"TYPE"];
            return cell;
        }
        
    } else if ([typeItem isEqualToString:@"Sponsors"]
               || [typeItem isEqualToString:@"Event Map"]
               ) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"TEXTLABEL"]]];
        cell.textLabel.text = [info objectForKey:@"NAME"];
        cell.detailTextLabel.text = [info objectForKey:@"TYPE"];
        return cell;
    } else if ([typeItem isEqualToString:@"Shuttle Stop"]) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"TEXTLABEL"]]];
        cell.textLabel.text = [info objectForKey:@"NAME"];
        cell.detailTextLabel.text = [info objectForKey:@"DESCRIPTION"];
        return cell;
    } else {
        if ([[info objectForKey:@"TYPE"] isEqualToString:@"Specialty Foods"]
            || [[info objectForKey:@"TYPE"] isEqualToString:@"Restaurants"]
            ) {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"TEXTLABEL"]]];
            cell.textLabel.text = [info objectForKey:@"NAME"];
            cell.detailTextLabel.text = [info objectForKey:@"DESCRIPTION"];
            return cell;
        }  else if ([[info objectForKey:@"TYPE"] isEqualToString:@"Crafter"]) {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"A%@.png",[info objectForKey:@"TEXTLABEL"]]];
            cell.textLabel.text = [info objectForKey:@"NAME"];
            cell.detailTextLabel.text = [info objectForKey:@"DESCRIPTION"];
            return cell;
        }  else if ([[info objectForKey:@"TYPE"] isEqualToString:@"Wine Education"]) {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"NAME"]]];
            cell.textLabel.text = [info objectForKey:@"NAME"];
            cell.detailTextLabel.text = [info objectForKey:@"DESCRIPTION"];
            return cell;
        } else {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info objectForKey:@"TYPE"]]];
            cell.textLabel.text = [info objectForKey:@"NAME"];
            cell.detailTextLabel.text = [info objectForKey:@"TYPE"];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [json1 objectAtIndex:indexPath.row];
    latItem = [[info objectForKey:@"Y"]doubleValue];
    lngItem = [[info objectForKey:@"X"]doubleValue];
    if ([typeItem isEqualToString:@"Winery"]) {
        typeName = [info objectForKey:@"Wine_Maker"];
        tentName = [info objectForKey:@"TentID"];
        urlItem = [info objectForKey:@"URL"];
        phoneItem = [info objectForKey:@"Phone"];
        titleItem = [info objectForKey:@"Wine_Maker"];
        waddress = [info objectForKey:@"Address"];
        city = [info objectForKey:@"City"];
        state = [info objectForKey:@"State"];
        zip = [info objectForKey:@"Zip"];
        [self openActionLayer];
    } else if ([typeItem isEqualToString:@"Crafter"]) {
        typeName = [info objectForKey:@"NAME"];
        tentName = [info objectForKey:@"NAME"];
        urlItem = [info objectForKey:@"URL2"];
        titleItem = [info objectForKey:@"NAME"];
        [self openActionLayer];
    } else if ([typeItem isEqualToString:@"Sponsors"]) {
        typeName = [info objectForKey:@"NAME"];
        tentName = [info objectForKey:@"TYPE"];
        urlItem = [info objectForKey:@"URL2"];
        titleItem = [info objectForKey:@"NAME"];
        [self openActionLayer];
    } else if ([typeItem isEqualToString:@"Green Stage"]
               || [typeItem isEqualToString:@"Purple Stage"]
               || [typeItem isEqualToString:@"Entertainment"]
               ) {
        NSString *myDate = [info objectForKey:@"DATE"];
        NSArray *myArray = [myDate componentsSeparatedByString:@"-"];
        startYY = [[myArray objectAtIndex:0]integerValue];
        startMM = [[myArray objectAtIndex:1]integerValue];
        startDD = [[myArray objectAtIndex:2]integerValue];
        
        NSString *myTime = [info objectForKey:@"START_TIME"];
        NSArray *myArray1 = [myTime componentsSeparatedByString:@":"];
        startHour = [[myArray1 objectAtIndex:0]integerValue];
        startMin = [[myArray1 objectAtIndex:1]integerValue];
        epochTime = [[info objectForKey:@"EPOCH_TIME"]integerValue];
        typeName = [info objectForKey:@"ENTERTAINER"];
        tentName = [info objectForKey:@"STAGE_NAME"];
        urlItem = [info objectForKey:@"URL"];
        titleItem = [info objectForKey:@"ENTERTAINER"];
        [self openActionLayer];
    } else {
        typeName = [info objectForKey:@"NAME"];
        tentName = [info objectForKey:@"TYPE"];
        urlItem = [info objectForKey:@"URL2"];
        titleItem = [info objectForKey:@"NAME"];
        mapDisplay = @"off";
        mapTypeSegment.hidden = NO;
        myMapView.hidden = NO;
        compassImage.hidden = NO;
        myWebView.hidden = YES;
        [self setMapCenter];
        [self openWeb];
        mapButton.enabled = NO;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@", titleItem];
}

- (void)openWeb {
    
    NSString *str = [NSString stringWithFormat:@"%@", urlItem];
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    [myWebView setScalesPageToFit:YES];
    
    [self openMap];
    
    NSTimer *timer2;
    timer2 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(stopSpinner) userInfo:nil repeats:NO];
}

- (void)startSpinner {
    [spinner startAnimating];
}

- (void)stopSpinner {
    [spinner stopAnimating];
}

- (IBAction)getMap:(id)sender {
    if ([mapDisplay isEqualToString:@"off"]) {
        [self animateLayerToPoint:VIEW_SHOW];
        mapDisplay = @"on";
        splitViewButton.image = [UIImage imageNamed:@"arrow-right-icon.png"];
    } else if ([mapDisplay isEqualToString:@"on"]) {
        [self animateLayerToPoint:VIEW_HIDDEN];
        mapDisplay = @"off";
        splitViewButton.image = [UIImage imageNamed:@"arrow-left-icon.png"];
    }
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self activateTab:item.tag];
}

- (void)activateTab:(int)index {
    switch (index) {
        case 0:
            typeItem = @"Food";
            [self start];
            [nameTableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
            [timer3 invalidate];
            [self getMessages];
            break;
        case 1:
            typeItem = @"Winery";
            tentItem = @"none";
            [self start];
            [nameTableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
            [timer3 invalidate];
            [self getMessages];
            break;
        case 2:
            typeItem = @"Entertainment";
            tentItem = @"none";
            [self start];
            [nameTableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
            [timer3 invalidate];
            [self getMessages];
            break;
        case 3:
            typeItem = @"Crafter";
            [self start];
            [nameTableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
            [timer3 invalidate];
            [self getMessages];
            break;
        case 4:
            typeItem = @"Sponsors";
            [self start];
            [nameTableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"%@", typeItem];
            [timer3 invalidate];
            [self getMessages];
            break;
        default:
            break;
            
    }
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Add to Calendar"]) {
        [self setCalendar];
    } else if ([buttonTitle isEqualToString:@"Call"]) {
        [self getCall:(NSString *)phoneItem];
    } else if ([buttonTitle isEqualToString:@"Event Map"]) {
        [self setMapCenter];
        myMapView.hidden = NO;
        mapTypeSegment.hidden = NO;
        compassImage.hidden = NO;
        myWebView.hidden = YES;
        [self openWeb];
        mapButton.enabled = NO;
    } else if ([buttonTitle isEqualToString:@"Web Site"]) {
        [self setMapCenter];
        myMapView.hidden = YES;
        mapTypeSegment.hidden = YES;
        compassImage.hidden = YES;
        myWebView.hidden = NO;
        [self openWeb];
        mapButton.enabled = YES;
    }
    
    [self getMessages];
    spinner.hidden = NO;
    [self startSpinner];
    
}

-(void)getCall:(NSString *)phoneNum {
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phoneNum];
    if ([phoneStr isEqualToString:@"tel:"]) {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Alert" message:@"Phone number not available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertViewer show];
    } else {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:phoneStr]];
    }
}

- (void)setCalendar
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    // display error message here
                }
                else if (!granted)
                {
                    // display access denied error message here
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    // create an instance of event with the help of event-store object.
                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                    
                    // set the title of the event.
                    event.title = [NSString stringWithFormat:@"%@", typeName];
                    
                    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
                    [dateComponents setYear:startYY];
                    [dateComponents setMonth:startMM];
                    [dateComponents setDay:startDD];
                    [dateComponents setHour:startHour];
                    [dateComponents setMinute:startMin];
                    
                    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    
                    NSDate *dateStart = [calendar dateFromComponents:dateComponents];
                    
                    [dateComponents setHour:startHour+1];
                    NSDate *dateEnd = [calendar dateFromComponents:dateComponents];
                    
                    event.startDate = dateStart;
                    event.endDate = dateEnd;
                    event.allDay = NO;
                    event.location = @"Wine in the Woods";
                    event.notes = tentName;
                    event.URL = [NSURL URLWithString:@""];
                    
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:-60*60]];
                    
                    // set the calendar of the event. - here default calendar
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    
                    // store the event using EventStore.
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    alertViewer = [[CustomAlertView alloc] initWithTitle:@"Event Added" message:@"Calendar updated" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    [alertViewer show];
                }
            });
        }];
    }
    else
    {
        // this code runs in iOS 4 or iOS 5
        // ***** do the important stuff here *****
    }
}
- (IBAction)mapDisplay:(id)sender {
    mapButton.enabled = NO;
    myWebView.hidden = YES;
    myMapView.hidden = NO;
    mapTypeSegment.hidden = NO;
    compassImage.hidden = NO;
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
        
    }];
}

- (IBAction)actionMap:(id)sender {
    [self setMapCenter];
    myMapView.hidden = NO;
    mapTypeSegment.hidden = NO;
    compassImage.hidden = NO;
    myWebView.hidden = YES;
    [self openWeb];
    mapButton.enabled = NO;
    [self closeActionLayer];
}

- (IBAction)actionWeb:(id)sender {
    [self setMapCenter];
    myMapView.hidden = YES;
    mapTypeSegment.hidden = YES;
    compassImage.hidden = YES;
    myWebView.hidden = NO;
    [self openWeb];
    mapButton.enabled = YES;
    [self closeActionLayer];
}

- (IBAction)actionCall:(id)sender {
    alertViewer = [[CustomAlertView alloc] initWithTitle:@"Leaving App" message:@"This will take you outside of the app." delegate:self cancelButtonTitle:@"GO BACK" otherButtonTitles:@"CONTINUE CALL",nil];
    [alertViewer show];
}

- (IBAction)actionCalendar:(id)sender {
    if ([typeItem isEqualToString:@"Winery"]) {
        NSString *addressString = [NSString stringWithFormat:@"This will take you outside of the app, and get driving direction to: %@ %@, %@ %@",waddress,city,state,zip];
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Leaving App" message:addressString delegate:self cancelButtonTitle:@"GO BACK" otherButtonTitles:@"CONTINUE",nil];
        [alertViewer show];
    } else if ([typeItem isEqualToString:@"Green Stage"]
               || [typeItem isEqualToString:@"Purple Stage"]
               || [typeItem isEqualToString:@"Entertainment"]
               ) {
        [self setCalendar];
        [self closeActionLayer];
    }
}

- (void)updateLabel {
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date] toDate:destinationDate options:0];
    
    [timer invalidate];
    scrollLabel.center = CGPointMake(160, 22);
    if ([scrollLabel.text isEqualToString:@"Show Time: 0d 0h 10m 0s"]) {
        [timer3 invalidate];
        NSString *showString = [NSString stringWithFormat:@"%@ will be on the %@ in 10 minutes",typeName,tentName];
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Show Time" message:showString delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    } else {
        scrollLabel.text = [NSString stringWithFormat:@"Show Time: %d%c %d%c %d%c %d%c", [components day],'d',[components hour],'h',[components minute],'m',[components second],'s'];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Close"]) {
        [timer3 invalidate];
        [self getMessages];
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    } else if ([buttonTitle isEqualToString:@"CONTINUE CALL"]) {
        [self getCall:(NSString *)phoneItem];
    } else if ([buttonTitle isEqualToString:@"CONTINUE"]) {
        [self getDirection];
    }
}

- (void)getDirection {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *addressString = [NSString stringWithFormat:@"%@ %@, %@ %@",waddress,city,state,zip];
    
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
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: waddress,
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

@end
