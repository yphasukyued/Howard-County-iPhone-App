//
//  DetailViewController.h
//  HoCoEDA
//
//  Created by Yongyuth Phasukyued on 12/9/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TapDetectingImageView.h"
#import "CustomAlertView.h"

@interface DetailViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
    SLComposeViewController *slComposeViewController;
    UIImage *image;
    UIScrollView *imageScrollView;
    NSString *httpSource;

}

@property (strong, nonatomic) id idItem;
@property (strong, nonatomic) id categoryItem;
@property (strong, nonatomic) id incidentItem;
@property (strong, nonatomic) id statusItem;
@property (strong, nonatomic) id FSimageItem1;
@property (strong, nonatomic) id FSimageItem2;
@property (strong, nonatomic) id FSimageItem3;
@property (strong, nonatomic) id FSimageItem4;
@property (strong, nonatomic) id FSimageItem5;
@property (strong, nonatomic) id FSimageItem6;
@property (strong, nonatomic) id FSimageItem7;
@property (strong, nonatomic) id FSimageItem8;
@property (strong, nonatomic) id FSimageItem9;
@property (strong, nonatomic) id FSimageItem10;
@property (assign) double latItem;
@property (assign) double lngItem;
@property (strong, nonatomic) id emailItem;

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

@property (strong, nonatomic) IBOutlet UITextView *descriptionText;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;
- (IBAction)setDisplay:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;
- (IBAction)setMapType:(id)sender;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

@end
