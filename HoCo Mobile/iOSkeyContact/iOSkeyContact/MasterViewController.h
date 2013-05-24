//
//  MasterViewController.h
//  HoCoEDA
//
//  Created by Yongyuth Phasukyued on 12/9/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id agencyItem;
@property (strong, nonatomic) id searchItem;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
