//
//  AgencyViewController.m
//  HCdigCom
//
//  Created by Yongyuth Phasukyued on 12/21/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import "AgencyViewController.h"
#import "MasterViewController.h"

@interface AgencyViewController () {
    NSMutableArray *json;
}

@end

@implementation AgencyViewController

@synthesize departmentItem;

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
    
    NSString *str1 = @"http://data.howardcountymd.gov/iOSkeyContact/getAgency.asp";
    NSString *str2 = [NSString stringWithFormat:@"%@?department=%@", str1,departmentItem];
    NSURL *url = [NSURL URLWithString:str2];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self getData:data];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.agencyTableView.delegate = self;
    self.agencyTableView.dataSource = self;
    
    self.navigationItem.title = @"Key Agency";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [self start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.textLabel.text = [info objectForKey:@"Agency"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [json objectAtIndex:indexPath.row];
    MasterViewController *masterVC = [[MasterViewController alloc]init];
    masterVC.agencyItem = [info objectForKey:@"Agency"];
    masterVC.searchItem = @"agency";
    [[self navigationController]pushViewController:masterVC animated:YES];
}
@end
