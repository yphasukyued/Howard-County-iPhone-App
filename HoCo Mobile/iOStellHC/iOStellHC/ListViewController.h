//
//  ListViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 12/12/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CustomAlertView.h"

@interface ListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, MKMapViewDelegate>

@property (assign) double latItem;
@property (assign) double lngItem;

@property (strong, nonatomic) id emailItem;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapInfoSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;
- (IBAction)setMapInfo:(id)sender;
- (IBAction)setMapType:(id)sender;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

@end
