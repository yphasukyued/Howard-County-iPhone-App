//
//  HomeViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 12/11/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomAlertView.h"

@interface HomeViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate, UITextFieldDelegate> {
    MKMapView *mapView;
}


@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UITextField *emailText;

- (IBAction)getLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel;
@property (strong, nonatomic) IBOutlet UILabel *temp_FLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImage;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

@end
