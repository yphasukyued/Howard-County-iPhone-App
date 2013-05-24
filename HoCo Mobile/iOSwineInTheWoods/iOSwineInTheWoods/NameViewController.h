//
//  NameViewController.h
//  WineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/12/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "CustomAlertView.h"

@interface NameViewController : UIViewController<UIAlertViewDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITabBarDelegate>

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

@property (assign) double latItem;
@property (assign) double lngItem;
@property (strong, nonatomic) IBOutlet UITableView *nameTableView;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;
@property (strong, nonatomic) id typeItem;
@property (strong, nonatomic) id tentItem;
@property (strong, nonatomic) id urlItem;
@property (strong, nonatomic) id titleItem;
@property (strong, nonatomic) id phoneItem;
@property CLLocationCoordinate2D coords;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;
- (IBAction)setMapType:(id)sender;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (nonatomic) CGFloat layerPosition;
@property (nonatomic) CGFloat actionLayerPosition;
@property (strong, nonatomic) IBOutlet UIView *topLayer;
- (IBAction)getMap:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITabBar *myTabBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *splitViewButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapButton;
- (IBAction)mapDisplay:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *actionLayer;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)closeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *actionMapButton;
@property (strong, nonatomic) IBOutlet UIButton *actionWebButton;
@property (strong, nonatomic) IBOutlet UIButton *actionCallButton;
@property (strong, nonatomic) IBOutlet UIButton *actionCalendarButton;
@property (strong, nonatomic) IBOutlet UILabel *mapLabel;
@property (strong, nonatomic) IBOutlet UILabel *callLabel;
@property (strong, nonatomic) IBOutlet UILabel *webLabel;
@property (strong, nonatomic) IBOutlet UILabel *calendarLabel;
@property (strong, nonatomic) IBOutlet UIImageView *compassImage;

@property (strong, nonatomic) IBOutlet UIView *actionLayerTop;
- (IBAction)actionMap:(id)sender;
- (IBAction)actionWeb:(id)sender;
- (IBAction)actionCall:(id)sender;
- (IBAction)actionCalendar:(id)sender;

@end
