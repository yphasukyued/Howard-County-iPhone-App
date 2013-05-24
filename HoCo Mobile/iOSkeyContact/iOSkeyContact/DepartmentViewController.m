//
//  DepartmentViewController.m
//  HCdigCom
//
//  Created by Yongyuth Phasukyued on 1/3/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "DepartmentViewController.h"
#import "MasterViewController.h"
#import "AgencyViewController.h"

@interface DepartmentViewController (){
    NSMutableArray *json;
}

@end

@implementation DepartmentViewController

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
    
    NSURL *url = [NSURL URLWithString:@"http://data.howardcountymd.gov/iOSkeyContact/getDepartment.asp"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self getData:data];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.departmentTableView.delegate = self;
    self.departmentTableView.dataSource = self;
    
    self.navigationItem.title = @"Key Department";
    
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
    
    cell.textLabel.text = [info objectForKey:@"Department"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *info = [json objectAtIndex:indexPath.row];
    departmentItem = [info objectForKey:@"Department"];
    
    if ([departmentItem isEqualToString:@"Other"]) {
        AgencyViewController *agencyVC = [[AgencyViewController alloc]init];
        agencyVC.departmentItem = [info objectForKey:@"Department"];
        [[self navigationController]pushViewController:agencyVC animated:YES];
    } else {
        MasterViewController *masterVC = [[MasterViewController alloc]init];
        masterVC.agencyItem = [info objectForKey:@"Department"];
        masterVC.searchItem = @"department";
        [[self navigationController]pushViewController:masterVC animated:YES];
    }
    
}
@end
