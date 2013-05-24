//
//  GeodeticMainViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/17/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeodeticMainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

- (IBAction)startButton:(id)sender;
@end
