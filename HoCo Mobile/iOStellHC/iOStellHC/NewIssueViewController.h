//
//  NewIssueViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 12/13/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import "CustomAlertView.h"

#define Category 0
#define Incident 1

@interface NewIssueViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate> {
    
    IBOutlet UIProgressView *progressView;
    IBOutlet UIPickerView *CategoryPicker;
    IBOutlet UIToolbar *myToolBar;
    
    CustomAlertView *alertViewer;
    UITextField *myTextField;
    
    UIImage *image;
    UIImage *scaledThumbnailImage;
    UIImage *scaledFullsizeImage;
    UIImagePickerController *imagePicker;
    NSURLConnection *postConnection;
    NSString *fullsizeString;
    NSString *fullsizeString1;
    NSString *fullsizeString2;
    NSString *fullsizeString3;
    NSString *fullsizeString4;
    NSString *fullsizeString5;
    NSString *fullsizeString6;
    NSString *fullsizeString7;
    NSString *fullsizeString8;
    NSString *fullsizeString9;
    NSString *fullsizeString10;
    NSString *randomString;
    double latY;
    double lngX;
    NSString *newMedia;
    
}

@property (assign) double latItem;
@property (assign) double lngItem;
@property (strong, nonatomic) id emailItem;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegment;

- (IBAction)dismissButton:(UIBarButtonItem *)sender;
- (IBAction)nextButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolBar;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *incidentLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pictureLabel;

- (IBAction)showStep:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageStep1;
@property (weak, nonatomic) IBOutlet UIImageView *imageStep2;
@property (weak, nonatomic) IBOutlet UIImageView *imageStep3;
@property (weak, nonatomic) IBOutlet UIImageView *imageStep4;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
- (IBAction)uploadIncident:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (strong, nonatomic) IBOutlet UITextView *tempTextView;

@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *screenSaver;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;


@end
