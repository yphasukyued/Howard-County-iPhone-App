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
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"

@interface ContactViewController ()
{
    UIActionSheet *actionSht;
    NSString *eMail1;
    NSString *eMail2;
    NSString *newPicture;
    NSData *thumbnailImageData;
    CustomAlertView *alertViewer;
    UIImage *img;
}

//- (void)configureView;

@end

@implementation ContactViewController

@synthesize jobTitleLabel,fullNameLabel,imageStringItem,biographyItem,emailLabel,phoneText,phoneItem,phoneItem1,phoneText1,myView,cancelBtn,fbBtn,twBtn,phoneBtn,emailButton;
@synthesize idItem,jobTitleItem,fullNameItem,email1Item,portraitButton,saveBtn,biographyText,cameraImage,loginItem1,memberItem1,officePhoneLabel,mobilePhoneLabel;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.jobTitleLabel.text = [NSString stringWithFormat:@"%@",self.jobTitleItem];
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@",self.fullNameItem];
    self.biographyText.text = [NSString stringWithFormat:@"%@",self.biographyItem];
    
    eMail1=[email1Item stringByReplacingOccurrencesOfString:@" " withString:@""];
    eMail2=[loginItem1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([memberItem1 isEqualToString:@"YES"]) {
        self.emailLabel.text = [NSString stringWithFormat:@"%@", eMail1];
    } else if ([memberItem1 isEqualToString:@"NO"]) {
        self.emailLabel.text = @"";
    }
    
    if ([imageStringItem isEqualToString:@"none"]) {
        img=[UIImage imageNamed:@"portrait.jpeg"];
    } else {
        NSString *cleanedStr=[imageStringItem stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        thumbnailImageData = [NSData dataFromBase64String:cleanedStr];
        img=[UIImage imageWithData:thumbnailImageData];

    }
    
    cameraImage =[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 45, 60)];
    cameraImage.layer.borderWidth=3;
    cameraImage.layer.borderColor=[UIColor whiteColor].CGColor;
    cameraImage.layer.shadowColor=[UIColor grayColor].CGColor;
    cameraImage.layer.shadowOffset=CGSizeMake(2, 2);
    cameraImage.layer.shadowOpacity=1.0;
    cameraImage.image = img;
    [self.view addSubview:cameraImage];
    
    [biographyText setDelegate:self];
    [phoneText setDelegate:self];
    [phoneText1 setDelegate:self];
    
    self.navigationItem.title = @"Profile";

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    if ([[NSString stringWithFormat:@"%@",eMail2] isEqualToString:[NSString stringWithFormat:@"%@",eMail1]]) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(updateProfile)];
        [self.navigationItem setRightBarButtonItem:editButton];
    }
    
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [saveBtn setBackgroundColor:[UIColor blackColor]];
    [saveBtn makeGlossy];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = saveBtn.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [saveBtn.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [saveBtn layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    [cancelBtn setBackgroundColor:[UIColor blackColor]];
    [cancelBtn makeGlossy];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient1 = [CAGradientLayer layer];
    btnGradient1.frame = cancelBtn.bounds;
    btnGradient1.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [cancelBtn.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer1 = [cancelBtn layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer1 setBorderWidth:1.0f];
    [btnLayer1 setBorderColor:[[UIColor blackColor] CGColor]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

        return [textField resignFirstResponder];
        
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phoneText resignFirstResponder];
    [biographyText resignFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phoneText resignFirstResponder];
    [biographyText resignFirstResponder];
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
    self.email1Item = nil;
    
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Take a Picture"]) {
        [self takePicture];
    }
    else if ([buttonTitle isEqualToString:@"Pick from Library"]) {
        [self choosePicture];
    } else if ([buttonTitle isEqualToString:@"Call Office"]) {
        [self getCall:(NSString *)phoneItem];
    } else if ([buttonTitle isEqualToString:@"Call Mobile"]) {
        [self getCall:(NSString *)phoneItem1];
    }
}

- (IBAction)portraitButton:(id)sender {
    actionSht = [[UIActionSheet alloc]initWithTitle:@"Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Picture",@"Pick from Library",nil];
    
    CGRect myImageRect = CGRectMake(0, 0, 320, 548);
    [actionSht showFromRect:myImageRect inView:self.view animated:YES];
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
    
	scaledThumbnailImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(60.0f, 80.0f) interpolationQuality:kCGInterpolationHigh];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[portraitButton setImage:image forState:UIControlStateNormal];
    cameraImage.image=image;
    
    newPicture = @"YES";
    saveBtn.hidden=NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)emailButton:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    mailController.navigationBar.tintColor = [UIColor blackColor];
    if ([memberItem1 isEqualToString:@"YES"]) {
        NSString *email1 = eMail1;
        NSArray *emailArray = [[NSArray alloc]initWithObjects:email1, nil];
        NSString *message = @"You are a member of this group";
        [mailController setMessageBody:message isHTML:YES];
        [mailController setToRecipients:emailArray];
        [mailController setSubject:@"Center for Digital Government"];
        [self presentViewController:mailController animated:YES completion:nil];
    } else if ([memberItem1 isEqualToString:@"NO"]) {
        NSString *email1 = @"";
        NSArray *emailArray = [[NSArray alloc]initWithObjects:email1, nil];
        NSString *message = @"You are not memeber of this group";
        [mailController setMessageBody:message isHTML:YES];
        [mailController setToRecipients:emailArray];
        [mailController setSubject:@"Center for Digital Government"];
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

- (IBAction)savePhoto:(id)sender {
    if ([newPicture isEqualToString:@"YES"]) {
        thumbnailImageData = UIImageJPEGRepresentation(scaledThumbnailImage,0.3);
    }
    
    NSString *thumbnailString = [thumbnailImageData base64EncodedString];
    
    NSString *cleanedThumbnailString=[thumbnailString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *thumbnailString1=[cleanedThumbnailString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self postThumbnailImgStr:thumbnailString1];
}

-(void) postThumbnailImgStr:(NSString*) ImgStr {
        if (ImgStr != nil) {
            NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOSdigCom/uploadPhoto.asp"];
            [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", ImgStr]];
            [postString appendString:[NSString stringWithFormat:@"&id=%@", idItem]];
            [postString appendString:[NSString stringWithFormat:@"&bio=%@", biographyText.text]];
            [postString appendString:[NSString stringWithFormat:@"&phone=%@", phoneText.text]];
            [postString appendString:[NSString stringWithFormat:@"&phone1=%@", phoneText1.text]];
            
            [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
            [request setHTTPMethod:@"POST"];
            postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
            
            alertViewer = [[CustomAlertView alloc] initWithTitle:@"Saved" message:@"" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            [self resetView];
        }
}

- (void)updateProfile {
    alertViewer = [[CustomAlertView alloc] initWithTitle:@"Edit Profile" message:@"To update your profile picture touch on camera and update your info., then touch on Save button." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alertViewer show];
    
    [self editView];
}

- (void)editView {
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        myView.frame = CGRectMake(0, -70, 320, 548);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            biographyText.editable = YES;
            saveBtn.hidden = NO;
            cameraImage.hidden = NO;
            portraitButton.hidden = NO;
            portraitButton.enabled = YES;
            phoneText.hidden = NO;
            phoneText1.hidden = NO;
            officePhoneLabel.hidden = NO;
            mobilePhoneLabel.hidden = NO;
            cancelBtn.hidden = NO;
            phoneBtn.hidden = YES;
            fbBtn.hidden = YES;
            twBtn.hidden = YES;
            emailButton.hidden = YES;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (void)resetView {
    [UIView animateWithDuration:1.0 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        myView.frame = CGRectMake(0, 0, 320, 548);
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        biographyText.editable = NO;
        saveBtn.hidden = YES;
        cameraImage.hidden = NO;
        portraitButton.hidden = YES;
        portraitButton.enabled = NO;
        phoneText.hidden = YES;
        phoneText1.hidden = YES;
        officePhoneLabel.hidden = YES;
        mobilePhoneLabel.hidden = YES;
        cancelBtn.hidden = YES;
        phoneBtn.hidden = NO;
        fbBtn.hidden = NO;
        twBtn.hidden = NO;
        emailButton.hidden = NO;
    }];
}
- (IBAction)fbButton:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController addImage:[UIImage imageNamed:@"icon.png"]];
        [slComposeViewController addURL:[NSURL URLWithString:@""]];
        [self presentViewController:slComposeViewController animated:YES completion:NULL];
    } else {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"No Facebook Account" message:@"There are no facebook accounts configured. You can add or create a facebook account in settings" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    }
}

- (IBAction)twButton:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposeViewController addImage:[UIImage imageNamed:@"icon.png"]];
        [slComposeViewController addURL:[NSURL URLWithString:@""]];
        [self presentViewController:slComposeViewController animated:YES completion:NULL];
    } else {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"No Twitter Account" message:@"There are no Twitter accounts configured, to configure a Twitter Account go to Setings" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    }
}

- (BOOL) validatePhone: (NSString *) candidate {
    NSString *phoneRegex = @"\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:candidate];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if([self validatePhone:[textField text]] ==1) {

    } else {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Use phone format below" message:@"XXX-XXX-XXXX" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    }
    return YES;
}

-(void)getCall:(NSString *)phoneNum {
    NSString *cleanedPhone =[phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",cleanedPhone];
    if ([phoneStr isEqualToString:@"tel:"]) {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Alert" message:@"Phone number not available" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    } else {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:phoneStr]];
    }
}

- (IBAction)cancelEdit:(id)sender {
    [self resetView];
}

- (IBAction)phoneButton:(id)sender {
    
    //NSLog(@"%@", phoneItem);
    //NSString *cleanedPhone=[phoneItem stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([memberItem1 isEqualToString:@"YES"]) {
        if ([phoneItem isEqualToString:@"none"]) {
            if ([phoneItem1 isEqualToString:@"none"]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone not available" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
                CGRect myImageRect = CGRectMake(0, 0, 320, 548);
                [actionSht showFromRect:myImageRect inView:self.view animated:YES];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Mobile",nil];
                CGRect myImageRect = CGRectMake(0, 0, 320, 548);
                [actionSht showFromRect:myImageRect inView:self.view animated:YES];
            }
        } else {
            if ([phoneItem1 isEqualToString:@"none"]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",nil];
                CGRect myImageRect = CGRectMake(0, 0, 320, 548);
                [actionSht showFromRect:myImageRect inView:self.view animated:YES];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",@"Call Mobile",nil];
                CGRect myImageRect = CGRectMake(0, 0, 320, 548);
                [actionSht showFromRect:myImageRect inView:self.view animated:YES];
            }
        }
    } else if ([memberItem1 isEqualToString:@"NO"]) {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Sorry" message:@"Member Only" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    }
    

}
@end
