//
//  DepartmentViewController.m
//  HCdigCom
//
//  Created by Yongyuth Phasukyued on 1/3/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "DepartmentViewController.h"
#import "ContactViewController.h"

@interface DepartmentViewController (){
    NSMutableArray *json;
    NSTimer *timer;
    NSTimer *timer1;
    NSMutableArray *json1;
    NSURLConnection *postConnection;
    NSString *newtext;
    
}

@end

@implementation DepartmentViewController

@synthesize scrollLabel,sections;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) getData:(NSData *) data
{
    NSError *error;
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    self.sections = [[NSMutableDictionary alloc] init];
    
    BOOL found;
    
    for (int i = 0; i < [json count]; i++) {
        NSDictionary *info = [json objectAtIndex:i];
        
        NSString *c = [[info objectForKey:@"Department"] substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    // Loop again and sort the books into their respective keys
    for (int i = 0; i < [json count]; i++)
    {
        NSDictionary *info = [json objectAtIndex:i];
        [[self.sections objectForKey:[[info objectForKey:@"Department"] substringToIndex:1]] addObject:info];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Department" ascending:YES]]];
    }
}

-(void) start
{
    NSURL *url = [NSURL URLWithString:@"http://data.howardcountymd.gov/iOScontact/getDepartment.asp"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self getData:data];
}

-(void)viewDidAppear:(BOOL)animated {
    [self getMessages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.departmentTableView.delegate = self;
    self.departmentTableView.dataSource = self;
    
    self.navigationItem.title = @"Department";
    
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return json.count;
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.sections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    NSDictionary *info = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    //NSDictionary *info = [json objectAtIndex:indexPath.row];
    cell.textLabel.text = [info objectForKey:@"Department"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    //NSDictionary *info = [json objectAtIndex:indexPath.row];
    ContactViewController *contactVC = [[ContactViewController alloc]init];
    contactVC.agencyItem = [info objectForKey:@"Department"];
    [[self navigationController]pushViewController:contactVC animated:YES];
}
@end
