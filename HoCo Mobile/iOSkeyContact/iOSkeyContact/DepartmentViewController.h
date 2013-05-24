//
//  DepartmentViewController.h
//  HCdigCom
//
//  Created by Yongyuth Phasukyued on 1/3/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id departmentItem;
@property (strong, nonatomic) IBOutlet UITableView *departmentTableView;

@end
