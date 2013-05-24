//
//  GeodeticDetailViewController.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/20/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "TapDetectingImageView.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "CustomAlertView.h"

@interface GeodeticDetailViewController : UIViewController<MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, TapDetectingImageViewDelegate> {
    SLComposeViewController *slComposeViewController;
    UIScrollView *imageScrollView;
    NSString *httpSource;
    NSString *emailMessage;
    UIImageView *imageView;
}

@property (strong, nonatomic) id fnumberItem;
@property (strong, nonatomic) id searchTypeItem;

@end
