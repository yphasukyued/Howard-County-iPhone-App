#import "MasterViewController.h"
#import "ContactViewController.h"
#import "NSData+Base64.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController () {
    NSMutableArray *json;
    NSMutableArray *totalStrings;
    NSMutableArray *filteredStrings;
    UIImage *newImage;
}
@end

@implementation MasterViewController

@synthesize agencyItem,searchItem,myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self start];
    [myTableView reloadData];
}

-(void) getData:(NSData *) data {
    
    NSError *error;
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
}

-(void) start {
    
    if ([searchItem isEqualToString:@"department"]) {
        NSString *str1 = @"http://data.howardcountymd.gov/iOSkeyContact/getListByDepartment.asp";
        NSString *str2 =[agencyItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *str3 = [NSString stringWithFormat:@"%@?department=%@", str1, str2];
        NSURL *url = [NSURL URLWithString:str3];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
    } else if ([searchItem isEqualToString:@"agency"]) {
        NSString *str1 = @"http://data.howardcountymd.gov/iOSkeyContact/getListByAgency.asp";
        NSString *str2 =[agencyItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *str3 = [NSString stringWithFormat:@"%@?agency=%@", str1, str2];
        NSURL *url = [NSURL URLWithString:str3];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self getData:data];
    }

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@", agencyItem];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor]; //you can customize the tint color
    
    //tell refreshControl where its refreshing will be handled
    [refreshControl addTarget:self action:@selector(refreshing:) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:refreshControl];
    [self start];
}

-(void)refreshing:(UIRefreshControl*)refreshControl{
    
    //refresh code here (reload table data etc.)
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    NSDictionary *info = [json objectAtIndex:indexPath.row];
    
    NSString *str1 = [info objectForKey:@"FirstName"];
    NSString *str2 = [info objectForKey:@"LastName"];
    
    
    NSString *dataString = [info objectForKey: @"Image_String"];
    
    if ([dataString isEqualToString:@"none"]) {
        newImage = [UIImage imageNamed:@"portrait.jpeg"];
    } else {
        NSString *cleanedStr=[dataString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSData *thumbImageData = [NSData dataFromBase64String:cleanedStr];
        newImage = [UIImage imageWithData:thumbImageData];

    }
    
    CGSize itemSize = CGSizeMake(45, 60); // give any size you want to give
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [newImage drawInRect:imageRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //cell.imageView.layer.cornerRadius = 5.0;
    //cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.imageView.layer.borderWidth = 3;
    cell.imageView.layer.shadowColor=[UIColor grayColor].CGColor;
    cell.imageView.layer.shadowOffset=CGSizeMake(5, 5);
    cell.imageView.layer.shadowOpacity=1.0;
    cell.imageView.image = newImage;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", str1,str2];
    cell.detailTextLabel.text = [info objectForKey:@"JobTitle"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactViewController *contactVC = [[ContactViewController alloc]init];
    
    NSDictionary *info = [json objectAtIndex:indexPath.row];
    
    contactVC.idItem = [info objectForKey:@"ID"];
    NSString *str1 = [info objectForKey:@"FirstName"];
    NSString *str2 = [info objectForKey:@"LastName"];
    contactVC.fullNameItem = [NSString stringWithFormat:@"%@ %@", str1,str2];
    contactVC.jobTitleItem = [info objectForKey:@"JobTitle"];
    
    if ([searchItem isEqualToString:@"department"]) {
        contactVC.agencyItem = [info objectForKey:@"Department"];
    } else if ([searchItem isEqualToString:@"agency"]) {
        contactVC.agencyItem = [info objectForKey:@"Agency"];
    }
    
    contactVC.homePhoneItem = [info objectForKey:@"HomePhone"];
    contactVC.businessPhoneItem = [info objectForKey:@"BusinessPhone"];
    contactVC.mobilePhoneItem = [info objectForKey:@"MobilePhone"];
    contactVC.email1Item = [info objectForKey:@"Email1"];
    contactVC.email2Item = [info objectForKey:@"Email2"];
    contactVC.biographyItem = [info objectForKey:@"Biography"];
    contactVC.imageStringItem = [info objectForKey:@"Image_String"];
    
    [[self navigationController]pushViewController:contactVC animated:YES];
}

@end
