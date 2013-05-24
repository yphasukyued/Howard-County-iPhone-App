//
//  ContactViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 3/17/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController () {
    NSMutableArray *json;
    NSString *bPhone;
    NSString *bEmail;
    NSString *bAddress;
    NSString *bCityStateZip;
    UIActionSheet *actionSht;
    CustomAlertView *alertViewer;
    NSTimer *timer;
    NSTimer *timer1;
    NSMutableArray *json1;
    NSURLConnection *postConnection;
    NSString *newtext;
}

@end

@implementation ContactViewController

@synthesize scrollLabel,myTableView,agencyItem,coords;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) getData:(NSData *) data {
    
    NSError *error;
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
}

-(void) start
{
    NSString *str1 = @"http://data.howardcountymd.gov/iOScontact/getListByDepartment.asp";
    NSString *str2 =[agencyItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *str3 = [NSString stringWithFormat:@"%@?department=%@", str1, str2];
    NSURL *url = [NSURL URLWithString:str3];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self getData:data];
}

-(void)viewDidAppear:(BOOL)animated {
    [self getMessages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@", agencyItem];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    
    [self start];
}

- (void)getMessages {
    NSString *str;
    
    str = @"http://data.howardcountymd.gov/iOScontact/getMessages.asp";
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    json1 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i = 0; i < [json1 count]; i++) {
        NSDictionary *info = [json1 objectAtIndex:i];
        newtext = [info objectForKey:@"Messages"];
    }
    
    scrollLabel.text = newtext;
    CGRect bounds = scrollLabel.bounds;
    bounds.size = [newtext sizeWithFont:scrollLabel.font];
    scrollLabel.bounds = bounds;
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(getMessages) userInfo:nil repeats:YES];
}

- (void)time:(NSTimer *)theTimer {
    scrollLabel.center = CGPointMake(scrollLabel.center.x-2, scrollLabel.center.y);
    if (scrollLabel.center.x < -(scrollLabel.bounds.size.width/2)) {
        scrollLabel.center = CGPointMake(320 + (scrollLabel.bounds.size.width/2), scrollLabel.center.y);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return json.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *info = [json objectAtIndex:indexPath.row];
    
    bAddress = [info objectForKey:@"Address"];
    bCityStateZip = [info objectForKey:@"CityStateZip"];
    NSString *addr = [NSString stringWithFormat:@"%@ %@", bAddress,bCityStateZip];
    NSString *cleanedAddr =[addr stringByReplacingOccurrencesOfString:@"none none" withString:@""];
    
    NSString *email = [info objectForKey:@"Email"];
    NSString *cleanedEmail =[email stringByReplacingOccurrencesOfString:@"none" withString:@""];
    
    NSString *title = [info objectForKey:@"Title"];
    NSString *cleanedTitle=[title stringByReplacingOccurrencesOfString:@"none" withString:@""];
    NSString *phone = [info objectForKey:@"Phone"];
    NSString *cleanedPhone=[phone stringByReplacingOccurrencesOfString:@"none" withString:@""];
    if ([title isEqualToString:@"none"]) {
        if ([phone isEqualToString:@"none"]) {
            if ([cleanedAddr isEqualToString:@""]) {
                if ([email isEqualToString:@"none"]) {
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                } else { //email
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", cleanedEmail];
                    cell.detailTextLabel.numberOfLines=1;
                }
            } else { //address
                if ([email isEqualToString:@"none"]) {
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", cleanedAddr];
                    cell.detailTextLabel.numberOfLines=1;
                } else { //email
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", cleanedAddr,cleanedEmail];
                    cell.detailTextLabel.numberOfLines=2;
                }
            }
        } else { //phone
            if ([cleanedAddr isEqualToString:@""]) {
                if ([email isEqualToString:@"none"]) {
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", cleanedPhone];
                    cell.detailTextLabel.numberOfLines=1;
                } else { //email
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", cleanedPhone,cleanedEmail];
                    cell.detailTextLabel.numberOfLines=2;
                }
            } else { //address
                if ([email isEqualToString:@"none"]) {
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", cleanedPhone,cleanedAddr];
                    cell.detailTextLabel.numberOfLines=2;
                } else { //email
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", cleanedAddr,cleanedPhone,cleanedEmail];
                    cell.detailTextLabel.numberOfLines=2;
                }
            }
        }
    } else { //title
        if ([phone isEqualToString:@"none"]) {
            if ([cleanedAddr isEqualToString:@""]) {
                if ([email isEqualToString:@"none"]) {
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", cleanedTitle];
                    cell.detailTextLabel.numberOfLines=1;
                } else { //email
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", cleanedTitle,cleanedEmail];
                    cell.detailTextLabel.numberOfLines=2;
                }
            } else { //address
                if ([email isEqualToString:@"none"]) {
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", cleanedTitle,cleanedAddr];
                    cell.detailTextLabel.numberOfLines=2;
                } else { //email
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", cleanedTitle,cleanedAddr,cleanedEmail];
                    cell.detailTextLabel.numberOfLines=3;
                }
            }
        } else { //phone
            if ([cleanedAddr isEqualToString:@""]) {
                if ([email isEqualToString:@"none"]) {
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", cleanedTitle,cleanedPhone];
                    cell.detailTextLabel.numberOfLines=2;
                } else { //email
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", cleanedTitle,cleanedPhone,cleanedEmail];
                    cell.detailTextLabel.numberOfLines=3;
                }
            } else { //address
                if ([email isEqualToString:@"none"]) {
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", cleanedTitle,cleanedPhone,cleanedAddr];
                    cell.detailTextLabel.numberOfLines=3;
                } else { //email
                    cell.textLabel.text = [info objectForKey:@"Agency"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", cleanedTitle,cleanedAddr,cleanedPhone,cleanedEmail];
                    cell.detailTextLabel.numberOfLines=4;
                }
            }
        }
    }


    
    return cell;
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{

    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email Cancel" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
        case MFMailComposeResultSaved:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email Saved" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
        case MFMailComposeResultSent:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email Sent" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
        case MFMailComposeResultFailed:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email Failed" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
        default:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email not Sent" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
    }

    [self dismissViewControllerAnimated:YES completion:^{
        timer1 = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(getMessages) userInfo:nil repeats:NO];
    }];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Call Office"]) {
        [self getCall:(NSString *)bPhone];
    } else if ([buttonTitle isEqualToString:@"Email"]) {
        [self openEmail:(NSString *)bEmail];
    } else if ([buttonTitle isEqualToString:@"Map and Direction"]) {
        [self getDirection:(NSString *)bAddress];
    }
    
    [self getMessages];
}

-(void)getCall:(NSString *)phoneNum {
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phoneNum];
    if ([phoneStr isEqualToString:@"tel:"]) {
        alertViewer = [[CustomAlertView alloc] initWithTitle:@"Alert" message:@"Phone number not available" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertViewer show];
    } else {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:phoneStr]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [json objectAtIndex:indexPath.row];
    
    bPhone = [info objectForKey:@"Phone"];
    bEmail = [info objectForKey:@"Email"];
    bAddress = [info objectForKey:@"Address"];
    bCityStateZip = [info objectForKey:@"CityStateZip"];
    
    if ([bPhone isEqualToString:@"none"]) {
        if ([bEmail isEqualToString:@"none"]) {
            if ([bAddress isEqualToString:@"none"]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Phone,Email and Location not available" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Office Hours: Mon-Fri 8:00 AM-5:00 PM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Map and Direction",nil];
            }
        } else {
            if ([bAddress isEqualToString:@"none"]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Office Hours: Mon-Fri 8:00 AM-5:00 PM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",nil];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Office Hours: Mon-Fri 8:00 AM-5:00 PM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email,"@"Map and Direction",nil];
            }
        }
    } else {
        if ([bEmail isEqualToString:@"none"]) {
            if ([bAddress isEqualToString:@"none"]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Office Hours: Mon-Fri 8:00 AM-5:00 PM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",nil];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Office Hours: Mon-Fri 8:00 AM-5:00 PM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",@"Map and Direction",nil];
            }
        } else {
            if ([bAddress isEqualToString:@"none"]) {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Office Hours: Mon-Fri 8:00 AM-5:00 PM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",@"Email",nil];
            } else {
                actionSht = [[UIActionSheet alloc]initWithTitle:@"Office Hours: Mon-Fri 8:00 AM-5:00 PM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Office",@"Email",@"Map and Direction",nil];
            }
        }
    }
    
    CGRect myImageRect = CGRectMake(0, 0, 320, 548);
    //[actionSht showFromToolbar:(UIToolbar *)myToolbar];
    [actionSht showFromRect:myImageRect inView:self.view animated:YES];
}

- (void)openEmail:(NSString *)emailAddr {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    mailController.navigationBar.tintColor = [UIColor blackColor];
    NSString *email1 = emailAddr;
    NSArray *emailArray = [[NSArray alloc]initWithObjects:email1, nil];
    NSString *message = @"";
    [mailController setMessageBody:message isHTML:YES];
    [mailController setToRecipients:emailArray];
    [mailController setSubject:@""];
    [self presentViewController:mailController animated:YES completion:nil];

}

- (void)getDirection:(NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *addressString = [NSString stringWithFormat:@"%@",address];
    
    [geocoder geocodeAddressString:addressString
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     if (error) {
                         NSLog(@"Geocode failed with error: %@", error);
                         return;
                     }
                     
                     if (placemarks && placemarks.count > 0)
                     {
                         CLPlacemark *placemark = placemarks[0];
                         
                         CLLocation *location = placemark.location;
                         coords = location.coordinate;
                         coords = location.coordinate;
                         
                         [self showMap];
                     }
                 }];
}

-(void)showMap
{
    NSArray *myArray = [bCityStateZip componentsSeparatedByString:@", "];
    
    NSString *city = [myArray objectAtIndex:0];
    NSString *statezip = [myArray objectAtIndex:1];
    
    NSArray *myArray1 = [statezip componentsSeparatedByString:@" "];
    
    NSString *state = [myArray1 objectAtIndex:0];
    NSString *zip = [myArray1 objectAtIndex:1];
    
    
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: bAddress,
                              (NSString *)kABPersonAddressCityKey: city,
                              (NSString *)kABPersonAddressStateKey: state,
                              (NSString *)kABPersonAddressZIPKey: zip
                              };
    
    MKPlacemark *place = [[MKPlacemark alloc]
                          initWithCoordinate:coords
                          addressDictionary:address];
    
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
    
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                              };
    
    [mapItem openInMapsWithLaunchOptions:options];
}

@end
