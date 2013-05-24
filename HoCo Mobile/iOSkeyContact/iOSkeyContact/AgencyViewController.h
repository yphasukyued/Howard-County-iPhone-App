//
//  AgencyViewController.h
//  HCdigCom
//
//  Created by Yongyuth Phasukyued on 12/21/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgencyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id departmentItem;
@property (weak, nonatomic) IBOutlet UITableView *agencyTableView;

@end
