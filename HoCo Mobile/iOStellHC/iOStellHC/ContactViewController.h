//
//  ContactViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 3/17/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "CustomAlertView.h"
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface ContactViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) id agencyItem;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property CLLocationCoordinate2D coords;

@end
