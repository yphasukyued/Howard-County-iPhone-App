//
//  MainViewController.h
//  iOSkeyContact
//
//  Created by Yongyuth Phasukyued on 4/13/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <MapKit/MapKit.h>
#import "CustomAlertView.h"

@interface MainViewController : UIViewController<CLLocationManagerDelegate, UIActionSheetDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)start:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *welcomeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
- (IBAction)toggleInfo:(id)sender;
@property CLLocationCoordinate2D coords;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel;
@property (strong, nonatomic) IBOutlet UILabel *temp_FLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImage;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIView *actionLayer;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)closeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *actionFoodButton;
@property (strong, nonatomic) IBOutlet UIButton *actionWineButton;
@property (strong, nonatomic) IBOutlet UIButton *actionMusicButton;
@property (strong, nonatomic) IBOutlet UIButton *actionCrafterButton;
@property (strong, nonatomic) IBOutlet UIButton *actionMapButton;
@property (strong, nonatomic) IBOutlet UIButton *actionDirectionButton;
@property (strong, nonatomic) IBOutlet UIButton *actionBusButton;
@property (strong, nonatomic) IBOutlet UIButton *actionSponsorsButton;
@property (strong, nonatomic) IBOutlet UIButton *wineCheckButton;

@property (strong, nonatomic) IBOutlet UILabel *foodLabel;
@property (strong, nonatomic) IBOutlet UILabel *wineLabel;
@property (strong, nonatomic) IBOutlet UILabel *musicLabel;
@property (strong, nonatomic) IBOutlet UILabel *crafterLabel;
@property (strong, nonatomic) IBOutlet UILabel *mapLabel;
@property (strong, nonatomic) IBOutlet UILabel *directionLabel;
@property (strong, nonatomic) IBOutlet UILabel *busLabel;
@property (strong, nonatomic) IBOutlet UILabel *sponsorsLabel;
@property (strong, nonatomic) IBOutlet UILabel *wineCheckLabel;

@property (strong, nonatomic) IBOutlet UIView *actionLayerTop;
- (IBAction)actionFood:(id)sender;
- (IBAction)actionWine:(id)sender;
- (IBAction)actionMusic:(id)sender;
- (IBAction)actionCrafter:(id)sender;
- (IBAction)actionMap:(id)sender;
- (IBAction)actionDirection:(id)sender;
- (IBAction)actionBus:(id)sender;
- (IBAction)actionSponsors:(id)sender;
- (IBAction)wineCheckLocation:(id)sender;

@end
