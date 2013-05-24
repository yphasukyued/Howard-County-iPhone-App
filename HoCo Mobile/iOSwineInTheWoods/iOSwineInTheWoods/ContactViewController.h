//
//  ContactViewController.h
//  iOSwineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/23/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import "CustomAlertView.h"

@interface ContactViewController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
