//
//  NewIssueViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 12/13/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import "NewIssueViewController.h"
#import "NSData+Base64.h"
#import "UIImage+Resize.h"
#import "MapViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ListViewController.h"


@interface NewIssueViewController () {
    
    NSMutableArray *arrayCategory;
    NSString *pickType;
    NSString *categoryItem;
    NSString *incidentItem;
    NSString *descriptionItem;
    NSString *locationItem;
    NSString *blinkStatus;
    NSTimer *timer;
    NSTimer *timer1;
    NSString *stepStatus;
    NSURL *saveImageUrl;
    NSString *imageLayout;
    NSString *title;
    NSString *subtitle;
    
}

@end

@implementation NewIssueViewController

@synthesize latItem,lngItem,categoryLabel,incidentLabel,descriptionLabel,pictureLabel,imageStep1,imageStep2,imageStep3,imageStep4,thumbnail,pickerToolBar,emailItem,pickerViewContainer,mySegment,tempTextView,locationManager,geoCoder,locationLabel,screenSaver,uploadLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"New Issue"];
    progressView.hidden=YES;
    progressView.progress = 0.0;
    CategoryPicker.hidden = NO;
    pickerToolBar.hidden = NO;
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"New Issue" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];

    [self showCategory];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    latItem = newLocation.coordinate.latitude;
    lngItem = newLocation.coordinate.longitude;

    //Geocoding Block
    [self.geoCoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         //Print the location to console
         //NSLog(@"I am currently at %@",locatedAt);
         
         //Set the label text to current location
         //[descriptionText setText:locatedAt];
         locationItem = [NSString stringWithFormat:@"%@",locatedAt];
         
     }];
    
    NSLog(@"Longitude_New: %f", newLocation.coordinate.longitude);

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [arrayCategory count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrayCategory objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([pickType isEqualToString:@"Category"]) {
        
        categoryItem = [arrayCategory objectAtIndex:[pickerView selectedRowInComponent:0]];
        categoryLabel.text = [NSString stringWithFormat:@"Category: %@",categoryItem];
        imageStep1.hidden = NO;
        incidentLabel.text = @"Step 2: Pick Incident";
        imageStep2.hidden = YES;
        incidentItem = nil;
        
    }
    else if ([pickType isEqualToString:@"Incident"]) {
        
        incidentItem = [arrayCategory objectAtIndex:[pickerView selectedRowInComponent:0]];
        incidentLabel.text = [NSString stringWithFormat:@"Incident: %@",incidentItem];
        incidentLabel.hidden = NO;
        imageStep2.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showStep:(id)sender {
    
    switch(((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            //incidentItem = nil;
            CategoryPicker.hidden = NO;
            pickerToolBar.hidden = NO;
            categoryLabel.hidden = NO;
            incidentLabel.hidden = YES;
            descriptionLabel.hidden = YES;
            locationLabel.hidden = YES;
            pictureLabel.hidden = YES;
            imageStep2.hidden = YES;
            imageStep3.hidden = YES;
            imageStep4.hidden = YES;
            thumbnail.hidden = YES;
            [self showCategory];
            break;
        case 1:
            if (!categoryItem) {
                alertViewer = [[CustomAlertView alloc] initWithTitle:@"Missed Step" message:@"Please doing step 1 first" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                [alertViewer show];
            } else {
                CategoryPicker.hidden = NO;
                pickerToolBar.hidden = NO;
                incidentLabel.hidden = NO;
                descriptionLabel.hidden = YES;
                locationLabel.hidden = YES;
                pictureLabel.hidden = YES;
                if (!incidentItem) {
                    imageStep2.hidden = YES;
                } else {
                    imageStep2.hidden = NO;
                }
                imageStep3.hidden = YES;
                imageStep4.hidden = YES;
                thumbnail.hidden = YES;
                [self showIncident];
            }
            break;
        case 2:
            pickerViewContainer.hidden = NO;
            CategoryPicker.hidden = YES;
            tempTextView.hidden = NO;
            pickerToolBar.hidden = NO;
            descriptionLabel.hidden = NO;
            locationLabel.hidden = YES;
            pictureLabel.hidden = YES;
            imageStep4.hidden = YES;
            thumbnail.hidden = YES;
            if (!descriptionItem) {
                imageStep3.hidden = YES;
            } else {
                imageStep3.hidden = NO;
            }
            [self showTempTextView];
            break;
        case 3:
            pickerViewContainer.hidden = YES;
            CategoryPicker.hidden = YES;
            pickerToolBar.hidden = YES;
            tempTextView.hidden = YES;
            pictureLabel.hidden = NO;
            locationLabel.hidden = YES;
            [self getPhoto];
            break;
        default:
            break;
    }
}

- (void)showTempTextView {
    mySegment.selectedSegmentIndex=2;
    descriptionLabel.hidden = NO;
    stepStatus = @"3";
    [tempTextView becomeFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    tempTextView.frame = CGRectMake(10, 60, 300, 56);
    pickerToolBar.frame = CGRectMake(0, 121, 320, 44);
    [UIView commitAnimations];
}

-(void)textViewDidChange:(UITextView *)textView {
    
    NSString *substring = [NSString stringWithString:tempTextView.text];
    
    //if message has text show label and update with number of characters using the NSString.length function
    if (substring.length > 0) {
        descriptionLabel.text = [NSString stringWithFormat:@"Step 3: Description (%d remaining)", 255-substring.length];
    }
    //if message has no text hide label
    if (substring.length == 0) {
        descriptionLabel.hidden = NO;
        descriptionLabel.text = @"Step 3: Enter Description";
    }
    //if message length is equal to 512 characters display alert view
    if (substring.length > 255) {
        tempTextView.textColor = [UIColor orangeColor];
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Error" message:@"Your description can't be longer than 255 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertViewer show];
    }
    //if message is less than 512 characters change font to black
    if (substring.length < 256) {
        tempTextView.textColor = [UIColor whiteColor];
    }
}

- (void)showCategory {
    
    mySegment.selectedSegmentIndex=0;
    pickerViewContainer.hidden = NO;
    categoryLabel.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CategoryPicker.frame = CGRectMake(0, 0, 320, 216);
    pickerToolBar.frame = CGRectMake(0, 216, 320, 44);
    [UIView commitAnimations];
    
    stepStatus = @"1";
    arrayCategory = nil;
    pickType = @"Category";
    NSMutableArray *json;
    
    NSString *str1 = @"http://data.howardcountymd.gov/iOStellHC/getCategory.asp";
    NSURL *url = [NSURL URLWithString:str1];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    arrayCategory = [[NSMutableArray alloc] init];
    
    for (NSDictionary *key in json) {
        NSString *myValue = [key objectForKey:@"CATEGORY"];
        [arrayCategory addObject:myValue];
    }
    [CategoryPicker reloadAllComponents];
}

- (void)showIncident {
    
    mySegment.selectedSegmentIndex=1;
    pickerViewContainer.hidden = NO;
    if (!categoryItem) {
        incidentLabel.hidden = YES;
    } else {
        incidentLabel.hidden = NO;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CategoryPicker.frame = CGRectMake(0, 30, 320, 216);
    pickerToolBar.frame = CGRectMake(0, 246, 320, 44);
    [UIView commitAnimations];
    
    stepStatus = @"2";
    arrayCategory = nil;
    pickType = @"Incident";
    
    NSMutableArray *json;
    
    NSLog(@"%@", categoryItem);
    
    if (categoryItem==nil) {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Missed Step" message:@"Please doing step 1 first" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
        [self showCategory];
    } else {
        
        NSString *cleanStr =[categoryItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *str1 = @"http://data.howardcountymd.gov/iOStellHC/getIncident.asp";
        NSString *str2 = [NSString stringWithFormat:@"%@", cleanStr];
        NSString *str3 = [NSString stringWithFormat:@"%@?category=%@", str1, str2];
        
        NSURL *url = [NSURL URLWithString:str3];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError *error;
        json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        arrayCategory = [[NSMutableArray alloc] init];
        
        for (NSDictionary *key in json) {
            NSString *myValue = [key objectForKey:@"INCIDENT_TYPE"];
            [arrayCategory addObject:myValue];
        }
        
        [CategoryPicker reloadAllComponents];
    }
}

- (void)takePhoto {
    mySegment.selectedSegmentIndex=3;
    pictureLabel.hidden = NO;
    stepStatus = @"4";
    newMedia = @"YES";
    
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = YES;
    imagePicker.Delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    [locationManager startUpdatingLocation];

}

- (void)choosePhoto {
    mySegment.selectedSegmentIndex=3;
    pictureLabel.hidden = NO;
    stepStatus = @"4";
    newMedia = @"NO";
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePicker animated:YES completion:NULL];
    [locationManager stopUpdatingLocation];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"EXIF :%@", info);
    
    // Get the asset url
    saveImageUrl = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSLog(@"myurl: %@", saveImageUrl);
    
    scaledThumbnailImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(80.0f, 60.0f) interpolationQuality:kCGInterpolationHigh];
	scaledFullsizeImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(320.0f, 240.0f) interpolationQuality:kCGInterpolationHigh];
    
    if ([newMedia isEqualToString:@"YES"]) {
        latY = latItem;
        lngX = lngItem;
        locationLabel.text = locationItem;
        locationLabel.hidden = NO;
        NSLog(@"%f",latItem);
    } else if ([newMedia isEqualToString:@"NO"]) {
        // We need to use blocks. This block will handle the ALAsset that's returned:
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            CLLocation *imageLocation = [myasset valueForProperty:ALAssetPropertyLocation];
            latY = imageLocation.coordinate.latitude;
            lngX = imageLocation.coordinate.longitude;
            // I found that the easiest way is to send the location to another method
            NSLog(@"mylat: %f",imageLocation.coordinate.latitude);
            
            CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:latY longitude:lngX];
            
            //Geocoding Block
            [self.geoCoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                
                //Get nearby address
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                
                //String to hold address
                NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                
                //Print the location to console
                //NSLog(@"I am currently at %@",locatedAt);
                
                //Set the label text to current location
                //[descriptionText setText:locatedAt];
                locationItem = [NSString stringWithFormat:@"%@",locatedAt];
                
                locationLabel.text = locationItem;
                locationLabel.hidden = NO;
            }];
        };
        
        // This block will handle errors:
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
            // Do something to handle the error
        };
        
        // Use the url to get the asset from ALAssetsLibrary,
        // the blocks that we just created will handle results
        ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:saveImageUrl resultBlock:resultblock failureBlock:failureblock];
        
        /*
        //UIImageWriteToSavedPhotosAlbum(scaledThumbnailImage, nil, nil, nil);
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image.CGImage metadata:[info objectForKey:UIImagePickerControllerMediaMetadata] completionBlock:^(NSURL *assetURL, NSError *error) {
            NSLog(@"assetURL %@", assetURL);
        }];
        */

    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [thumbnail setImage:image];
    
    pictureLabel.text = @"Take Picture: Yes";
    imageStep4.hidden = NO;
    thumbnail.hidden = NO;

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if (thumbnail.image==nil) {
        imageStep4.hidden = YES;
        thumbnail.hidden = YES;
    } else {
        imageStep4.hidden = NO;
        thumbnail.hidden = NO;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [locationManager stopUpdatingLocation];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)dismissButton:(UIBarButtonItem *)sender {
    pickerViewContainer.hidden = YES;
    pickerToolBar.hidden = YES;
    CategoryPicker.hidden = YES;
    tempTextView.hidden = YES;
    categoryLabel.hidden = NO;
    incidentLabel.hidden = NO;
    descriptionLabel.hidden = NO;
    pictureLabel.hidden = NO;
    [tempTextView resignFirstResponder];
    
    if (!categoryItem) {
        imageStep1.hidden = YES;
    } else {
        imageStep1.hidden = NO;
    }
    if (!incidentItem) {
        imageStep2.hidden = YES;
    } else {
        imageStep2.hidden = NO;
    }
    if (!locationItem) {
        locationLabel.hidden = YES;
    } else {
        locationLabel.hidden = NO;
    }
    if (!descriptionItem) {
        imageStep3.hidden = YES;
    } else {
        descriptionLabel.text = [NSString stringWithFormat:@"Description: %@", descriptionItem];
        imageStep3.hidden = NO;
    }
    if (thumbnail.image==nil) {
        imageStep4.hidden = YES;
        thumbnail.hidden = YES;
    } else {
        imageStep4.hidden = NO;
        thumbnail.hidden = NO;
    }
}

- (IBAction)nextButton:(UIBarButtonItem *)sender {
    imageStep4.hidden = YES;
    thumbnail.hidden = YES;
    if ([stepStatus isEqualToString:@"1"]) {
        pickerToolBar.hidden = NO;
        CategoryPicker.hidden = NO;
        [self showIncident];
    } else if ([stepStatus isEqualToString:@"2"]) {
        pickerToolBar.hidden = NO;
        tempTextView.hidden = NO;
        CategoryPicker.hidden = YES;
        if (!descriptionItem) {
            imageStep3.hidden = YES;
        } else {
            imageStep3.hidden = NO;
        }
        [self showTempTextView];
    } else if ([stepStatus isEqualToString:@"3"]) {
        if ([tempTextView.text isEqualToString:@""]) {
            alertViewer = [[CustomAlertView alloc] initWithTitle:@"Description" message:@"Please enter description123!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            [self showTempTextView];
        } else {
            descriptionItem = tempTextView.text;
            descriptionLabel.text = [NSString stringWithFormat:@"Description: %@",tempTextView.text];
            imageStep3.hidden = NO;
            pictureLabel.hidden = NO;
            pickerToolBar.hidden = YES;
            tempTextView.hidden = YES;
            CategoryPicker.hidden = YES;
            [tempTextView resignFirstResponder];
            if (!scaledThumbnailImage) {
                [self getPhoto];
            } else {
                imageStep4.hidden = NO;
                thumbnail.hidden = NO;
            }
        
        }
    }
}

- (void) resetFORM {
    categoryLabel.text = @"Step 1: Pick Category: ";
    incidentLabel.text = @"Step 2: Pick Incident";
    descriptionLabel.text = @"Step 3: Enter Description";
    descriptionItem = nil;
    pictureLabel.text = @"Step 4: Take Picture";
    tempTextView.text = @"";
    imageStep1.hidden = YES;
    imageStep2.hidden = YES;
    imageStep3.hidden = YES;
    imageStep4.hidden = YES;
    thumbnail.image=nil;
    thumbnail.hidden = YES;
    categoryItem = nil;
    incidentItem = nil;
    locationLabel = nil;
    locationLabel.hidden = YES;
    scaledThumbnailImage = nil;
    alertViewer = [[CustomAlertView alloc] initWithTitle:@"You are done!" message:[NSString stringWithFormat:@"Confirmation email has been sent to %@. To review issue location, touch on 'View Map'. ", emailItem] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:@"View Map",@"Add New Issue",nil];
    [alertViewer setDelegate:self];
    [alertViewer show];
    
    
}

- (void)getMap {
    MapViewController *mapVC = [[MapViewController alloc]init];
    mapVC.titleMap = title;
    mapVC.address1Map = subtitle;
    mapVC.latItem = latY;
    mapVC.lngItem = lngX;
    mapVC.displayAll = NO;
    mapVC.mapEdit = YES;
    mapVC.randomItem = randomString;
    [[self navigationController]pushViewController:mapVC animated:YES];
    [locationManager stopUpdatingLocation];
}

- (IBAction)uploadIncident:(id)sender {
    if (!categoryItem) {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Please pick category!" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Pick Category", nil];
        [alertViewer setDelegate:self];
        [alertViewer show];
    } else {
        if (!incidentItem) {
            alertViewer = [[CustomAlertView alloc] initWithTitle:@"Please pick incident!" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Pick Incident", nil];
            [alertViewer setDelegate:self];
            [alertViewer show];
        } else {
            if (!descriptionItem) {
                alertViewer = [[CustomAlertView alloc] initWithTitle:@"Please enter description!" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Enter Description", nil];
                [alertViewer setDelegate:self];
                [alertViewer show];
            } else {
                if (!scaledThumbnailImage) {
                    alertViewer = [[CustomAlertView alloc] initWithTitle:@"Please get a picture!" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Get a Picture", nil];
                    [alertViewer setDelegate:self];
                    [alertViewer show];
                } else {
                    if (!latY) {
                        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Location not available!" message:@"No location information on this picture, please choose another picture." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                        [alertViewer setDelegate:self];
                        [alertViewer show];
                    } else {
                        [locationManager stopUpdatingLocation];
                        [self savePhoto];
                    }
                }
            }
        }
    }
}

-(void)alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertViewer buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Pick Category"]) {
        incidentItem = nil;
        CategoryPicker.hidden = NO;
        pickerToolBar.hidden = NO;
        categoryLabel.hidden = NO;
        incidentLabel.hidden = YES;
        descriptionLabel.hidden = YES;
        pictureLabel.hidden = YES;
        imageStep2.hidden = YES;
        imageStep3.hidden = YES;
        imageStep4.hidden = YES;
        thumbnail.hidden = YES;
        [self showCategory];
    } else if ([buttonTitle isEqualToString:@"Pick Incident"]) {
        if (!categoryItem) {
            alertViewer = [[CustomAlertView alloc] initWithTitle:@"Missed Step" message:@"Please doing step 1 first" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
        } else {
            CategoryPicker.hidden = NO;
            pickerToolBar.hidden = NO;
            incidentLabel.hidden = NO;
            descriptionLabel.hidden = YES;
            pictureLabel.hidden = YES;
            if (!incidentItem) {
                imageStep2.hidden = YES;
            } else {
                imageStep2.hidden = NO;
            }
            imageStep3.hidden = YES;
            imageStep4.hidden = YES;
            thumbnail.hidden = YES;
            [self showIncident];
        }
    } else if ([buttonTitle isEqualToString:@"Enter Description"]) {
        pickerViewContainer.hidden = NO;
        CategoryPicker.hidden = YES;
        tempTextView.hidden = NO;
        pickerToolBar.hidden = NO;
        descriptionLabel.hidden = NO;
        pictureLabel.hidden = YES;
        imageStep4.hidden = YES;
        thumbnail.hidden = YES;
        if (!descriptionItem) {
            imageStep3.hidden = YES;
        } else {
            imageStep3.hidden = NO;
        }
        [self showTempTextView];
    } else if ([buttonTitle isEqualToString:@"Get a Picture"]) {
        pickerViewContainer.hidden = YES;
        CategoryPicker.hidden = YES;
        pickerToolBar.hidden = YES;
        tempTextView.hidden = YES;
        pictureLabel.hidden = NO;
        [self getPhoto];
    } else if ([buttonTitle isEqualToString:@"View Map"]) {
        [self getMap];
    } else if ([buttonTitle isEqualToString:@"Add New Issue"]) {
        CategoryPicker.hidden = NO;
        pickerToolBar.hidden = NO;
        categoryLabel.hidden = NO;
        incidentLabel.hidden = YES;
        descriptionLabel.hidden = YES;
        locationLabel.hidden = YES;
        pictureLabel.hidden = YES;
        imageStep2.hidden = YES;
        imageStep3.hidden = YES;
        imageStep4.hidden = YES;
        thumbnail.hidden = YES;
        [self showCategory];
    }
}

-(void)savePhoto {
    
    NSData *thumbnailImageData = UIImageJPEGRepresentation(scaledThumbnailImage,0.3);
    NSData *fullsizeImageData = UIImageJPEGRepresentation(scaledFullsizeImage,0.3);
    
    NSString *uncleanThumbnailString = [thumbnailImageData base64EncodedString];
    NSString *uncleanFullsizeString = [fullsizeImageData base64EncodedString];
    
    //NSArray *listItems = [cleanedString componentsSeparatedByString:@"\n"];
    
    NSString *cleanedThumbnailString=[uncleanThumbnailString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *thumbnailString=[cleanedThumbnailString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *cleanedFullsizeString=[uncleanFullsizeString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    fullsizeString = [cleanedFullsizeString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSData *data = [NSData dataFromBase64String:mystring];
    
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < 20; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    NSLog(@"random %@",s);
    
    NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    randomString = [NSString stringWithFormat:@"%@%2d:%2d:%02d:%02d:%02d:%2d", s,year, month, day, hour, minute, second];
    
    int fullsizeLength=[fullsizeString length];
    if (fullsizeLength > 34001) {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Image Error" message:[NSString stringWithFormat:@"Image is too big(%i)", fullsizeLength] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    }
    else if (fullsizeLength>=30600 && fullsizeLength <= 34000) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, 3400)];
        fullsizeString3 = [fullsizeString substringWithRange:NSMakeRange(6800, 3400)];
        fullsizeString4 = [fullsizeString substringWithRange:NSMakeRange(10200, 3400)];
        fullsizeString5 = [fullsizeString substringWithRange:NSMakeRange(13600, 3400)];
        fullsizeString6 = [fullsizeString substringWithRange:NSMakeRange(17000, 3400)];
        fullsizeString7 = [fullsizeString substringWithRange:NSMakeRange(20400, 3400)];
        fullsizeString8 = [fullsizeString substringWithRange:NSMakeRange(23800, 3400)];
        fullsizeString9 = [fullsizeString substringWithRange:NSMakeRange(27200, 3400)];
        fullsizeString10 = [fullsizeString substringWithRange:NSMakeRange(30600, fullsizeLength-30600)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
        uploadLabel.hidden = NO;
        screenSaver.hidden = NO;
        progressView.hidden=NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
        */
    }
    else if (fullsizeLength>=27200 && fullsizeLength <= 30600) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, 3400)];
        fullsizeString3 = [fullsizeString substringWithRange:NSMakeRange(6800, 3400)];
        fullsizeString4 = [fullsizeString substringWithRange:NSMakeRange(10200, 3400)];
        fullsizeString5 = [fullsizeString substringWithRange:NSMakeRange(13600, 3400)];
        fullsizeString6 = [fullsizeString substringWithRange:NSMakeRange(17000, 3400)];
        fullsizeString7 = [fullsizeString substringWithRange:NSMakeRange(20400, 3400)];
        fullsizeString8 = [fullsizeString substringWithRange:NSMakeRange(23800, 3400)];
        fullsizeString9 = [fullsizeString substringWithRange:NSMakeRange(27200, fullsizeLength-27200)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    else if (fullsizeLength>=23800 && fullsizeLength <= 27200) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, 3400)];
        fullsizeString3 = [fullsizeString substringWithRange:NSMakeRange(6800, 3400)];
        fullsizeString4 = [fullsizeString substringWithRange:NSMakeRange(10200, 3400)];
        fullsizeString5 = [fullsizeString substringWithRange:NSMakeRange(13600, 3400)];
        fullsizeString6 = [fullsizeString substringWithRange:NSMakeRange(17000, 3400)];
        fullsizeString7 = [fullsizeString substringWithRange:NSMakeRange(20400, 3400)];
        fullsizeString8 = [fullsizeString substringWithRange:NSMakeRange(23800, fullsizeLength-23800)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    else if (fullsizeLength>=20400 && fullsizeLength <= 23800) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, 3400)];
        fullsizeString3 = [fullsizeString substringWithRange:NSMakeRange(6800, 3400)];
        fullsizeString4 = [fullsizeString substringWithRange:NSMakeRange(10200, 3400)];
        fullsizeString5 = [fullsizeString substringWithRange:NSMakeRange(13600, 3400)];
        fullsizeString6 = [fullsizeString substringWithRange:NSMakeRange(17000, 3400)];
        fullsizeString7 = [fullsizeString substringWithRange:NSMakeRange(20400, fullsizeLength-20400)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    else if (fullsizeLength>=17000 && fullsizeLength <= 20400) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, 3400)];
        fullsizeString3 = [fullsizeString substringWithRange:NSMakeRange(6800, 3400)];
        fullsizeString4 = [fullsizeString substringWithRange:NSMakeRange(10200, 3400)];
        fullsizeString5 = [fullsizeString substringWithRange:NSMakeRange(13600, 3400)];
        fullsizeString6 = [fullsizeString substringWithRange:NSMakeRange(17000, fullsizeLength-17000)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    else if (fullsizeLength>=13600 && fullsizeLength <= 17000) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, 3400)];
        fullsizeString3 = [fullsizeString substringWithRange:NSMakeRange(6800, 3400)];
        fullsizeString4 = [fullsizeString substringWithRange:NSMakeRange(10200, 3400)];
        fullsizeString5 = [fullsizeString substringWithRange:NSMakeRange(13600, fullsizeLength-13600)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    else if (fullsizeLength>=10201 && fullsizeLength <= 13600) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, 3400)];
        fullsizeString3 = [fullsizeString substringWithRange:NSMakeRange(6800, 3400)];
        fullsizeString4 = [fullsizeString substringWithRange:NSMakeRange(10200, fullsizeLength-10200)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    else if (fullsizeLength>=6800 && fullsizeLength <= 10200) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, 3400)];
        fullsizeString3 = [fullsizeString substringWithRange:NSMakeRange(6800, fullsizeLength-6800)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    else if (fullsizeLength>=3400 && fullsizeLength <= 6800) {
        fullsizeString1 = [fullsizeString substringWithRange:NSMakeRange(0, 3400)];
        fullsizeString2 = [fullsizeString substringWithRange:NSMakeRange(3400, fullsizeLength-3400)];
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    else if (fullsizeLength>=1 && fullsizeLength <= 3400) {
        fullsizeString1 = fullsizeString;
        [self postThumbnailImgStr:thumbnailString];
        
        /*
         uploadLabel.hidden = NO;
         screenSaver.hidden = NO;
         progressView.hidden=NO;
         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
         */
    }
    
    /*
    int thumbnailLength=[thumbnailString length];
    int fullsizeLength1=[fullsizeString1 length];
    int fullsizeLength2=[fullsizeString2 length];
    int fullsizeLength3=[fullsizeString3 length];
    int fullsizeLength4=[fullsizeString4 length];
    int fullsizeLength5=[fullsizeString5 length];
    int fullsizeLength6=[fullsizeString6 length];
    int fullsizeLength6=[fullsizeString7 length];
    int fullsizeLength6=[fullsizeString8 length];
     
     NSLog(@"%@", thumbnailString);
     NSLog(@"%@", fullsizeString);
     NSLog(@"%@", fullsizeString1);
     NSLog(@"%@", fullsizeString2);
     NSLog(@"%@", fullsizeString3);
     NSLog(@"%@", fullsizeString4);
     NSLog(@"%@", fullsizeString5);
     NSLog(@"%@", fullsizeString6);
     NSLog(@"%@", fullsizeString7);
     NSLog(@"%@", fullsizeString8);
     NSLog(@"Original: %fx%f", image.size.height,image.size.width);
     NSLog(@"Thumbnail: %fx%f", scaledThumbnailImage.size.height,scaledThumbnailImage.size.width);
     NSLog(@"Fullsize: %fx%f", scaledFullsizeImage.size.height,scaledFullsizeImage.size.width);
     NSLog(@"Fullsize Length: %i", fullsizeLength);
     NSLog(@"Fullsize Length1: %i", fullsizeLength1);
     NSLog(@"Fullsize Length2: %i", fullsizeLength2);
     NSLog(@"Fullsize Length3: %i", fullsizeLength3);
     NSLog(@"Fullsize Length4: %i", fullsizeLength4);
     NSLog(@"Fullsize Length5: %i", fullsizeLength5);
     NSLog(@"Fullsize Length6: %i", fullsizeLength6);
     NSLog(@"Fullsize Length7: %i", fullsizeLength7);
     NSLog(@"Fullsize Length8: %i", fullsizeLength8);
     NSLog(@"Thumbnail Length: %i", thumbnailLength);
     NSLog(@"Timestamp: %@", randomString);
     NSLog(@"Thumbnail Data: %@", thumbnailImageData);
     */

}

-(void) postThumbnailImgStr:(NSString*) ImgStr {
    
    if (ImgStr != nil) {
        if (scaledThumbnailImage.size.height > scaledThumbnailImage.size.width) {
            imageLayout = @"Portrait";
        } else if (scaledThumbnailImage.size.height < scaledThumbnailImage.size.width) {
            imageLayout = @"Landscape";
        }
        
        title = categoryItem;
        subtitle = incidentItem;

        NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadIncident.asp"];
        [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", ImgStr]];
        [postString appendString:[NSString stringWithFormat:@"&category=%@", categoryItem]];
        [postString appendString:[NSString stringWithFormat:@"&incident=%@", incidentItem]];
        [postString appendString:[NSString stringWithFormat:@"&startX=%f", lngX]];
        [postString appendString:[NSString stringWithFormat:@"&startY=%f", latY]];
        [postString appendString:[NSString stringWithFormat:@"&udesc=%@", descriptionItem]];
        [postString appendString:[NSString stringWithFormat:@"&uemail=%@", emailItem]];
        [postString appendString:[NSString stringWithFormat:@"&ilayout=%@", imageLayout]];
        [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
        [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
        [request setHTTPMethod:@"POST"];
        postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        
        //uploadLabel.text = @"Upload Photo 0%";
        timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr1) userInfo:nil repeats:NO];
    }
}

-(void) postFullsizeImgStr1 {
    
    [self resetFORM];
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage1.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString1]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 10%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr2) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr2 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage2.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString2]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 20%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr3) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr3 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage3.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString3]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 30%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr4) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr4 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage4.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString4]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 40%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr5) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr5 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage5.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString5]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 50%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr6) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr6 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage6.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString6]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 60%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr7) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr7 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage7.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString7]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 70%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr8) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr8 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage8.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString8]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 80%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr9) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr9 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage9.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString9]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    //uploadLabel.text = @"Upload Photo 90%";
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postFullsizeImgStr10) userInfo:nil repeats:NO];
}

-(void) postFullsizeImgStr10 {
    
    NSMutableString *postString = [NSMutableString stringWithString:@"http://data.howardcountymd.gov/iOStellHC/uploadFullsizeImage10.asp"];
    [postString appendString:[NSString stringWithFormat:@"?imgstr=%@", fullsizeString10]];
    [postString appendString:[NSString stringWithFormat:@"&timestamp=%@", randomString]];
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
}

/*
-(void)moreProgress {
    progressView.progress = progressView.progress + 0.1;
    if (progressView.progress==1.0) {
        [timer invalidate];
        progressView.hidden=YES;
        progressView.progress = 0.0;
        screenSaver.hidden = YES;
        uploadLabel.hidden = YES;
        locationLabel.hidden = YES;
        [self resetFORM];
    }
}
*/

- (void)getPhoto {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture",@"Choose from Library",nil];
    [actionSheet showFromToolbar:(UIToolbar *)myToolBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self takePhoto];
    }
    else if (buttonIndex==1) {
        [self choosePhoto];
    }
}

@end
