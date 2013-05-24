//
//  SearchPlanViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/10/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CustomAlertView.h"

@interface SearchPlanViewController : UIViewController<UITableViewDataSource, UIActionSheetDelegate, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate>

@property (assign) double latItem;
@property (assign) double lngItem;
@property (strong, nonatomic) IBOutlet UITableView *searchPlanTableView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapInfoSegment;

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

- (IBAction)setMapInfo:(id)sender;
- (IBAction)setMap:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)historySwitch:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *historySwitch;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *historyToolbar;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

@end
