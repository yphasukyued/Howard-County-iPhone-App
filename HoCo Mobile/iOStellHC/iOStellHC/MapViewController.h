//
//  MapViewController.h
//  MasterView
//
//  Created by Yongyuth Phasukyued on 11/27/12.
//  Copyright (c) 2012 Yongyuth Phasukyued. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomAlertView.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate> {
    MKMapView *mapView;
}
@property (strong, nonatomic) id randomItem;
@property (assign) double latItem;
@property (assign) double lngItem;
@property (strong, nonatomic) id titleMap;
@property (strong, nonatomic) id address1Map;
@property (assign) BOOL displayAll;
@property (assign) BOOL mapEdit;
@property (assign) double neLong;
@property (assign) double neLat;
@property (assign) double swLong;
@property (assign) double swLat;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
-(IBAction)setMap:(id)sender;
-(IBAction)getLocation;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;

@end
