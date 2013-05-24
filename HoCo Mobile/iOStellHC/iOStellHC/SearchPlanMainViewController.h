//
//  SearchPlanMainViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/17/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPlanMainViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)psButton:(id)sender;
- (IBAction)phButton:(id)sender;
- (IBAction)sdpButton:(id)sender;
- (IBAction)sipButton:(id)sender;
- (IBAction)wpButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *popupContainer;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) IBOutlet UITextView *popupTextView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closePopup:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;

- (IBAction)startButton:(id)sender;
@end
