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

@interface ContactViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    SLComposeViewController *slComposeViewController;
    UIImage *image;
    UIImagePickerController *imagePicker;
    UIImage *scaledThumbnailImage;
    NSURLConnection *postConnection;
}


@property (strong, nonatomic) id idItem;
@property (strong, nonatomic) id jobTitleItem;
@property (strong, nonatomic) id fullNameItem;
@property (strong, nonatomic) id agencyItem;
@property (strong, nonatomic) id homePhoneItem;
@property (strong, nonatomic) id businessPhoneItem;
@property (strong, nonatomic) id mobilePhoneItem;
@property (strong, nonatomic) id email1Item;
@property (strong, nonatomic) id email2Item;
@property (strong, nonatomic) id biographyItem;
@property (strong, nonatomic) id imageStringItem;


@property (strong, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *agencyLabel;
@property (strong, nonatomic) IBOutlet UILabel *homePhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *businessPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobilePhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *email1Label;
@property (strong, nonatomic) IBOutlet UILabel *email2Label;
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

- (IBAction)openSocial:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *myToolbar;
- (IBAction)portraitButton:(id)sender;
- (IBAction)callButton:(id)sender;
- (IBAction)emailButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)savePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *biographyText;
@property (strong, nonatomic) IBOutlet UIImageView *cameraImage;

@end
