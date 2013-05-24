//
//  ContactViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/16/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "ContactViewController.h"
#import "NSData+Base64.h"
#import "UIImage+Resize.h"
#import "CustomAlertView.h"

@interface ContactViewController ()
{
    NSString *str;
    NSString *hPhone;
    NSString *bPhone;
    NSString *mPhone;
    UIActionSheet *actionSht;
    NSString *eMail1;
    NSString *eMail2;
    NSString *newPicture;
    NSData *thumbnailImageData;
    CustomAlertView *alert;
}

//- (void)configureView;

@end

@implementation ContactViewController

@synthesize jobTitleLabel,fullNameLabel,agencyLabel,homePhoneLabel,businessPhoneLabel,mobilePhoneLabel,email1Label,email2Label,myToolbar,imageStringItem,biographyItem;
@synthesize idItem,jobTitleItem,fullNameItem,agencyItem,homePhoneItem,businessPhoneItem,mobilePhoneItem,email1Item,email2Item,portraitButton,saveBtn,biographyText,cameraImage;

#pragma mark - Managing the detail item

- (void)configureView {
    
    self.jobTitleLabel.text = [NSString stringWithFormat:@"%@",self.jobTitleItem];
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@",self.fullNameItem];
    self.agencyLabel.text = [NSString stringWithFormat:@"%@",self.agencyItem];
    self.biographyText.text = [NSString stringWithFormat:@"%@",self.biographyItem];
    
    hPhone=[homePhoneItem stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hPhone isEqualToString:@""]) {
        homePhoneLabel.text = [NSString stringWithFormat:@"H: not available"];
    } else {
        homePhoneLabel.text = [NSString stringWithFormat:@"H: %@",homePhoneItem];
    }
    
    bPhone=[businessPhoneItem stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([bPhone isEqualToString:@""]) {
        businessPhoneLabel.text = [NSString stringWithFormat:@"W: not available"];
    } else {
        businessPhoneLabel.text = [NSString stringWithFormat:@"W: %@",businessPhoneItem];
    }
    
    mPhone=[mobilePhoneItem stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([mPhone isEqualToString:@""]) {
        mobilePhoneLabel.text = [NSString stringWithFormat:@"M: not available"];
    } else {
        mobilePhoneLabel.text = [NSString stringWithFormat:@"M: %@",mobilePhoneItem];
    }
    
    eMail1=[email1Item stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([eMail1 isEqualToString:@""]) {
        email1Label.text = [NSString stringWithFormat:@"1: not available"];
    } else {
        email1Label.text = [NSString stringWithFormat:@"1: %@",email1Item];
    }
    
    eMail2=[email2Item stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([eMail2 isEqualToString:@""]) {
        email2Label.text = [NSString stringWithFormat:@"2: not available"];
    } else {
        email2Label.text = [NSString stringWithFormat:@"2: %@",email2Item];
    }
    
    NSString *cleanedStr=[imageStringItem stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    thumbnailImageData = [NSData dataFromBase64String:cleanedStr];
    UIImage *newImage = [UIImage imageWithData:thumbnailImageData];
    
    CGSize itemSize = CGSizeMake(45,60);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(2.0, 2.0, itemSize.width, itemSize.height);
    [newImage drawInRect:imageRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [portraitButton setImage:newImage forState:UIControlStateNormal];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [biographyText setDelegate:self];
    
    self.navigationItem.title = @"Profile";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(updateProfile)];
    [self.navigationItem setRightBarButtonItem:searchButton];
    [self configureView];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.jobTitleItem = nil;
    self.fullNameItem = nil;
    self.agencyItem = nil;
    self.homePhoneItem = nil;
    self.businessPhoneItem = nil;
    self.mobilePhoneItem = nil;
    self.email1Item = nil;
    self.email2Item = nil;
    
    newPicture = @"NO";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)openSocial:(id)sender {
    actionSht = [[UIActionSheet alloc]initWithTitle:@"Social Network" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"FaceBook",@"Twitter",nil];
    [actionSht showFromToolbar:(UIToolbar *)myToolbar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"FaceBook"]) {
        [self getFB];
    }
    else if ([buttonTitle isEqualToString:@"Twitter"]) {
        [self getTW];
    }
    else if ([buttonTitle isEqualToString:@"Take a Picture"]) {
        [self takePicture];
    }
    else if ([buttonTitle isEqualToString:@"Pick from Library"]) {
        [self choosePicture];
    }
    else if ([buttonTitle isEqualToString:@"Call Home"]) {
        [self getCall:(NSString *)hPhone];
    }
    else if ([buttonTitle isEqualToString:@"Call Office"]) {
        [self getCall:(NSString *)bPhone];
    }
    else if ([buttonTitle isEqualToString:@"Call Mobile"]) {
        [self getCall:(NSString *)mPhone];
    }
}



-(void)getFB {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController addImage:[UIImage imageNamed:@"icon.png"]];
        [slComposeViewController addURL:[NSURL URLWithString:@""]];
        [self presentViewController:slComposeViewController animated:YES completion:NULL];
    } else {
        alert = [[CustomAlertView alloc] initWithTitle:@"No Facebook Account" message:@"There are no facebook accounts configured. You can add or create a facebook account in settings" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getTW {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposeViewController addImage:[UIImage imageNamed:@"icon.png"]];
        [slComposeViewController addURL:[NSURL URLWithString:@""]];
        [self presentViewController:slComposeViewController animated:YES completion:NULL];
    } else {
        alert = [[CustomAlertView alloc] initWithTitle:@"No Twitter Account" message:@"There are no Twitter accounts configured, to configure a Twitter Account go to Setings" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getCall:(NSString *)phoneNum {
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phoneNum];
    if ([phoneStr isEqualToString:@"tel:"]) {
        alert = [[CustomAlertView alloc] initWithTitle:@"Alert" message:@"Phone number not available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    } else {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:phoneStr]];
    }
}

- (IBAction)portraitButton:(id)sender {
    actionSht = [[UIActionSheet alloc]initWithTitle:@"Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Picture",@"Pick from Library",nil];
    [actionSht showFromToolbar:(UIToolbar *)myToolbar];
}

- (void)choosePicture {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)takePicture {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = YES;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
	scaledThumbnailImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(60.0f, 80.0f) interpolationQuality:kCGInterpolationHigh];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [portraitButton setImage:image forState:UIControlStateNormal];
    
    newPicture = @"YES";
    saveBtn.hidden=NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)callButton:(id)sender {
    if ([hPhone isEqualToString:@""]) {
        if ([bPhone isEqualToString:@""]) {
            if ([mPhone isEqualToString:@""]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Mobile",nil];
            }
        } else {
            if ([mPhone isEqualToString:@""]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",nil];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",@"Call Mobile",nil];
            }
        }
    } else {
        if ([bPhone isEqualToString:@""]) {
            if ([mPhone isEqualToString:@""]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Home",nil];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Home",@"Call Mobile",nil];
            }
        } else {
            if ([mPhone isEqualToString:@""]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",@"Call Home",nil];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",@"Call Home",@"Call Mobile",nil];
            }
        }
    }
    [actionSht showFromToolbar:(UIToolbar *)myToolbar];
}

- (IBAction)emailButton:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    NSString *email1 = eMail1;
    NSString *email2 = eMail2;
    NSArray *emailArray = [[NSArray alloc]initWithObjects:email1,email2, nil];
    NSString *message = @"Hello World";
    [mailController setMessageBody:message isHTML:YES];
    [mailController setToRecipients:emailArray];
    [mailController setSubject:@"Digital Community"];
    [self presentViewController:mailController animated:YES completion:nil];
}

- (IBAction)savePhoto:(id)sender {
    if ([newPicture isEqualToString:@"YES"]) {
        thumbnailImageData = UIImageJPEGRepresentation(scaledThumbnailImage,0.3);
    }
    
    NSString *thumbnailString = [thumbnailImageData base64EncodedString];
    [self postThumbnailImgStr:thumbnailString];
}

-(void) postThumbnailImgStr:(NSString*) ImgStr {
    
    if (ImgStr != nil) {
        NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOSkeyContact/uploadPhoto.asp"];
        [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", ImgStr]];
        [postString appendString:[NSString stringWithFormat:@"&id=%@", idItem]];
        [postString appendString:[NSString stringWithFormat:@"&bio=%@", biographyText.text]];
        
        [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
        [request setHTTPMethod:@"POST"];
        postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        
        alert = [[CustomAlertView alloc] initWithTitle:@"Saved" message:@"" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        biographyText.editable = NO;
        saveBtn.hidden = YES;
        cameraImage.hidden = YES;
    }
}

- (void)updateProfile {
    alert = [[CustomAlertView alloc] initWithTitle:@"Edit Profile" message:@"To update your profile touch on profile picture camera and enter your biography, then touch on Save button." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    biographyText.editable = YES;
    saveBtn.hidden = NO;
    cameraImage.hidden = NO;
}

@end
