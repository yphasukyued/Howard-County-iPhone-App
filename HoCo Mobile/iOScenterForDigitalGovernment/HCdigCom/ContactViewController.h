//
//  ContactViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/16/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <AddressBook/AddressBook.h>
#import "CustomAlertView.h"

@interface ContactViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate> {
    SLComposeViewController *slComposeViewController;
    UIImage *image;
    UIImagePickerController *imagePicker;
    UIImage *scaledThumbnailImage;
    NSURLConnection *postConnection;
}

@property (strong, nonatomic) id phoneItem1;
@property (strong, nonatomic) id phoneItem;
@property (strong, nonatomic) id memberItem1;
@property (strong, nonatomic) id loginItem1;
@property (strong, nonatomic) id idItem;
@property (strong, nonatomic) id jobTitleItem;
@property (strong, nonatomic) id fullNameItem;
@property (strong, nonatomic) id email1Item;
@property (strong, nonatomic) id biographyItem;
@property (strong, nonatomic) id imageStringItem;

@property (strong, nonatomic) IBOutlet UIView *myView;
- (IBAction)cancelEdit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *fbBtn;
@property (strong, nonatomic) IBOutlet UIButton *phoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *twBtn;

- (IBAction)phoneButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
- (IBAction)portraitButton:(id)sender;
- (IBAction)emailButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)savePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *biographyText;
@property (strong, nonatomic) IBOutlet UIImageView *cameraImage;
- (IBAction)fbButton:(id)sender;
- (IBAction)twButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UILabel *officePhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobilePhoneLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneText1;

@end
