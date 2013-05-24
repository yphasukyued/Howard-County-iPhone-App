//
//  ContactViewController.m
//  iOSwineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/23/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController () {
    NSMutableArray *json;
    NSString *bEmail;
    UIActionSheet *actionSht;
    CustomAlertView *alertViewer;
}

@end

@implementation ContactViewController

@synthesize myTableView;

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

-(void) start {
    
    NSURL *url = [NSURL URLWithString:@"http://data.howardcountymd.gov/iOSwiw/getContact.asp"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self getData:data];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.navigationItem.title = @"Contact Us";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [self start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return json.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    NSDictionary *info = [json objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [info objectForKey:@"Department"];
    
    if ([[info objectForKey:@"Title"] isEqualToString:@"none"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"Contact"]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", [info objectForKey:@"Contact"],[info objectForKey:@"Title"]];
        cell.detailTextLabel.numberOfLines=2;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [json objectAtIndex:indexPath.row];
    bEmail = [info objectForKey:@"Email"];
    [self openEmail:(NSString *)bEmail];
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
    [mailController setSubject:@"Wine in the Woods"];
    [self presentViewController:mailController animated:YES completion:nil];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
