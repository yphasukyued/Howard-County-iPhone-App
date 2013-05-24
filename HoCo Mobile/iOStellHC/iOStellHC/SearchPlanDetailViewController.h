//
//  SearchPlanDetailViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/11/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "CustomAlertView.h"

//#import <dispatch/dispatch.h>

@interface SearchPlanDetailViewController : UIViewController<UITextViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MKMapViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) id searchTypeItem;
@property (strong, nonatomic) id idItem;
@property (assign) double latItem;
@property (assign) double lngItem;

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

@property (strong, nonatomic) id titleMap;
@property (strong, nonatomic) id subTitleMap;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
-(IBAction)setMap:(id)sender;
-(IBAction)setMapInfo:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapInfoSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolbar;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

@end
