//
//  GeodeticViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/12/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CustomAlertView.h"

@interface GeodeticViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (assign) double latItem;
@property (assign) double lngItem;
@property (strong, nonatomic) IBOutlet UITableView *geodeticTableView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapInfoSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

- (IBAction)setMapInfo:(id)sender;
- (IBAction)setMapType:(id)sender;
@end
