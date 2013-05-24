//
//  GeodeticDetailViewController.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/20/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "GeodeticDetailViewController.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

@interface GeodeticDetailViewController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation GeodeticDetailViewController

@synthesize fnumberItem,searchTypeItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    // set up main scroll view
    imageScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
    [imageScrollView setBackgroundColor:[UIColor blackColor]];
    [imageScrollView setDelegate:self];
    [imageScrollView setBouncesZoom:YES];
    [[self view] addSubview:imageScrollView];
    
    NSString *cleanStr =[fnumberItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    if ([searchTypeItem isEqualToString:@"GeodeticBenchmarks"] || [searchTypeItem isEqualToString:@"Bench Mark"]) {
        httpSource = [NSString stringWithFormat:@"http://data.howardcountymd.gov/Documents/GeodeticControl/BM/%@.png", cleanStr];
    } else if ([searchTypeItem isEqualToString:@"GeodeticStations"] || [searchTypeItem isEqualToString:@"Full Station"]) {
        httpSource = [NSString stringWithFormat:@"http://data.howardcountymd.gov/Documents/GeodeticControl/Sta/%@.png", cleanStr];
    }
    
    NSURL *fullUrl = [NSURL URLWithString:httpSource];
    NSData *imageData = [NSData dataWithContentsOfURL:fullUrl];

    // add touch-sensitive image view to the scroll view
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    
    [imageView setTag:ZOOM_VIEW_TAG];
    [imageView setUserInteractionEnabled:YES];
    [imageScrollView setContentSize:[imageView frame].size];
    [imageScrollView addSubview:imageView];
    
    // add gesture recognizers to the image view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    [imageView addGestureRecognizer:singleTap];
    [imageView addGestureRecognizer:doubleTap];
    [imageView addGestureRecognizer:twoFingerTap];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
    [imageScrollView setMinimumZoomScale:minimumScale];
    [imageScrollView setZoomScale:minimumScale];
}


#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([searchTypeItem isEqualToString:@"GeodeticBenchmarks"] || [searchTypeItem isEqualToString:@"Bench Mark"]) {
        self.navigationItem.title = @"Geodetic Benchmarks";
    } else if ([searchTypeItem isEqualToString:@"GeodeticStations"] || [searchTypeItem isEqualToString:@"Full Station"]) {
        self.navigationItem.title = @"Geodetic Stations";
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(sendMail)];
    
    //UIBarButtonItem *emailButton = [[UIBarButtonItem alloc]initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(sendMail)];
    [self.navigationItem setRightBarButtonItem:emailButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMail {
    
    NSString *cleanStr =[fnumberItem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    if ([searchTypeItem isEqualToString:@"GeodeticBenchmarks"] || [searchTypeItem isEqualToString:@"Bench Mark"]) {
        httpSource = [NSString stringWithFormat:@"<A href=http://data.howardcountymd.gov/Documents/GeodeticControl/BM/%@.png>Geodetic Benchmark No. %@</A>", cleanStr, fnumberItem];
    } else if ([searchTypeItem isEqualToString:@"GeodeticStations"] || [searchTypeItem isEqualToString:@"Full Station"]) {
        httpSource = [NSString stringWithFormat:@"<A href=http://data.howardcountymd.gov/Documents/GeodeticControl/Sta/%@.png>Geodetic Station No. %@</A>", cleanStr, fnumberItem];
    }
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        [mailController setMailComposeDelegate:self];
        mailController.navigationBar.tintColor = [UIColor blackColor];
        NSString *email1 = @"";
        NSArray *emailArray = [[NSArray alloc]initWithObjects:email1, nil];
        NSString *message = [NSString stringWithFormat:@"<p>For more information click below link:</p>%@", httpSource];
        [mailController setMessageBody:message isHTML:YES];
        [mailController setToRecipients:emailArray];
        [mailController setSubject:@"Geodetic Survey Control"];
        [self presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        CustomAlertView *alertViewer = [[CustomAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alertViewer show];
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    CustomAlertView *alertViewer;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email Cancel" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
        case MFMailComposeResultSaved:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email Saved" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
        case MFMailComposeResultSent:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email Sent" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
        case MFMailComposeResultFailed:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email Failed" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
        default:
            alertViewer = [[CustomAlertView alloc] initWithTitle:nil message:@"Email not Sent" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertViewer show];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
