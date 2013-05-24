//
//  DetailViewController.m
//  HoCoEDA
//
//  Created by Yongyuth Phasukyued on 12/9/12.
//  Copyright (c) 2012 Howard County. All rights reserved.
//

#import "DetailViewController.h"
#import "NSData+Base64.h"
#import "MapViewController.h"
#import "NewIssueViewController.h"
#import "Annotation.h"

@interface DetailViewController () {
    NSData *imageData;
    NSMutableArray *json;
    NSTimer *timer;
    NSTimer *timer1;
    NSMutableArray *json1;
    NSURLConnection *postConnection;
    NSString *newtext;
}

@end

@implementation DetailViewController

@synthesize idItem,latItem,lngItem,categoryItem,incidentItem,FSimageItem1,FSimageItem2,FSimageItem3,FSimageItem4,FSimageItem5,FSimageItem6,FSimageItem7,FSimageItem8,FSimageItem9,FSimageItem10,descriptionText,myToolBar,geoCoder,mapView,mapTypeSegment,locationManager,statusItem,imageView,scrollLabel,emailItem;

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 120.0f;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [self getMessages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    CLLocationCoordinate2D boundCoords[1517]={
        CLLocationCoordinate2DMake(39.2133,-76.6964),
        CLLocationCoordinate2DMake(39.2134,-76.6965),
        CLLocationCoordinate2DMake(39.2133,-76.6969),
        CLLocationCoordinate2DMake(39.2134,-76.6972),
        CLLocationCoordinate2DMake(39.2139,-76.6974),
        CLLocationCoordinate2DMake(39.2132,-76.6983),
        CLLocationCoordinate2DMake(39.2129,-76.699),
        CLLocationCoordinate2DMake(39.2129,-76.6995),
        CLLocationCoordinate2DMake(39.213,-76.7006),
        CLLocationCoordinate2DMake(39.2132,-76.7012),
        CLLocationCoordinate2DMake(39.214,-76.7024),
        CLLocationCoordinate2DMake(39.2142,-76.7034),
        CLLocationCoordinate2DMake(39.2146,-76.7044),
        CLLocationCoordinate2DMake(39.2154,-76.7053),
        CLLocationCoordinate2DMake(39.2157,-76.7054),
        CLLocationCoordinate2DMake(39.2167,-76.7056),
        CLLocationCoordinate2DMake(39.2179,-76.7061),
        CLLocationCoordinate2DMake(39.2208,-76.7062),
        CLLocationCoordinate2DMake(39.2212,-76.7066),
        CLLocationCoordinate2DMake(39.2213,-76.7083),
        CLLocationCoordinate2DMake(39.2216,-76.7095),
        CLLocationCoordinate2DMake(39.2213,-76.7104),
        CLLocationCoordinate2DMake(39.2212,-76.7111),
        CLLocationCoordinate2DMake(39.2214,-76.7122),
        CLLocationCoordinate2DMake(39.2217,-76.7132),
        CLLocationCoordinate2DMake(39.2215,-76.7133),
        CLLocationCoordinate2DMake(39.222,-76.7139),
        CLLocationCoordinate2DMake(39.2225,-76.7142),
        CLLocationCoordinate2DMake(39.2242,-76.7158),
        CLLocationCoordinate2DMake(39.2246,-76.7164),
        CLLocationCoordinate2DMake(39.2251,-76.7167),
        CLLocationCoordinate2DMake(39.2255,-76.7181),
        CLLocationCoordinate2DMake(39.2255,-76.7196),
        CLLocationCoordinate2DMake(39.2261,-76.7221),
        CLLocationCoordinate2DMake(39.2266,-76.7227),
        CLLocationCoordinate2DMake(39.2277,-76.7236),
        CLLocationCoordinate2DMake(39.2284,-76.7246),
        CLLocationCoordinate2DMake(39.2288,-76.7269),
        CLLocationCoordinate2DMake(39.2292,-76.7282),
        CLLocationCoordinate2DMake(39.2291,-76.7289),
        CLLocationCoordinate2DMake(39.2287,-76.7292),
        CLLocationCoordinate2DMake(39.2286,-76.7298),
        CLLocationCoordinate2DMake(39.2287,-76.7304),
        CLLocationCoordinate2DMake(39.2292,-76.731),
        CLLocationCoordinate2DMake(39.2297,-76.7312),
        CLLocationCoordinate2DMake(39.2304,-76.7326),
        CLLocationCoordinate2DMake(39.2307,-76.7336),
        CLLocationCoordinate2DMake(39.2307,-76.7344),
        CLLocationCoordinate2DMake(39.2306,-76.7344),
        CLLocationCoordinate2DMake(39.2308,-76.7352),
        CLLocationCoordinate2DMake(39.2309,-76.7366),
        CLLocationCoordinate2DMake(39.2315,-76.7377),
        CLLocationCoordinate2DMake(39.2315,-76.7381),
        CLLocationCoordinate2DMake(39.2322,-76.7401),
        CLLocationCoordinate2DMake(39.2336,-76.7417),
        CLLocationCoordinate2DMake(39.2352,-76.7426),
        CLLocationCoordinate2DMake(39.2365,-76.7437),
        CLLocationCoordinate2DMake(39.2382,-76.7464),
        CLLocationCoordinate2DMake(39.2404,-76.7481),
        CLLocationCoordinate2DMake(39.2408,-76.7495),
        CLLocationCoordinate2DMake(39.2413,-76.75),
        CLLocationCoordinate2DMake(39.2441,-76.7518),
        CLLocationCoordinate2DMake(39.2451,-76.753),
        CLLocationCoordinate2DMake(39.2452,-76.7533),
        CLLocationCoordinate2DMake(39.2464,-76.7551),
        CLLocationCoordinate2DMake(39.2473,-76.7567),
        CLLocationCoordinate2DMake(39.2468,-76.761),
        CLLocationCoordinate2DMake(39.2464,-76.7618),
        CLLocationCoordinate2DMake(39.2462,-76.7627),
        CLLocationCoordinate2DMake(39.2461,-76.7636),
        CLLocationCoordinate2DMake(39.2461,-76.764),
        CLLocationCoordinate2DMake(39.2469,-76.765),
        CLLocationCoordinate2DMake(39.2483,-76.7653),
        CLLocationCoordinate2DMake(39.2488,-76.7651),
        CLLocationCoordinate2DMake(39.2494,-76.7646),
        CLLocationCoordinate2DMake(39.2505,-76.7639),
        CLLocationCoordinate2DMake(39.2508,-76.7639),
        CLLocationCoordinate2DMake(39.2513,-76.7642),
        CLLocationCoordinate2DMake(39.2516,-76.7651),
        CLLocationCoordinate2DMake(39.2518,-76.7668),
        CLLocationCoordinate2DMake(39.2521,-76.7674),
        CLLocationCoordinate2DMake(39.2523,-76.7687),
        CLLocationCoordinate2DMake(39.2525,-76.7688),
        CLLocationCoordinate2DMake(39.2525,-76.769),
        CLLocationCoordinate2DMake(39.2548,-76.7715),
        CLLocationCoordinate2DMake(39.2553,-76.7725),
        CLLocationCoordinate2DMake(39.2559,-76.7733),
        CLLocationCoordinate2DMake(39.2564,-76.7752),
        CLLocationCoordinate2DMake(39.2565,-76.7767),
        CLLocationCoordinate2DMake(39.2565,-76.7785),
        CLLocationCoordinate2DMake(39.257,-76.7803),
        CLLocationCoordinate2DMake(39.2583,-76.782),
        CLLocationCoordinate2DMake(39.2593,-76.7827),
        CLLocationCoordinate2DMake(39.2602,-76.7837),
        CLLocationCoordinate2DMake(39.261,-76.7849),
        CLLocationCoordinate2DMake(39.2622,-76.7873),
        CLLocationCoordinate2DMake(39.2626,-76.7877),
        CLLocationCoordinate2DMake(39.2634,-76.7884),
        CLLocationCoordinate2DMake(39.2642,-76.7894),
        CLLocationCoordinate2DMake(39.2644,-76.79),
        CLLocationCoordinate2DMake(39.2654,-76.7923),
        CLLocationCoordinate2DMake(39.2657,-76.7936),
        CLLocationCoordinate2DMake(39.2662,-76.7942),
        CLLocationCoordinate2DMake(39.2674,-76.7946),
        CLLocationCoordinate2DMake(39.268,-76.7944),
        CLLocationCoordinate2DMake(39.2689,-76.7944),
        CLLocationCoordinate2DMake(39.2698,-76.7947),
        CLLocationCoordinate2DMake(39.2701,-76.7946),
        CLLocationCoordinate2DMake(39.2709,-76.7936),
        CLLocationCoordinate2DMake(39.2717,-76.7917),
        CLLocationCoordinate2DMake(39.2735,-76.7901),
        CLLocationCoordinate2DMake(39.2736,-76.7897),
        CLLocationCoordinate2DMake(39.2753,-76.7891),
        CLLocationCoordinate2DMake(39.2775,-76.7889),
        CLLocationCoordinate2DMake(39.2791,-76.7875),
        CLLocationCoordinate2DMake(39.2805,-76.7869),
        CLLocationCoordinate2DMake(39.2822,-76.7859),
        CLLocationCoordinate2DMake(39.2827,-76.7852),
        CLLocationCoordinate2DMake(39.2835,-76.7852),
        CLLocationCoordinate2DMake(39.2836,-76.7853),
        CLLocationCoordinate2DMake(39.2847,-76.7854),
        CLLocationCoordinate2DMake(39.2874,-76.7851),
        CLLocationCoordinate2DMake(39.2882,-76.7853),
        CLLocationCoordinate2DMake(39.2891,-76.7852),
        CLLocationCoordinate2DMake(39.2906,-76.7854),
        CLLocationCoordinate2DMake(39.2917,-76.7852),
        CLLocationCoordinate2DMake(39.2926,-76.7846),
        CLLocationCoordinate2DMake(39.2932,-76.7839),
        CLLocationCoordinate2DMake(39.2943,-76.7819),
        CLLocationCoordinate2DMake(39.2946,-76.7808),
        CLLocationCoordinate2DMake(39.2949,-76.7803),
        CLLocationCoordinate2DMake(39.2949,-76.7799),
        CLLocationCoordinate2DMake(39.2947,-76.7795),
        CLLocationCoordinate2DMake(39.2949,-76.7788),
        CLLocationCoordinate2DMake(39.295,-76.7786),
        CLLocationCoordinate2DMake(39.2956,-76.7785),
        CLLocationCoordinate2DMake(39.2968,-76.7787),
        CLLocationCoordinate2DMake(39.297,-76.7791),
        CLLocationCoordinate2DMake(39.2975,-76.7813),
        CLLocationCoordinate2DMake(39.2991,-76.7837),
        CLLocationCoordinate2DMake(39.2996,-76.7851),
        CLLocationCoordinate2DMake(39.2997,-76.7866),
        CLLocationCoordinate2DMake(39.3002,-76.7875),
        CLLocationCoordinate2DMake(39.301,-76.7883),
        CLLocationCoordinate2DMake(39.3017,-76.7884),
        CLLocationCoordinate2DMake(39.3025,-76.789),
        CLLocationCoordinate2DMake(39.3036,-76.7908),
        CLLocationCoordinate2DMake(39.3038,-76.7924),
        CLLocationCoordinate2DMake(39.3035,-76.793),
        CLLocationCoordinate2DMake(39.3032,-76.7944),
        CLLocationCoordinate2DMake(39.3034,-76.7952),
        CLLocationCoordinate2DMake(39.3037,-76.7959),
        CLLocationCoordinate2DMake(39.3048,-76.7965),
        CLLocationCoordinate2DMake(39.3058,-76.7966),
        CLLocationCoordinate2DMake(39.3067,-76.7955),
        CLLocationCoordinate2DMake(39.3068,-76.7949),
        CLLocationCoordinate2DMake(39.3068,-76.7942),
        CLLocationCoordinate2DMake(39.307,-76.7939),
        CLLocationCoordinate2DMake(39.3077,-76.7935),
        CLLocationCoordinate2DMake(39.3093,-76.7936),
        CLLocationCoordinate2DMake(39.3109,-76.7925),
        CLLocationCoordinate2DMake(39.3126,-76.793),
        CLLocationCoordinate2DMake(39.3142,-76.7946),
        CLLocationCoordinate2DMake(39.3147,-76.7956),
        CLLocationCoordinate2DMake(39.315,-76.7971),
        CLLocationCoordinate2DMake(39.3151,-76.7976),
        CLLocationCoordinate2DMake(39.3149,-76.7986),
        CLLocationCoordinate2DMake(39.315,-76.7994),
        CLLocationCoordinate2DMake(39.3167,-76.8041),
        CLLocationCoordinate2DMake(39.3163,-76.806),
        CLLocationCoordinate2DMake(39.3156,-76.8082),
        CLLocationCoordinate2DMake(39.3153,-76.8087),
        CLLocationCoordinate2DMake(39.3153,-76.81),
        CLLocationCoordinate2DMake(39.3157,-76.811),
        CLLocationCoordinate2DMake(39.3163,-76.8118),
        CLLocationCoordinate2DMake(39.3178,-76.8124),
        CLLocationCoordinate2DMake(39.318,-76.8132),
        CLLocationCoordinate2DMake(39.318,-76.814),
        CLLocationCoordinate2DMake(39.3179,-76.8145),
        CLLocationCoordinate2DMake(39.3176,-76.8149),
        CLLocationCoordinate2DMake(39.3162,-76.8155),
        CLLocationCoordinate2DMake(39.3157,-76.816),
        CLLocationCoordinate2DMake(39.3153,-76.8162),
        CLLocationCoordinate2DMake(39.3147,-76.816),
        CLLocationCoordinate2DMake(39.3146,-76.8159),
        CLLocationCoordinate2DMake(39.3136,-76.8159),
        CLLocationCoordinate2DMake(39.3133,-76.816),
        CLLocationCoordinate2DMake(39.313,-76.8166),
        CLLocationCoordinate2DMake(39.313,-76.8175),
        CLLocationCoordinate2DMake(39.3134,-76.8187),
        CLLocationCoordinate2DMake(39.3144,-76.82),
        CLLocationCoordinate2DMake(39.3178,-76.8221),
        CLLocationCoordinate2DMake(39.3188,-76.8231),
        CLLocationCoordinate2DMake(39.3191,-76.8238),
        CLLocationCoordinate2DMake(39.3193,-76.8249),
        CLLocationCoordinate2DMake(39.3191,-76.826),
        CLLocationCoordinate2DMake(39.3188,-76.8269),
        CLLocationCoordinate2DMake(39.3169,-76.8294),
        CLLocationCoordinate2DMake(39.316,-76.8301),
        CLLocationCoordinate2DMake(39.3131,-76.8314),
        CLLocationCoordinate2DMake(39.3119,-76.8327),
        CLLocationCoordinate2DMake(39.3115,-76.8337),
        CLLocationCoordinate2DMake(39.3117,-76.8351),
        CLLocationCoordinate2DMake(39.3122,-76.8357),
        CLLocationCoordinate2DMake(39.3128,-76.8357),
        CLLocationCoordinate2DMake(39.3138,-76.8354),
        CLLocationCoordinate2DMake(39.3141,-76.8355),
        CLLocationCoordinate2DMake(39.3147,-76.8351),
        CLLocationCoordinate2DMake(39.3154,-76.8351),
        CLLocationCoordinate2DMake(39.3157,-76.8353),
        CLLocationCoordinate2DMake(39.3158,-76.836),
        CLLocationCoordinate2DMake(39.3156,-76.8374),
        CLLocationCoordinate2DMake(39.3155,-76.8395),
        CLLocationCoordinate2DMake(39.3157,-76.8412),
        CLLocationCoordinate2DMake(39.316,-76.8419),
        CLLocationCoordinate2DMake(39.3168,-76.8429),
        CLLocationCoordinate2DMake(39.3181,-76.8439),
        CLLocationCoordinate2DMake(39.3183,-76.8442),
        CLLocationCoordinate2DMake(39.3183,-76.8452),
        CLLocationCoordinate2DMake(39.318,-76.847),
        CLLocationCoordinate2DMake(39.3176,-76.8473),
        CLLocationCoordinate2DMake(39.3164,-76.848),
        CLLocationCoordinate2DMake(39.3161,-76.8484),
        CLLocationCoordinate2DMake(39.3157,-76.8496),
        CLLocationCoordinate2DMake(39.3158,-76.8499),
        CLLocationCoordinate2DMake(39.3157,-76.8502),
        CLLocationCoordinate2DMake(39.3157,-76.8508),
        CLLocationCoordinate2DMake(39.3159,-76.8513),
        CLLocationCoordinate2DMake(39.3162,-76.8519),
        CLLocationCoordinate2DMake(39.317,-76.8526),
        CLLocationCoordinate2DMake(39.3173,-76.8535),
        CLLocationCoordinate2DMake(39.3176,-76.854),
        CLLocationCoordinate2DMake(39.3182,-76.8544),
        CLLocationCoordinate2DMake(39.3184,-76.8546),
        CLLocationCoordinate2DMake(39.319,-76.8551),
        CLLocationCoordinate2DMake(39.3195,-76.8552),
        CLLocationCoordinate2DMake(39.3201,-76.8551),
        CLLocationCoordinate2DMake(39.3203,-76.8552),
        CLLocationCoordinate2DMake(39.3227,-76.8553),
        CLLocationCoordinate2DMake(39.3232,-76.8555),
        CLLocationCoordinate2DMake(39.3238,-76.8563),
        CLLocationCoordinate2DMake(39.3246,-76.8569),
        CLLocationCoordinate2DMake(39.3255,-76.858),
        CLLocationCoordinate2DMake(39.3268,-76.8592),
        CLLocationCoordinate2DMake(39.327,-76.8598),
        CLLocationCoordinate2DMake(39.3274,-76.8603),
        CLLocationCoordinate2DMake(39.3284,-76.8611),
        CLLocationCoordinate2DMake(39.3285,-76.8613),
        CLLocationCoordinate2DMake(39.33,-76.8629),
        CLLocationCoordinate2DMake(39.3309,-76.8644),
        CLLocationCoordinate2DMake(39.3314,-76.8655),
        CLLocationCoordinate2DMake(39.3317,-76.8666),
        CLLocationCoordinate2DMake(39.3313,-76.8692),
        CLLocationCoordinate2DMake(39.3316,-76.8699),
        CLLocationCoordinate2DMake(39.3317,-76.8708),
        CLLocationCoordinate2DMake(39.3319,-76.8719),
        CLLocationCoordinate2DMake(39.3316,-76.8743),
        CLLocationCoordinate2DMake(39.3321,-76.8751),
        CLLocationCoordinate2DMake(39.3339,-76.8759),
        CLLocationCoordinate2DMake(39.3348,-76.877),
        CLLocationCoordinate2DMake(39.335,-76.8772),
        CLLocationCoordinate2DMake(39.3347,-76.8767),
        CLLocationCoordinate2DMake(39.3351,-76.8771),
        CLLocationCoordinate2DMake(39.3352,-76.8773),
        CLLocationCoordinate2DMake(39.3357,-76.8779),
        CLLocationCoordinate2DMake(39.3362,-76.8783),
        CLLocationCoordinate2DMake(39.3366,-76.8781),
        CLLocationCoordinate2DMake(39.3371,-76.8774),
        CLLocationCoordinate2DMake(39.3373,-76.8765),
        CLLocationCoordinate2DMake(39.3372,-76.8758),
        CLLocationCoordinate2DMake(39.3377,-76.8753),
        CLLocationCoordinate2DMake(39.3394,-76.875),
        CLLocationCoordinate2DMake(39.3401,-76.8753),
        CLLocationCoordinate2DMake(39.3412,-76.8763),
        CLLocationCoordinate2DMake(39.3414,-76.8768),
        CLLocationCoordinate2DMake(39.3417,-76.8771),
        CLLocationCoordinate2DMake(39.3421,-76.878),
        CLLocationCoordinate2DMake(39.3424,-76.8783),
        CLLocationCoordinate2DMake(39.3432,-76.8787),
        CLLocationCoordinate2DMake(39.3458,-76.8796),
        CLLocationCoordinate2DMake(39.3463,-76.8799),
        CLLocationCoordinate2DMake(39.3466,-76.8805),
        CLLocationCoordinate2DMake(39.3479,-76.8815),
        CLLocationCoordinate2DMake(39.3485,-76.8822),
        CLLocationCoordinate2DMake(39.349,-76.8824),
        CLLocationCoordinate2DMake(39.35,-76.8823),
        CLLocationCoordinate2DMake(39.3517,-76.8836),
        CLLocationCoordinate2DMake(39.3522,-76.8842),
        CLLocationCoordinate2DMake(39.3525,-76.8859),
        CLLocationCoordinate2DMake(39.3523,-76.886),
        CLLocationCoordinate2DMake(39.3507,-76.8859),
        CLLocationCoordinate2DMake(39.3505,-76.886),
        CLLocationCoordinate2DMake(39.3504,-76.8865),
        CLLocationCoordinate2DMake(39.3508,-76.887),
        CLLocationCoordinate2DMake(39.3514,-76.888),
        CLLocationCoordinate2DMake(39.352,-76.8886),
        CLLocationCoordinate2DMake(39.3523,-76.8886),
        CLLocationCoordinate2DMake(39.353,-76.888),
        CLLocationCoordinate2DMake(39.3534,-76.8883),
        CLLocationCoordinate2DMake(39.3537,-76.8887),
        CLLocationCoordinate2DMake(39.3536,-76.8892),
        CLLocationCoordinate2DMake(39.353,-76.8909),
        CLLocationCoordinate2DMake(39.3526,-76.8934),
        CLLocationCoordinate2DMake(39.3521,-76.8946),
        CLLocationCoordinate2DMake(39.3521,-76.8964),
        CLLocationCoordinate2DMake(39.3519,-76.8966),
        CLLocationCoordinate2DMake(39.3517,-76.8969),
        CLLocationCoordinate2DMake(39.3516,-76.8977),
        CLLocationCoordinate2DMake(39.3522,-76.8995),
        CLLocationCoordinate2DMake(39.3537,-76.9007),
        CLLocationCoordinate2DMake(39.3543,-76.9018),
        CLLocationCoordinate2DMake(39.3543,-76.903),
        CLLocationCoordinate2DMake(39.3541,-76.9036),
        CLLocationCoordinate2DMake(39.3543,-76.9042),
        CLLocationCoordinate2DMake(39.354,-76.9048),
        CLLocationCoordinate2DMake(39.3539,-76.9059),
        CLLocationCoordinate2DMake(39.3529,-76.9084),
        CLLocationCoordinate2DMake(39.3524,-76.9089),
        CLLocationCoordinate2DMake(39.3521,-76.9088),
        CLLocationCoordinate2DMake(39.3518,-76.9089),
        CLLocationCoordinate2DMake(39.3505,-76.9088),
        CLLocationCoordinate2DMake(39.3499,-76.908),
        CLLocationCoordinate2DMake(39.3496,-76.9078),
        CLLocationCoordinate2DMake(39.3492,-76.908),
        CLLocationCoordinate2DMake(39.3487,-76.9086),
        CLLocationCoordinate2DMake(39.3485,-76.9091),
        CLLocationCoordinate2DMake(39.3484,-76.9098),
        CLLocationCoordinate2DMake(39.3486,-76.9102),
        CLLocationCoordinate2DMake(39.3492,-76.9105),
        CLLocationCoordinate2DMake(39.3492,-76.9111),
        CLLocationCoordinate2DMake(39.3495,-76.9116),
        CLLocationCoordinate2DMake(39.3504,-76.9118),
        CLLocationCoordinate2DMake(39.3508,-76.9125),
        CLLocationCoordinate2DMake(39.3507,-76.9131),
        CLLocationCoordinate2DMake(39.3508,-76.9138),
        CLLocationCoordinate2DMake(39.351,-76.914),
        CLLocationCoordinate2DMake(39.3514,-76.915),
        CLLocationCoordinate2DMake(39.3513,-76.9153),
        CLLocationCoordinate2DMake(39.3509,-76.9155),
        CLLocationCoordinate2DMake(39.3508,-76.916),
        CLLocationCoordinate2DMake(39.3507,-76.9165),
        CLLocationCoordinate2DMake(39.3507,-76.918),
        CLLocationCoordinate2DMake(39.3514,-76.9197),
        CLLocationCoordinate2DMake(39.3514,-76.9201),
        CLLocationCoordinate2DMake(39.3521,-76.9235),
        CLLocationCoordinate2DMake(39.3526,-76.9239),
        CLLocationCoordinate2DMake(39.3531,-76.9249),
        CLLocationCoordinate2DMake(39.3533,-76.9249),
        CLLocationCoordinate2DMake(39.3536,-76.9255),
        CLLocationCoordinate2DMake(39.3535,-76.9261),
        CLLocationCoordinate2DMake(39.3537,-76.9269),
        CLLocationCoordinate2DMake(39.3534,-76.9272),
        CLLocationCoordinate2DMake(39.3533,-76.9276),
        CLLocationCoordinate2DMake(39.3533,-76.9279),
        CLLocationCoordinate2DMake(39.3536,-76.9282),
        CLLocationCoordinate2DMake(39.3537,-76.9291),
        CLLocationCoordinate2DMake(39.3542,-76.9298),
        CLLocationCoordinate2DMake(39.3547,-76.93),
        CLLocationCoordinate2DMake(39.3551,-76.9304),
        CLLocationCoordinate2DMake(39.3552,-76.9306),
        CLLocationCoordinate2DMake(39.3552,-76.931),
        CLLocationCoordinate2DMake(39.3553,-76.9314),
        CLLocationCoordinate2DMake(39.356,-76.9322),
        CLLocationCoordinate2DMake(39.3567,-76.9324),
        CLLocationCoordinate2DMake(39.3574,-76.9333),
        CLLocationCoordinate2DMake(39.3577,-76.9342),
        CLLocationCoordinate2DMake(39.358,-76.9359),
        CLLocationCoordinate2DMake(39.3589,-76.9376),
        CLLocationCoordinate2DMake(39.359,-76.9382),
        CLLocationCoordinate2DMake(39.3589,-76.9386),
        CLLocationCoordinate2DMake(39.3584,-76.9393),
        CLLocationCoordinate2DMake(39.3578,-76.9396),
        CLLocationCoordinate2DMake(39.3573,-76.9405),
        CLLocationCoordinate2DMake(39.3572,-76.9408),
        CLLocationCoordinate2DMake(39.3574,-76.9416),
        CLLocationCoordinate2DMake(39.3576,-76.9421),
        CLLocationCoordinate2DMake(39.358,-76.9425),
        CLLocationCoordinate2DMake(39.3586,-76.9435),
        CLLocationCoordinate2DMake(39.3584,-76.9438),
        CLLocationCoordinate2DMake(39.3586,-76.9445),
        CLLocationCoordinate2DMake(39.3591,-76.9451),
        CLLocationCoordinate2DMake(39.3597,-76.9451),
        CLLocationCoordinate2DMake(39.3604,-76.9454),
        CLLocationCoordinate2DMake(39.3608,-76.9459),
        CLLocationCoordinate2DMake(39.3611,-76.9465),
        CLLocationCoordinate2DMake(39.361,-76.9468),
        CLLocationCoordinate2DMake(39.3607,-76.9469),
        CLLocationCoordinate2DMake(39.3605,-76.9473),
        CLLocationCoordinate2DMake(39.3604,-76.948),
        CLLocationCoordinate2DMake(39.3605,-76.9488),
        CLLocationCoordinate2DMake(39.36,-76.9501),
        CLLocationCoordinate2DMake(39.3596,-76.9508),
        CLLocationCoordinate2DMake(39.3593,-76.951),
        CLLocationCoordinate2DMake(39.3589,-76.9512),
        CLLocationCoordinate2DMake(39.3587,-76.9505),
        CLLocationCoordinate2DMake(39.3585,-76.9503),
        CLLocationCoordinate2DMake(39.358,-76.9503),
        CLLocationCoordinate2DMake(39.3577,-76.9507),
        CLLocationCoordinate2DMake(39.3577,-76.9511),
        CLLocationCoordinate2DMake(39.3578,-76.9509),
        CLLocationCoordinate2DMake(39.358,-76.952),
        CLLocationCoordinate2DMake(39.358,-76.9525),
        CLLocationCoordinate2DMake(39.3579,-76.9526),
        CLLocationCoordinate2DMake(39.3578,-76.9525),
        CLLocationCoordinate2DMake(39.3577,-76.9529),
        CLLocationCoordinate2DMake(39.3579,-76.9546),
        CLLocationCoordinate2DMake(39.3578,-76.9553),
        CLLocationCoordinate2DMake(39.3577,-76.9572),
        CLLocationCoordinate2DMake(39.3573,-76.9586),
        CLLocationCoordinate2DMake(39.3567,-76.9592),
        CLLocationCoordinate2DMake(39.3566,-76.9597),
        CLLocationCoordinate2DMake(39.3567,-76.96),
        CLLocationCoordinate2DMake(39.3572,-76.9605),
        CLLocationCoordinate2DMake(39.3575,-76.9617),
        CLLocationCoordinate2DMake(39.3585,-76.9629),
        CLLocationCoordinate2DMake(39.3595,-76.9637),
        CLLocationCoordinate2DMake(39.3614,-76.9646),
        CLLocationCoordinate2DMake(39.3618,-76.9653),
        CLLocationCoordinate2DMake(39.3621,-76.9668),
        CLLocationCoordinate2DMake(39.3626,-76.9677),
        CLLocationCoordinate2DMake(39.3636,-76.9687),
        CLLocationCoordinate2DMake(39.364,-76.9699),
        CLLocationCoordinate2DMake(39.3637,-76.9703),
        CLLocationCoordinate2DMake(39.3634,-76.9719),
        CLLocationCoordinate2DMake(39.3629,-76.9731),
        CLLocationCoordinate2DMake(39.3625,-76.9738),
        CLLocationCoordinate2DMake(39.3618,-76.974),
        CLLocationCoordinate2DMake(39.3612,-76.9747),
        CLLocationCoordinate2DMake(39.3612,-76.9753),
        CLLocationCoordinate2DMake(39.3618,-76.9758),
        CLLocationCoordinate2DMake(39.3619,-76.9766),
        CLLocationCoordinate2DMake(39.3619,-76.9777),
        CLLocationCoordinate2DMake(39.3616,-76.9786),
        CLLocationCoordinate2DMake(39.3615,-76.9791),
        CLLocationCoordinate2DMake(39.3618,-76.9808),
        CLLocationCoordinate2DMake(39.3616,-76.9817),
        CLLocationCoordinate2DMake(39.3627,-76.9824),
        CLLocationCoordinate2DMake(39.3629,-76.9829),
        CLLocationCoordinate2DMake(39.3628,-76.9835),
        CLLocationCoordinate2DMake(39.3622,-76.9846),
        CLLocationCoordinate2DMake(39.3615,-76.9851),
        CLLocationCoordinate2DMake(39.3614,-76.9855),
        CLLocationCoordinate2DMake(39.3613,-76.9862),
        CLLocationCoordinate2DMake(39.3616,-76.9874),
        CLLocationCoordinate2DMake(39.3616,-76.9886),
        CLLocationCoordinate2DMake(39.3614,-76.9893),
        CLLocationCoordinate2DMake(39.361,-76.9901),
        CLLocationCoordinate2DMake(39.3599,-76.9909),
        CLLocationCoordinate2DMake(39.3598,-76.9915),
        CLLocationCoordinate2DMake(39.3598,-76.9925),
        CLLocationCoordinate2DMake(39.3596,-76.9929),
        CLLocationCoordinate2DMake(39.3587,-76.9939),
        CLLocationCoordinate2DMake(39.3585,-76.9943),
        CLLocationCoordinate2DMake(39.3577,-76.995),
        CLLocationCoordinate2DMake(39.3566,-76.9968),
        CLLocationCoordinate2DMake(39.3557,-76.9979),
        CLLocationCoordinate2DMake(39.355,-76.9977),
        CLLocationCoordinate2DMake(39.3548,-76.9977),
        CLLocationCoordinate2DMake(39.3548,-76.9979),
        CLLocationCoordinate2DMake(39.3547,-77.0003),
        CLLocationCoordinate2DMake(39.3545,-77.0013),
        CLLocationCoordinate2DMake(39.3543,-77.0016),
        CLLocationCoordinate2DMake(39.3545,-77.0028),
        CLLocationCoordinate2DMake(39.3545,-77.0041),
        CLLocationCoordinate2DMake(39.3546,-77.0057),
        CLLocationCoordinate2DMake(39.3546,-77.0075),
        CLLocationCoordinate2DMake(39.3547,-77.0085),
        CLLocationCoordinate2DMake(39.3547,-77.0094),
        CLLocationCoordinate2DMake(39.3548,-77.0098),
        CLLocationCoordinate2DMake(39.3545,-77.01),
        CLLocationCoordinate2DMake(39.3543,-77.0103),
        CLLocationCoordinate2DMake(39.3542,-77.0106),
        CLLocationCoordinate2DMake(39.3542,-77.011),
        CLLocationCoordinate2DMake(39.354,-77.0117),
        CLLocationCoordinate2DMake(39.3531,-77.0129),
        CLLocationCoordinate2DMake(39.353,-77.0144),
        CLLocationCoordinate2DMake(39.3525,-77.0156),
        CLLocationCoordinate2DMake(39.3524,-77.0161),
        CLLocationCoordinate2DMake(39.3526,-77.0164),
        CLLocationCoordinate2DMake(39.3527,-77.0169),
        CLLocationCoordinate2DMake(39.3524,-77.0183),
        CLLocationCoordinate2DMake(39.3524,-77.0189),
        CLLocationCoordinate2DMake(39.3531,-77.0204),
        CLLocationCoordinate2DMake(39.3533,-77.0205),
        CLLocationCoordinate2DMake(39.3534,-77.0209),
        CLLocationCoordinate2DMake(39.3529,-77.0214),
        CLLocationCoordinate2DMake(39.3526,-77.0212),
        CLLocationCoordinate2DMake(39.3524,-77.0212),
        CLLocationCoordinate2DMake(39.3524,-77.0216),
        CLLocationCoordinate2DMake(39.3521,-77.0219),
        CLLocationCoordinate2DMake(39.3515,-77.0221),
        CLLocationCoordinate2DMake(39.3506,-77.0226),
        CLLocationCoordinate2DMake(39.3507,-77.023),
        CLLocationCoordinate2DMake(39.3505,-77.0231),
        CLLocationCoordinate2DMake(39.3505,-77.0233),
        CLLocationCoordinate2DMake(39.3508,-77.0239),
        CLLocationCoordinate2DMake(39.3508,-77.0244),
        CLLocationCoordinate2DMake(39.3505,-77.0255),
        CLLocationCoordinate2DMake(39.3506,-77.0257),
        CLLocationCoordinate2DMake(39.3508,-77.0256),
        CLLocationCoordinate2DMake(39.3509,-77.0257),
        CLLocationCoordinate2DMake(39.3507,-77.0264),
        CLLocationCoordinate2DMake(39.3509,-77.0269),
        CLLocationCoordinate2DMake(39.3516,-77.027),
        CLLocationCoordinate2DMake(39.3524,-77.0284),
        CLLocationCoordinate2DMake(39.3523,-77.029),
        CLLocationCoordinate2DMake(39.3518,-77.0296),
        CLLocationCoordinate2DMake(39.3513,-77.0304),
        CLLocationCoordinate2DMake(39.3512,-77.0309),
        CLLocationCoordinate2DMake(39.3522,-77.032),
        CLLocationCoordinate2DMake(39.3536,-77.0339),
        CLLocationCoordinate2DMake(39.3541,-77.0336),
        CLLocationCoordinate2DMake(39.3544,-77.0336),
        CLLocationCoordinate2DMake(39.3545,-77.0339),
        CLLocationCoordinate2DMake(39.355,-77.0336),
        CLLocationCoordinate2DMake(39.3553,-77.0336),
        CLLocationCoordinate2DMake(39.3559,-77.0355),
        CLLocationCoordinate2DMake(39.3568,-77.0374),
        CLLocationCoordinate2DMake(39.3577,-77.04),
        CLLocationCoordinate2DMake(39.3589,-77.0425),
        CLLocationCoordinate2DMake(39.3591,-77.0436),
        CLLocationCoordinate2DMake(39.3594,-77.044),
        CLLocationCoordinate2DMake(39.3599,-77.0454),
        CLLocationCoordinate2DMake(39.3611,-77.0473),
        CLLocationCoordinate2DMake(39.3613,-77.0477),
        CLLocationCoordinate2DMake(39.3617,-77.0479),
        CLLocationCoordinate2DMake(39.3622,-77.0489),
        CLLocationCoordinate2DMake(39.3622,-77.0495),
        CLLocationCoordinate2DMake(39.362,-77.0501),
        CLLocationCoordinate2DMake(39.3612,-77.0508),
        CLLocationCoordinate2DMake(39.361,-77.0509),
        CLLocationCoordinate2DMake(39.3605,-77.0506),
        CLLocationCoordinate2DMake(39.3598,-77.0506),
        CLLocationCoordinate2DMake(39.3592,-77.051),
        CLLocationCoordinate2DMake(39.359,-77.0515),
        CLLocationCoordinate2DMake(39.3594,-77.0573),
        CLLocationCoordinate2DMake(39.3597,-77.0586),
        CLLocationCoordinate2DMake(39.3597,-77.0599),
        CLLocationCoordinate2DMake(39.3596,-77.0605),
        CLLocationCoordinate2DMake(39.359,-77.0614),
        CLLocationCoordinate2DMake(39.3593,-77.0616),
        CLLocationCoordinate2DMake(39.3594,-77.062),
        CLLocationCoordinate2DMake(39.3602,-77.0631),
        CLLocationCoordinate2DMake(39.3614,-77.0641),
        CLLocationCoordinate2DMake(39.3616,-77.0647),
        CLLocationCoordinate2DMake(39.3619,-77.0652),
        CLLocationCoordinate2DMake(39.3621,-77.0653),
        CLLocationCoordinate2DMake(39.3623,-77.0655),
        CLLocationCoordinate2DMake(39.3625,-77.0667),
        CLLocationCoordinate2DMake(39.3625,-77.0676),
        CLLocationCoordinate2DMake(39.3628,-77.0681),
        CLLocationCoordinate2DMake(39.3624,-77.0684),
        CLLocationCoordinate2DMake(39.3623,-77.0687),
        CLLocationCoordinate2DMake(39.3626,-77.0696),
        CLLocationCoordinate2DMake(39.3627,-77.0698),
        CLLocationCoordinate2DMake(39.3631,-77.0698),
        CLLocationCoordinate2DMake(39.3632,-77.0706),
        CLLocationCoordinate2DMake(39.3631,-77.0716),
        CLLocationCoordinate2DMake(39.3629,-77.072),
        CLLocationCoordinate2DMake(39.3629,-77.0734),
        CLLocationCoordinate2DMake(39.3627,-77.0741),
        CLLocationCoordinate2DMake(39.3628,-77.0747),
        CLLocationCoordinate2DMake(39.3634,-77.0752),
        CLLocationCoordinate2DMake(39.3637,-77.0749),
        CLLocationCoordinate2DMake(39.364,-77.075),
        CLLocationCoordinate2DMake(39.3641,-77.0752),
        CLLocationCoordinate2DMake(39.3645,-77.0751),
        CLLocationCoordinate2DMake(39.3653,-77.0758),
        CLLocationCoordinate2DMake(39.3654,-77.0766),
        CLLocationCoordinate2DMake(39.3658,-77.0766),
        CLLocationCoordinate2DMake(39.366,-77.0773),
        CLLocationCoordinate2DMake(39.3663,-77.0773),
        CLLocationCoordinate2DMake(39.3661,-77.0782),
        CLLocationCoordinate2DMake(39.366,-77.0795),
        CLLocationCoordinate2DMake(39.3657,-77.0807),
        CLLocationCoordinate2DMake(39.3661,-77.0812),
        CLLocationCoordinate2DMake(39.3664,-77.0814),
        CLLocationCoordinate2DMake(39.3664,-77.0817),
        CLLocationCoordinate2DMake(39.3668,-77.0819),
        CLLocationCoordinate2DMake(39.3671,-77.083),
        CLLocationCoordinate2DMake(39.3678,-77.0843),
        CLLocationCoordinate2DMake(39.368,-77.0855),
        CLLocationCoordinate2DMake(39.3681,-77.0863),
        CLLocationCoordinate2DMake(39.3678,-77.0865),
        CLLocationCoordinate2DMake(39.3677,-77.0868),
        CLLocationCoordinate2DMake(39.3675,-77.0884),
        CLLocationCoordinate2DMake(39.3677,-77.0894),
        CLLocationCoordinate2DMake(39.3675,-77.0905),
        CLLocationCoordinate2DMake(39.3672,-77.0913),
        CLLocationCoordinate2DMake(39.3672,-77.0921),
        CLLocationCoordinate2DMake(39.3679,-77.0927),
        CLLocationCoordinate2DMake(39.3685,-77.094),
        CLLocationCoordinate2DMake(39.3684,-77.0944),
        CLLocationCoordinate2DMake(39.3687,-77.0951),
        CLLocationCoordinate2DMake(39.3686,-77.0956),
        CLLocationCoordinate2DMake(39.3685,-77.0964),
        CLLocationCoordinate2DMake(39.3688,-77.0987),
        CLLocationCoordinate2DMake(39.3689,-77.0989),
        CLLocationCoordinate2DMake(39.3692,-77.1004),
        CLLocationCoordinate2DMake(39.3695,-77.1007),
        CLLocationCoordinate2DMake(39.3695,-77.101),
        CLLocationCoordinate2DMake(39.3693,-77.1026),
        CLLocationCoordinate2DMake(39.369,-77.1028),
        CLLocationCoordinate2DMake(39.368,-77.1044),
        CLLocationCoordinate2DMake(39.3673,-77.1053),
        CLLocationCoordinate2DMake(39.3673,-77.1056),
        CLLocationCoordinate2DMake(39.3673,-77.1059),
        CLLocationCoordinate2DMake(39.3669,-77.1066),
        CLLocationCoordinate2DMake(39.3667,-77.1074),
        CLLocationCoordinate2DMake(39.3666,-77.108),
        CLLocationCoordinate2DMake(39.3668,-77.1083),
        CLLocationCoordinate2DMake(39.3666,-77.1086),
        CLLocationCoordinate2DMake(39.3669,-77.11),
        CLLocationCoordinate2DMake(39.3667,-77.1112),
        CLLocationCoordinate2DMake(39.3667,-77.1118),
        CLLocationCoordinate2DMake(39.3665,-77.1125),
        CLLocationCoordinate2DMake(39.366,-77.1128),
        CLLocationCoordinate2DMake(39.3658,-77.1132),
        CLLocationCoordinate2DMake(39.3658,-77.1138),
        CLLocationCoordinate2DMake(39.3659,-77.1148),
        CLLocationCoordinate2DMake(39.3661,-77.1151),
        CLLocationCoordinate2DMake(39.3661,-77.1156),
        CLLocationCoordinate2DMake(39.3666,-77.1162),
        CLLocationCoordinate2DMake(39.3667,-77.1166),
        CLLocationCoordinate2DMake(39.3661,-77.1176),
        CLLocationCoordinate2DMake(39.3657,-77.118),
        CLLocationCoordinate2DMake(39.366,-77.1197),
        CLLocationCoordinate2DMake(39.3658,-77.1202),
        CLLocationCoordinate2DMake(39.3657,-77.1207),
        CLLocationCoordinate2DMake(39.3653,-77.1211),
        CLLocationCoordinate2DMake(39.3652,-77.1219),
        CLLocationCoordinate2DMake(39.3649,-77.1226),
        CLLocationCoordinate2DMake(39.365,-77.1234),
        CLLocationCoordinate2DMake(39.3648,-77.1239),
        CLLocationCoordinate2DMake(39.3649,-77.125),
        CLLocationCoordinate2DMake(39.3644,-77.1254),
        CLLocationCoordinate2DMake(39.3644,-77.126),
        CLLocationCoordinate2DMake(39.364,-77.1268),
        CLLocationCoordinate2DMake(39.3634,-77.1273),
        CLLocationCoordinate2DMake(39.3634,-77.1277),
        CLLocationCoordinate2DMake(39.3632,-77.1283),
        CLLocationCoordinate2DMake(39.3628,-77.1285),
        CLLocationCoordinate2DMake(39.3628,-77.1288),
        CLLocationCoordinate2DMake(39.3626,-77.1295),
        CLLocationCoordinate2DMake(39.3626,-77.1303),
        CLLocationCoordinate2DMake(39.3624,-77.131),
        CLLocationCoordinate2DMake(39.362,-77.1314),
        CLLocationCoordinate2DMake(39.3617,-77.1321),
        CLLocationCoordinate2DMake(39.3614,-77.1325),
        CLLocationCoordinate2DMake(39.361,-77.1333),
        CLLocationCoordinate2DMake(39.3608,-77.1333),
        CLLocationCoordinate2DMake(39.3605,-77.1341),
        CLLocationCoordinate2DMake(39.3604,-77.1342),
        CLLocationCoordinate2DMake(39.3604,-77.1348),
        CLLocationCoordinate2DMake(39.3606,-77.1351),
        CLLocationCoordinate2DMake(39.3602,-77.1353),
        CLLocationCoordinate2DMake(39.3601,-77.1359),
        CLLocationCoordinate2DMake(39.3596,-77.1359),
        CLLocationCoordinate2DMake(39.3595,-77.1355),
        CLLocationCoordinate2DMake(39.3594,-77.1356),
        CLLocationCoordinate2DMake(39.359,-77.1363),
        CLLocationCoordinate2DMake(39.3587,-77.1366),
        CLLocationCoordinate2DMake(39.3587,-77.1367),
        CLLocationCoordinate2DMake(39.3589,-77.1368),
        CLLocationCoordinate2DMake(39.3587,-77.1373),
        CLLocationCoordinate2DMake(39.3584,-77.1375),
        CLLocationCoordinate2DMake(39.3578,-77.1384),
        CLLocationCoordinate2DMake(39.3576,-77.1385),
        CLLocationCoordinate2DMake(39.3562,-77.14),
        CLLocationCoordinate2DMake(39.3559,-77.1399),
        CLLocationCoordinate2DMake(39.3556,-77.14),
        CLLocationCoordinate2DMake(39.3556,-77.1403),
        CLLocationCoordinate2DMake(39.3554,-77.1403),
        CLLocationCoordinate2DMake(39.3554,-77.1406),
        CLLocationCoordinate2DMake(39.3551,-77.1408),
        CLLocationCoordinate2DMake(39.3551,-77.1412),
        CLLocationCoordinate2DMake(39.3547,-77.1414),
        CLLocationCoordinate2DMake(39.3544,-77.1413),
        CLLocationCoordinate2DMake(39.3543,-77.1421),
        CLLocationCoordinate2DMake(39.3538,-77.1424),
        CLLocationCoordinate2DMake(39.3535,-77.1424),
        CLLocationCoordinate2DMake(39.353,-77.1429),
        CLLocationCoordinate2DMake(39.3529,-77.1429),
        CLLocationCoordinate2DMake(39.3529,-77.1432),
        CLLocationCoordinate2DMake(39.3527,-77.1432),
        CLLocationCoordinate2DMake(39.3527,-77.1434),
        CLLocationCoordinate2DMake(39.3526,-77.1434),
        CLLocationCoordinate2DMake(39.3523,-77.1438),
        CLLocationCoordinate2DMake(39.3519,-77.1439),
        CLLocationCoordinate2DMake(39.3513,-77.1446),
        CLLocationCoordinate2DMake(39.351,-77.1451),
        CLLocationCoordinate2DMake(39.3509,-77.1457),
        CLLocationCoordinate2DMake(39.3505,-77.146),
        CLLocationCoordinate2DMake(39.3506,-77.1464),
        CLLocationCoordinate2DMake(39.3503,-77.1466),
        CLLocationCoordinate2DMake(39.3505,-77.1469),
        CLLocationCoordinate2DMake(39.3504,-77.1476),
        CLLocationCoordinate2DMake(39.3502,-77.1479),
        CLLocationCoordinate2DMake(39.3503,-77.1482),
        CLLocationCoordinate2DMake(39.35,-77.1482),
        CLLocationCoordinate2DMake(39.3499,-77.1486),
        CLLocationCoordinate2DMake(39.3496,-77.1488),
        CLLocationCoordinate2DMake(39.3496,-77.149),
        CLLocationCoordinate2DMake(39.3498,-77.1491),
        CLLocationCoordinate2DMake(39.3498,-77.1495),
        CLLocationCoordinate2DMake(39.3495,-77.1498),
        CLLocationCoordinate2DMake(39.3495,-77.15),
        CLLocationCoordinate2DMake(39.3493,-77.1499),
        CLLocationCoordinate2DMake(39.3492,-77.1501),
        CLLocationCoordinate2DMake(39.349,-77.15),
        CLLocationCoordinate2DMake(39.349,-77.1505),
        CLLocationCoordinate2DMake(39.3488,-77.1507),
        CLLocationCoordinate2DMake(39.3487,-77.1506),
        CLLocationCoordinate2DMake(39.3486,-77.1508),
        CLLocationCoordinate2DMake(39.3486,-77.1519),
        CLLocationCoordinate2DMake(39.3484,-77.1519),
        CLLocationCoordinate2DMake(39.3484,-77.1522),
        CLLocationCoordinate2DMake(39.3486,-77.1526),
        CLLocationCoordinate2DMake(39.3486,-77.1532),
        CLLocationCoordinate2DMake(39.3488,-77.1531),
        CLLocationCoordinate2DMake(39.349,-77.1533),
        CLLocationCoordinate2DMake(39.3492,-77.154),
        CLLocationCoordinate2DMake(39.3491,-77.1543),
        CLLocationCoordinate2DMake(39.3493,-77.1545),
        CLLocationCoordinate2DMake(39.3495,-77.1559),
        CLLocationCoordinate2DMake(39.3499,-77.1568),
        CLLocationCoordinate2DMake(39.3498,-77.157),
        CLLocationCoordinate2DMake(39.35,-77.1572),
        CLLocationCoordinate2DMake(39.3499,-77.1574),
        CLLocationCoordinate2DMake(39.3502,-77.1578),
        CLLocationCoordinate2DMake(39.3501,-77.158),
        CLLocationCoordinate2DMake(39.3503,-77.1581),
        CLLocationCoordinate2DMake(39.3503,-77.1583),
        CLLocationCoordinate2DMake(39.3507,-77.1588),
        CLLocationCoordinate2DMake(39.3505,-77.1592),
        CLLocationCoordinate2DMake(39.3509,-77.1606),
        CLLocationCoordinate2DMake(39.3512,-77.1608),
        CLLocationCoordinate2DMake(39.3512,-77.1611),
        CLLocationCoordinate2DMake(39.3513,-77.161),
        CLLocationCoordinate2DMake(39.3519,-77.1618),
        CLLocationCoordinate2DMake(39.3521,-77.1619),
        CLLocationCoordinate2DMake(39.3526,-77.1629),
        CLLocationCoordinate2DMake(39.3529,-77.1645),
        CLLocationCoordinate2DMake(39.3527,-77.1658),
        CLLocationCoordinate2DMake(39.3531,-77.1666),
        CLLocationCoordinate2DMake(39.3537,-77.167),
        CLLocationCoordinate2DMake(39.3543,-77.1677),
        CLLocationCoordinate2DMake(39.3466,-77.1807),
        CLLocationCoordinate2DMake(39.3462,-77.1816),
        CLLocationCoordinate2DMake(39.3459,-77.1819),
        CLLocationCoordinate2DMake(39.3458,-77.1819),
        CLLocationCoordinate2DMake(39.3456,-77.1825),
        CLLocationCoordinate2DMake(39.3455,-77.1825),
        CLLocationCoordinate2DMake(39.3454,-77.1831),
        CLLocationCoordinate2DMake(39.3453,-77.1831),
        CLLocationCoordinate2DMake(39.3452,-77.1837),
        CLLocationCoordinate2DMake(39.345,-77.1837),
        CLLocationCoordinate2DMake(39.345,-77.1841),
        CLLocationCoordinate2DMake(39.3447,-77.1842),
        CLLocationCoordinate2DMake(39.3441,-77.1848),
        CLLocationCoordinate2DMake(39.3439,-77.1848),
        CLLocationCoordinate2DMake(39.3437,-77.1852),
        CLLocationCoordinate2DMake(39.3432,-77.1853),
        CLLocationCoordinate2DMake(39.3428,-77.1856),
        CLLocationCoordinate2DMake(39.3424,-77.1855),
        CLLocationCoordinate2DMake(39.3423,-77.1858),
        CLLocationCoordinate2DMake(39.342,-77.1859),
        CLLocationCoordinate2DMake(39.342,-77.1861),
        CLLocationCoordinate2DMake(39.3409,-77.1869),
        CLLocationCoordinate2DMake(39.3402,-77.1871),
        CLLocationCoordinate2DMake(39.3392,-77.1867),
        CLLocationCoordinate2DMake(39.3383,-77.187),
        CLLocationCoordinate2DMake(39.3382,-77.1867),
        CLLocationCoordinate2DMake(39.3373,-77.186),
        CLLocationCoordinate2DMake(39.3372,-77.1861),
        CLLocationCoordinate2DMake(39.3371,-77.1859),
        CLLocationCoordinate2DMake(39.3368,-77.1858),
        CLLocationCoordinate2DMake(39.3361,-77.1847),
        CLLocationCoordinate2DMake(39.3356,-77.1846),
        CLLocationCoordinate2DMake(39.3349,-77.1841),
        CLLocationCoordinate2DMake(39.3346,-77.1842),
        CLLocationCoordinate2DMake(39.3341,-77.1837),
        CLLocationCoordinate2DMake(39.3332,-77.1835),
        CLLocationCoordinate2DMake(39.333,-77.1832),
        CLLocationCoordinate2DMake(39.3328,-77.1832),
        CLLocationCoordinate2DMake(39.3321,-77.1825),
        CLLocationCoordinate2DMake(39.3287,-77.1815),
        CLLocationCoordinate2DMake(39.3283,-77.1811),
        CLLocationCoordinate2DMake(39.3277,-77.1802),
        CLLocationCoordinate2DMake(39.3271,-77.1796),
        CLLocationCoordinate2DMake(39.3266,-77.179),
        CLLocationCoordinate2DMake(39.3259,-77.1785),
        CLLocationCoordinate2DMake(39.3259,-77.1783),
        CLLocationCoordinate2DMake(39.3256,-77.1783),
        CLLocationCoordinate2DMake(39.3256,-77.1779),
        CLLocationCoordinate2DMake(39.325,-77.1779),
        CLLocationCoordinate2DMake(39.3245,-77.1773),
        CLLocationCoordinate2DMake(39.3241,-77.1762),
        CLLocationCoordinate2DMake(39.3238,-77.1763),
        CLLocationCoordinate2DMake(39.323,-77.1758),
        CLLocationCoordinate2DMake(39.3225,-77.1749),
        CLLocationCoordinate2DMake(39.3221,-77.1748),
        CLLocationCoordinate2DMake(39.3218,-77.1746),
        CLLocationCoordinate2DMake(39.3215,-77.1743),
        CLLocationCoordinate2DMake(39.3214,-77.1739),
        CLLocationCoordinate2DMake(39.321,-77.1739),
        CLLocationCoordinate2DMake(39.3207,-77.1736),
        CLLocationCoordinate2DMake(39.3205,-77.1732),
        CLLocationCoordinate2DMake(39.319,-77.1727),
        CLLocationCoordinate2DMake(39.3188,-77.1729),
        CLLocationCoordinate2DMake(39.3186,-77.1728),
        CLLocationCoordinate2DMake(39.3186,-77.1725),
        CLLocationCoordinate2DMake(39.3182,-77.1724),
        CLLocationCoordinate2DMake(39.3174,-77.1725),
        CLLocationCoordinate2DMake(39.3171,-77.1722),
        CLLocationCoordinate2DMake(39.3162,-77.1722),
        CLLocationCoordinate2DMake(39.3155,-77.1716),
        CLLocationCoordinate2DMake(39.3154,-77.1719),
        CLLocationCoordinate2DMake(39.3152,-77.1719),
        CLLocationCoordinate2DMake(39.3151,-77.1715),
        CLLocationCoordinate2DMake(39.315,-77.1718),
        CLLocationCoordinate2DMake(39.3149,-77.1715),
        CLLocationCoordinate2DMake(39.3143,-77.1713),
        CLLocationCoordinate2DMake(39.3142,-77.1709),
        CLLocationCoordinate2DMake(39.3139,-77.1709),
        CLLocationCoordinate2DMake(39.3134,-77.1704),
        CLLocationCoordinate2DMake(39.3132,-77.1704),
        CLLocationCoordinate2DMake(39.3131,-77.1702),
        CLLocationCoordinate2DMake(39.3132,-77.17),
        CLLocationCoordinate2DMake(39.3126,-77.1694),
        CLLocationCoordinate2DMake(39.3124,-77.1693),
        CLLocationCoordinate2DMake(39.3123,-77.169),
        CLLocationCoordinate2DMake(39.3121,-77.1687),
        CLLocationCoordinate2DMake(39.3124,-77.1677),
        CLLocationCoordinate2DMake(39.3122,-77.1669),
        CLLocationCoordinate2DMake(39.3118,-77.1663),
        CLLocationCoordinate2DMake(39.3112,-77.1661),
        CLLocationCoordinate2DMake(39.3109,-77.1656),
        CLLocationCoordinate2DMake(39.3101,-77.1654),
        CLLocationCoordinate2DMake(39.3096,-77.1655),
        CLLocationCoordinate2DMake(39.3088,-77.1647),
        CLLocationCoordinate2DMake(39.3081,-77.1649),
        CLLocationCoordinate2DMake(39.3074,-77.1644),
        CLLocationCoordinate2DMake(39.3073,-77.1639),
        CLLocationCoordinate2DMake(39.3076,-77.1637),
        CLLocationCoordinate2DMake(39.3077,-77.1633),
        CLLocationCoordinate2DMake(39.3079,-77.1631),
        CLLocationCoordinate2DMake(39.3078,-77.1628),
        CLLocationCoordinate2DMake(39.3079,-77.1622),
        CLLocationCoordinate2DMake(39.3072,-77.1615),
        CLLocationCoordinate2DMake(39.3068,-77.1609),
        CLLocationCoordinate2DMake(39.3058,-77.1604),
        CLLocationCoordinate2DMake(39.3057,-77.1602),
        CLLocationCoordinate2DMake(39.3054,-77.1601),
        CLLocationCoordinate2DMake(39.3048,-77.1597),
        CLLocationCoordinate2DMake(39.3046,-77.1587),
        CLLocationCoordinate2DMake(39.304,-77.1573),
        CLLocationCoordinate2DMake(39.3037,-77.1568),
        CLLocationCoordinate2DMake(39.3036,-77.1563),
        CLLocationCoordinate2DMake(39.3032,-77.1559),
        CLLocationCoordinate2DMake(39.3023,-77.1537),
        CLLocationCoordinate2DMake(39.301,-77.1523),
        CLLocationCoordinate2DMake(39.3005,-77.152),
        CLLocationCoordinate2DMake(39.3005,-77.1515),
        CLLocationCoordinate2DMake(39.3002,-77.1509),
        CLLocationCoordinate2DMake(39.3001,-77.1509),
        CLLocationCoordinate2DMake(39.3,-77.151),
        CLLocationCoordinate2DMake(39.2998,-77.1509),
        CLLocationCoordinate2DMake(39.2993,-77.1491),
        CLLocationCoordinate2DMake(39.298,-77.1482),
        CLLocationCoordinate2DMake(39.2975,-77.1474),
        CLLocationCoordinate2DMake(39.2955,-77.145),
        CLLocationCoordinate2DMake(39.2949,-77.1448),
        CLLocationCoordinate2DMake(39.2939,-77.1439),
        CLLocationCoordinate2DMake(39.2929,-77.1435),
        CLLocationCoordinate2DMake(39.293,-77.143),
        CLLocationCoordinate2DMake(39.2926,-77.1426),
        CLLocationCoordinate2DMake(39.2921,-77.14),
        CLLocationCoordinate2DMake(39.2897,-77.1404),
        CLLocationCoordinate2DMake(39.289,-77.14),
        CLLocationCoordinate2DMake(39.2889,-77.1395),
        CLLocationCoordinate2DMake(39.2884,-77.138),
        CLLocationCoordinate2DMake(39.288,-77.1378),
        CLLocationCoordinate2DMake(39.2879,-77.1375),
        CLLocationCoordinate2DMake(39.2877,-77.1375),
        CLLocationCoordinate2DMake(39.2871,-77.1383),
        CLLocationCoordinate2DMake(39.2866,-77.1385),
        CLLocationCoordinate2DMake(39.2866,-77.1391),
        CLLocationCoordinate2DMake(39.2861,-77.1394),
        CLLocationCoordinate2DMake(39.2857,-77.14),
        CLLocationCoordinate2DMake(39.2853,-77.1398),
        CLLocationCoordinate2DMake(39.2848,-77.1398),
        CLLocationCoordinate2DMake(39.2841,-77.1395),
        CLLocationCoordinate2DMake(39.2839,-77.1396),
        CLLocationCoordinate2DMake(39.2835,-77.14),
        CLLocationCoordinate2DMake(39.2832,-77.1401),
        CLLocationCoordinate2DMake(39.2826,-77.1394),
        CLLocationCoordinate2DMake(39.2811,-77.1385),
        CLLocationCoordinate2DMake(39.2806,-77.1376),
        CLLocationCoordinate2DMake(39.2803,-77.1376),
        CLLocationCoordinate2DMake(39.28,-77.1373),
        CLLocationCoordinate2DMake(39.2797,-77.1373),
        CLLocationCoordinate2DMake(39.2793,-77.1365),
        CLLocationCoordinate2DMake(39.2785,-77.1364),
        CLLocationCoordinate2DMake(39.2781,-77.1366),
        CLLocationCoordinate2DMake(39.2781,-77.136),
        CLLocationCoordinate2DMake(39.2769,-77.1347),
        CLLocationCoordinate2DMake(39.2766,-77.1341),
        CLLocationCoordinate2DMake(39.2754,-77.134),
        CLLocationCoordinate2DMake(39.2748,-77.1343),
        CLLocationCoordinate2DMake(39.2745,-77.1342),
        CLLocationCoordinate2DMake(39.2739,-77.1344),
        CLLocationCoordinate2DMake(39.2735,-77.1343),
        CLLocationCoordinate2DMake(39.2731,-77.1346),
        CLLocationCoordinate2DMake(39.2726,-77.1344),
        CLLocationCoordinate2DMake(39.2724,-77.1346),
        CLLocationCoordinate2DMake(39.2719,-77.1343),
        CLLocationCoordinate2DMake(39.2711,-77.1342),
        CLLocationCoordinate2DMake(39.2706,-77.1337),
        CLLocationCoordinate2DMake(39.2706,-77.1332),
        CLLocationCoordinate2DMake(39.2703,-77.1322),
        CLLocationCoordinate2DMake(39.2702,-77.1315),
        CLLocationCoordinate2DMake(39.2695,-77.1311),
        CLLocationCoordinate2DMake(39.2686,-77.1308),
        CLLocationCoordinate2DMake(39.2683,-77.1304),
        CLLocationCoordinate2DMake(39.2685,-77.1296),
        CLLocationCoordinate2DMake(39.2683,-77.1291),
        CLLocationCoordinate2DMake(39.2685,-77.1286),
        CLLocationCoordinate2DMake(39.2684,-77.1283),
        CLLocationCoordinate2DMake(39.2684,-77.1271),
        CLLocationCoordinate2DMake(39.2687,-77.1267),
        CLLocationCoordinate2DMake(39.2688,-77.1265),
        CLLocationCoordinate2DMake(39.2685,-77.1256),
        CLLocationCoordinate2DMake(39.2686,-77.1254),
        CLLocationCoordinate2DMake(39.2686,-77.1252),
        CLLocationCoordinate2DMake(39.2682,-77.1246),
        CLLocationCoordinate2DMake(39.2681,-77.124),
        CLLocationCoordinate2DMake(39.2682,-77.1233),
        CLLocationCoordinate2DMake(39.2677,-77.1231),
        CLLocationCoordinate2DMake(39.2675,-77.1219),
        CLLocationCoordinate2DMake(39.2672,-77.1215),
        CLLocationCoordinate2DMake(39.267,-77.1204),
        CLLocationCoordinate2DMake(39.2673,-77.1193),
        CLLocationCoordinate2DMake(39.2674,-77.1192),
        CLLocationCoordinate2DMake(39.2674,-77.1189),
        CLLocationCoordinate2DMake(39.2673,-77.1188),
        CLLocationCoordinate2DMake(39.2674,-77.118),
        CLLocationCoordinate2DMake(39.2677,-77.1178),
        CLLocationCoordinate2DMake(39.2675,-77.1174),
        CLLocationCoordinate2DMake(39.2676,-77.1167),
        CLLocationCoordinate2DMake(39.2671,-77.1162),
        CLLocationCoordinate2DMake(39.2669,-77.1159),
        CLLocationCoordinate2DMake(39.2664,-77.1158),
        CLLocationCoordinate2DMake(39.2663,-77.1153),
        CLLocationCoordinate2DMake(39.2659,-77.1151),
        CLLocationCoordinate2DMake(39.2656,-77.1153),
        CLLocationCoordinate2DMake(39.2655,-77.1148),
        CLLocationCoordinate2DMake(39.265,-77.1144),
        CLLocationCoordinate2DMake(39.2646,-77.1137),
        CLLocationCoordinate2DMake(39.265,-77.1124),
        CLLocationCoordinate2DMake(39.2646,-77.1121),
        CLLocationCoordinate2DMake(39.2642,-77.1108),
        CLLocationCoordinate2DMake(39.2643,-77.1101),
        CLLocationCoordinate2DMake(39.2642,-77.1096),
        CLLocationCoordinate2DMake(39.2642,-77.109),
        CLLocationCoordinate2DMake(39.2644,-77.1088),
        CLLocationCoordinate2DMake(39.2643,-77.1086),
        CLLocationCoordinate2DMake(39.2644,-77.1085),
        CLLocationCoordinate2DMake(39.2644,-77.1081),
        CLLocationCoordinate2DMake(39.2646,-77.1075),
        CLLocationCoordinate2DMake(39.2642,-77.1059),
        CLLocationCoordinate2DMake(39.2649,-77.1051),
        CLLocationCoordinate2DMake(39.2654,-77.1043),
        CLLocationCoordinate2DMake(39.266,-77.1037),
        CLLocationCoordinate2DMake(39.266,-77.1034),
        CLLocationCoordinate2DMake(39.2657,-77.1031),
        CLLocationCoordinate2DMake(39.2658,-77.1025),
        CLLocationCoordinate2DMake(39.2655,-77.1021),
        CLLocationCoordinate2DMake(39.2653,-77.1015),
        CLLocationCoordinate2DMake(39.2654,-77.1006),
        CLLocationCoordinate2DMake(39.265,-77.0999),
        CLLocationCoordinate2DMake(39.265,-77.099),
        CLLocationCoordinate2DMake(39.2647,-77.0988),
        CLLocationCoordinate2DMake(39.2649,-77.098),
        CLLocationCoordinate2DMake(39.2649,-77.0972),
        CLLocationCoordinate2DMake(39.2641,-77.096),
        CLLocationCoordinate2DMake(39.2636,-77.0959),
        CLLocationCoordinate2DMake(39.2635,-77.0951),
        CLLocationCoordinate2DMake(39.2625,-77.0929),
        CLLocationCoordinate2DMake(39.2625,-77.0916),
        CLLocationCoordinate2DMake(39.2622,-77.0899),
        CLLocationCoordinate2DMake(39.2622,-77.089),
        CLLocationCoordinate2DMake(39.2616,-77.0883),
        CLLocationCoordinate2DMake(39.2605,-77.0858),
        CLLocationCoordinate2DMake(39.2604,-77.0851),
        CLLocationCoordinate2DMake(39.2605,-77.0838),
        CLLocationCoordinate2DMake(39.26,-77.0818),
        CLLocationCoordinate2DMake(39.2598,-77.0816),
        CLLocationCoordinate2DMake(39.2593,-77.0805),
        CLLocationCoordinate2DMake(39.2595,-77.08),
        CLLocationCoordinate2DMake(39.2589,-77.0798),
        CLLocationCoordinate2DMake(39.2585,-77.0791),
        CLLocationCoordinate2DMake(39.2582,-77.0787),
        CLLocationCoordinate2DMake(39.258,-77.0791),
        CLLocationCoordinate2DMake(39.2576,-77.079),
        CLLocationCoordinate2DMake(39.2575,-77.0785),
        CLLocationCoordinate2DMake(39.2564,-77.0777),
        CLLocationCoordinate2DMake(39.256,-77.0764),
        CLLocationCoordinate2DMake(39.256,-77.0758),
        CLLocationCoordinate2DMake(39.2562,-77.0749),
        CLLocationCoordinate2DMake(39.2561,-77.0743),
        CLLocationCoordinate2DMake(39.2556,-77.0735),
        CLLocationCoordinate2DMake(39.2555,-77.073),
        CLLocationCoordinate2DMake(39.255,-77.0725),
        CLLocationCoordinate2DMake(39.2551,-77.0717),
        CLLocationCoordinate2DMake(39.255,-77.0713),
        CLLocationCoordinate2DMake(39.2541,-77.0705),
        CLLocationCoordinate2DMake(39.2541,-77.0701),
        CLLocationCoordinate2DMake(39.254,-77.0699),
        CLLocationCoordinate2DMake(39.2537,-77.0697),
        CLLocationCoordinate2DMake(39.2533,-77.07),
        CLLocationCoordinate2DMake(39.2531,-77.07),
        CLLocationCoordinate2DMake(39.2526,-77.0696),
        CLLocationCoordinate2DMake(39.2525,-77.0692),
        CLLocationCoordinate2DMake(39.2529,-77.069),
        CLLocationCoordinate2DMake(39.253,-77.0687),
        CLLocationCoordinate2DMake(39.2526,-77.0683),
        CLLocationCoordinate2DMake(39.2523,-77.0683),
        CLLocationCoordinate2DMake(39.2519,-77.0674),
        CLLocationCoordinate2DMake(39.2516,-77.0673),
        CLLocationCoordinate2DMake(39.2516,-77.0663),
        CLLocationCoordinate2DMake(39.2512,-77.0661),
        CLLocationCoordinate2DMake(39.251,-77.0657),
        CLLocationCoordinate2DMake(39.2506,-77.0658),
        CLLocationCoordinate2DMake(39.2504,-77.0655),
        CLLocationCoordinate2DMake(39.2502,-77.0657),
        CLLocationCoordinate2DMake(39.2499,-77.0657),
        CLLocationCoordinate2DMake(39.2498,-77.0659),
        CLLocationCoordinate2DMake(39.2495,-77.0658),
        CLLocationCoordinate2DMake(39.2481,-77.0634),
        CLLocationCoordinate2DMake(39.2474,-77.0628),
        CLLocationCoordinate2DMake(39.2473,-77.0621),
        CLLocationCoordinate2DMake(39.247,-77.0622),
        CLLocationCoordinate2DMake(39.2467,-77.0625),
        CLLocationCoordinate2DMake(39.2465,-77.062),
        CLLocationCoordinate2DMake(39.2461,-77.0619),
        CLLocationCoordinate2DMake(39.2449,-77.061),
        CLLocationCoordinate2DMake(39.2444,-77.0611),
        CLLocationCoordinate2DMake(39.244,-77.0615),
        CLLocationCoordinate2DMake(39.2438,-77.0613),
        CLLocationCoordinate2DMake(39.2436,-77.0608),
        CLLocationCoordinate2DMake(39.2435,-77.0608),
        CLLocationCoordinate2DMake(39.2424,-77.061),
        CLLocationCoordinate2DMake(39.2418,-77.0616),
        CLLocationCoordinate2DMake(39.2416,-77.0617),
        CLLocationCoordinate2DMake(39.2412,-77.0614),
        CLLocationCoordinate2DMake(39.2404,-77.0603),
        CLLocationCoordinate2DMake(39.2402,-77.0601),
        CLLocationCoordinate2DMake(39.2401,-77.0597),
        CLLocationCoordinate2DMake(39.2405,-77.0589),
        CLLocationCoordinate2DMake(39.2403,-77.0584),
        CLLocationCoordinate2DMake(39.2403,-77.0578),
        CLLocationCoordinate2DMake(39.2402,-77.0576),
        CLLocationCoordinate2DMake(39.2392,-77.0571),
        CLLocationCoordinate2DMake(39.2383,-77.0557),
        CLLocationCoordinate2DMake(39.2384,-77.0552),
        CLLocationCoordinate2DMake(39.2388,-77.0542),
        CLLocationCoordinate2DMake(39.2389,-77.0534),
        CLLocationCoordinate2DMake(39.2387,-77.0527),
        CLLocationCoordinate2DMake(39.2379,-77.0513),
        CLLocationCoordinate2DMake(39.2377,-77.0504),
        CLLocationCoordinate2DMake(39.2376,-77.0495),
        CLLocationCoordinate2DMake(39.2378,-77.0472),
        CLLocationCoordinate2DMake(39.2377,-77.0461),
        CLLocationCoordinate2DMake(39.237,-77.0446),
        CLLocationCoordinate2DMake(39.2367,-77.0442),
        CLLocationCoordinate2DMake(39.2352,-77.0427),
        CLLocationCoordinate2DMake(39.2341,-77.0411),
        CLLocationCoordinate2DMake(39.2333,-77.0402),
        CLLocationCoordinate2DMake(39.2315,-77.0386),
        CLLocationCoordinate2DMake(39.2294,-77.0357),
        CLLocationCoordinate2DMake(39.2289,-77.0355),
        CLLocationCoordinate2DMake(39.2277,-77.0354),
        CLLocationCoordinate2DMake(39.226,-77.0344),
        CLLocationCoordinate2DMake(39.2255,-77.0338),
        CLLocationCoordinate2DMake(39.2248,-77.0324),
        CLLocationCoordinate2DMake(39.2243,-77.0319),
        CLLocationCoordinate2DMake(39.2233,-77.0319),
        CLLocationCoordinate2DMake(39.2214,-77.0324),
        CLLocationCoordinate2DMake(39.2207,-77.0321),
        CLLocationCoordinate2DMake(39.2181,-77.0274),
        CLLocationCoordinate2DMake(39.2161,-77.0246),
        CLLocationCoordinate2DMake(39.2111,-77.0183),
        CLLocationCoordinate2DMake(39.2091,-77.0164),
        CLLocationCoordinate2DMake(39.2084,-77.0154),
        CLLocationCoordinate2DMake(39.2078,-77.0136),
        CLLocationCoordinate2DMake(39.2073,-77.0125),
        CLLocationCoordinate2DMake(39.2069,-77.012),
        CLLocationCoordinate2DMake(39.2053,-77.0108),
        CLLocationCoordinate2DMake(39.2035,-77.0098),
        CLLocationCoordinate2DMake(39.2018,-77.0093),
        CLLocationCoordinate2DMake(39.2006,-77.0095),
        CLLocationCoordinate2DMake(39.1971,-77.0114),
        CLLocationCoordinate2DMake(39.1965,-77.0116),
        CLLocationCoordinate2DMake(39.1958,-77.0116),
        CLLocationCoordinate2DMake(39.1953,-77.0113),
        CLLocationCoordinate2DMake(39.1947,-77.0107),
        CLLocationCoordinate2DMake(39.1942,-77.0084),
        CLLocationCoordinate2DMake(39.1925,-77.0045),
        CLLocationCoordinate2DMake(39.1922,-77.0042),
        CLLocationCoordinate2DMake(39.1917,-77.0043),
        CLLocationCoordinate2DMake(39.1912,-77.0041),
        CLLocationCoordinate2DMake(39.1901,-77.0045),
        CLLocationCoordinate2DMake(39.1898,-77.0043),
        CLLocationCoordinate2DMake(39.1894,-77.0043),
        CLLocationCoordinate2DMake(39.1881,-77.0051),
        CLLocationCoordinate2DMake(39.1878,-77.0054),
        CLLocationCoordinate2DMake(39.187,-77.0055),
        CLLocationCoordinate2DMake(39.1863,-77.0058),
        CLLocationCoordinate2DMake(39.1861,-77.0062),
        CLLocationCoordinate2DMake(39.1855,-77.0064),
        CLLocationCoordinate2DMake(39.1853,-77.0067),
        CLLocationCoordinate2DMake(39.1849,-77.0075),
        CLLocationCoordinate2DMake(39.1837,-77.0075),
        CLLocationCoordinate2DMake(39.1831,-77.0077),
        CLLocationCoordinate2DMake(39.1827,-77.0076),
        CLLocationCoordinate2DMake(39.1825,-77.0081),
        CLLocationCoordinate2DMake(39.1819,-77.0085),
        CLLocationCoordinate2DMake(39.1816,-77.0084),
        CLLocationCoordinate2DMake(39.1807,-77.0079),
        CLLocationCoordinate2DMake(39.1802,-77.0073),
        CLLocationCoordinate2DMake(39.18,-77.0064),
        CLLocationCoordinate2DMake(39.1791,-77.0045),
        CLLocationCoordinate2DMake(39.179,-77.0041),
        CLLocationCoordinate2DMake(39.179,-77.0023),
        CLLocationCoordinate2DMake(39.1786,-77.0011),
        CLLocationCoordinate2DMake(39.1787,-77.0003),
        CLLocationCoordinate2DMake(39.1783,-76.9992),
        CLLocationCoordinate2DMake(39.1779,-76.9989),
        CLLocationCoordinate2DMake(39.1775,-76.9989),
        CLLocationCoordinate2DMake(39.177,-76.9997),
        CLLocationCoordinate2DMake(39.1765,-77.0017),
        CLLocationCoordinate2DMake(39.1761,-77.0026),
        CLLocationCoordinate2DMake(39.1763,-77.0039),
        CLLocationCoordinate2DMake(39.1762,-77.0054),
        CLLocationCoordinate2DMake(39.176,-77.0055),
        CLLocationCoordinate2DMake(39.1749,-77.0048),
        CLLocationCoordinate2DMake(39.1743,-77.0046),
        CLLocationCoordinate2DMake(39.1742,-77.0037),
        CLLocationCoordinate2DMake(39.1742,-77.0027),
        CLLocationCoordinate2DMake(39.1751,-76.9986),
        CLLocationCoordinate2DMake(39.1751,-76.9983),
        CLLocationCoordinate2DMake(39.1742,-76.9973),
        CLLocationCoordinate2DMake(39.1739,-76.9975),
        CLLocationCoordinate2DMake(39.1733,-76.9987),
        CLLocationCoordinate2DMake(39.1719,-76.9999),
        CLLocationCoordinate2DMake(39.1711,-77.0011),
        CLLocationCoordinate2DMake(39.1704,-77.0014),
        CLLocationCoordinate2DMake(39.1698,-77.0012),
        CLLocationCoordinate2DMake(39.1682,-76.999),
        CLLocationCoordinate2DMake(39.1664,-76.9971),
        CLLocationCoordinate2DMake(39.1664,-76.996),
        CLLocationCoordinate2DMake(39.1668,-76.9941),
        CLLocationCoordinate2DMake(39.1664,-76.9931),
        CLLocationCoordinate2DMake(39.1666,-76.9907),
        CLLocationCoordinate2DMake(39.1664,-76.9875),
        CLLocationCoordinate2DMake(39.1658,-76.986),
        CLLocationCoordinate2DMake(39.1655,-76.9834),
        CLLocationCoordinate2DMake(39.1643,-76.9819),
        CLLocationCoordinate2DMake(39.1644,-76.9808),
        CLLocationCoordinate2DMake(39.1643,-76.9804),
        CLLocationCoordinate2DMake(39.1637,-76.9799),
        CLLocationCoordinate2DMake(39.1637,-76.9785),
        CLLocationCoordinate2DMake(39.1632,-76.9782),
        CLLocationCoordinate2DMake(39.1629,-76.9777),
        CLLocationCoordinate2DMake(39.1631,-76.9763),
        CLLocationCoordinate2DMake(39.1633,-76.9753),
        CLLocationCoordinate2DMake(39.1619,-76.9731),
        CLLocationCoordinate2DMake(39.1616,-76.9728),
        CLLocationCoordinate2DMake(39.1597,-76.9737),
        CLLocationCoordinate2DMake(39.1585,-76.9738),
        CLLocationCoordinate2DMake(39.1541,-76.9767),
        CLLocationCoordinate2DMake(39.1534,-76.9766),
        CLLocationCoordinate2DMake(39.152,-76.9767),
        CLLocationCoordinate2DMake(39.1509,-76.976),
        CLLocationCoordinate2DMake(39.1499,-76.9757),
        CLLocationCoordinate2DMake(39.1495,-76.9754),
        CLLocationCoordinate2DMake(39.1495,-76.9733),
        CLLocationCoordinate2DMake(39.1489,-76.9709),
        CLLocationCoordinate2DMake(39.1485,-76.9688),
        CLLocationCoordinate2DMake(39.1487,-76.9666),
        CLLocationCoordinate2DMake(39.1485,-76.9648),
        CLLocationCoordinate2DMake(39.1484,-76.9644),
        CLLocationCoordinate2DMake(39.148,-76.9639),
        CLLocationCoordinate2DMake(39.146,-76.963),
        CLLocationCoordinate2DMake(39.1456,-76.9627),
        CLLocationCoordinate2DMake(39.1456,-76.9611),
        CLLocationCoordinate2DMake(39.145,-76.9589),
        CLLocationCoordinate2DMake(39.1446,-76.9556),
        CLLocationCoordinate2DMake(39.1455,-76.9543),
        CLLocationCoordinate2DMake(39.1458,-76.9536),
        CLLocationCoordinate2DMake(39.1463,-76.9521),
        CLLocationCoordinate2DMake(39.1462,-76.9517),
        CLLocationCoordinate2DMake(39.1447,-76.9504),
        CLLocationCoordinate2DMake(39.1439,-76.9499),
        CLLocationCoordinate2DMake(39.1435,-76.95),
        CLLocationCoordinate2DMake(39.1433,-76.9503),
        CLLocationCoordinate2DMake(39.1432,-76.9519),
        CLLocationCoordinate2DMake(39.1429,-76.9527),
        CLLocationCoordinate2DMake(39.1426,-76.9529),
        CLLocationCoordinate2DMake(39.1423,-76.953),
        CLLocationCoordinate2DMake(39.1415,-76.9524),
        CLLocationCoordinate2DMake(39.1395,-76.9522),
        CLLocationCoordinate2DMake(39.1392,-76.9523),
        CLLocationCoordinate2DMake(39.1389,-76.9529),
        CLLocationCoordinate2DMake(39.1388,-76.9538),
        CLLocationCoordinate2DMake(39.1385,-76.9549),
        CLLocationCoordinate2DMake(39.1379,-76.9559),
        CLLocationCoordinate2DMake(39.1349,-76.9585),
        CLLocationCoordinate2DMake(39.1342,-76.9587),
        CLLocationCoordinate2DMake(39.1337,-76.9582),
        CLLocationCoordinate2DMake(39.133,-76.9563),
        CLLocationCoordinate2DMake(39.1325,-76.9555),
        CLLocationCoordinate2DMake(39.1322,-76.9545),
        CLLocationCoordinate2DMake(39.1308,-76.9519),
        CLLocationCoordinate2DMake(39.1293,-76.9483),
        CLLocationCoordinate2DMake(39.1294,-76.9469),
        CLLocationCoordinate2DMake(39.1295,-76.9459),
        CLLocationCoordinate2DMake(39.1297,-76.9457),
        CLLocationCoordinate2DMake(39.1307,-76.9448),
        CLLocationCoordinate2DMake(39.1322,-76.9437),
        CLLocationCoordinate2DMake(39.1325,-76.9433),
        CLLocationCoordinate2DMake(39.1328,-76.9421),
        CLLocationCoordinate2DMake(39.1328,-76.941),
        CLLocationCoordinate2DMake(39.1324,-76.9402),
        CLLocationCoordinate2DMake(39.1323,-76.9397),
        CLLocationCoordinate2DMake(39.1329,-76.9381),
        CLLocationCoordinate2DMake(39.1338,-76.9361),
        CLLocationCoordinate2DMake(39.1344,-76.9353),
        CLLocationCoordinate2DMake(39.1362,-76.9342),
        CLLocationCoordinate2DMake(39.1374,-76.931),
        CLLocationCoordinate2DMake(39.1384,-76.9291),
        CLLocationCoordinate2DMake(39.1386,-76.9283),
        CLLocationCoordinate2DMake(39.1383,-76.9278),
        CLLocationCoordinate2DMake(39.1373,-76.9276),
        CLLocationCoordinate2DMake(39.1348,-76.9264),
        CLLocationCoordinate2DMake(39.1347,-76.926),
        CLLocationCoordinate2DMake(39.1348,-76.9254),
        CLLocationCoordinate2DMake(39.1348,-76.9251),
        CLLocationCoordinate2DMake(39.1335,-76.9235),
        CLLocationCoordinate2DMake(39.1332,-76.9215),
        CLLocationCoordinate2DMake(39.1323,-76.9191),
        CLLocationCoordinate2DMake(39.1319,-76.9185),
        CLLocationCoordinate2DMake(39.1299,-76.9173),
        CLLocationCoordinate2DMake(39.1292,-76.9165),
        CLLocationCoordinate2DMake(39.1283,-76.9159),
        CLLocationCoordinate2DMake(39.1268,-76.9154),
        CLLocationCoordinate2DMake(39.1265,-76.9152),
        CLLocationCoordinate2DMake(39.1264,-76.915),
        CLLocationCoordinate2DMake(39.1268,-76.9123),
        CLLocationCoordinate2DMake(39.1263,-76.9093),
        CLLocationCoordinate2DMake(39.1253,-76.9066),
        CLLocationCoordinate2DMake(39.1252,-76.9052),
        CLLocationCoordinate2DMake(39.1254,-76.9039),
        CLLocationCoordinate2DMake(39.1261,-76.9017),
        CLLocationCoordinate2DMake(39.1265,-76.8987),
        CLLocationCoordinate2DMake(39.1272,-76.8963),
        CLLocationCoordinate2DMake(39.1281,-76.8939),
        CLLocationCoordinate2DMake(39.1287,-76.8927),
        CLLocationCoordinate2DMake(39.1313,-76.8895),
        CLLocationCoordinate2DMake(39.1318,-76.8885),
        CLLocationCoordinate2DMake(39.1319,-76.8874),
        CLLocationCoordinate2DMake(39.1319,-76.8863),
        CLLocationCoordinate2DMake(39.1316,-76.8855),
        CLLocationCoordinate2DMake(39.1313,-76.8851),
        CLLocationCoordinate2DMake(39.1308,-76.8849),
        CLLocationCoordinate2DMake(39.1292,-76.8851),
        CLLocationCoordinate2DMake(39.1283,-76.8848),
        CLLocationCoordinate2DMake(39.1272,-76.8843),
        CLLocationCoordinate2DMake(39.1262,-76.8836),
        CLLocationCoordinate2DMake(39.1252,-76.8825),
        CLLocationCoordinate2DMake(39.1242,-76.8811),
        CLLocationCoordinate2DMake(39.1224,-76.8795),
        CLLocationCoordinate2DMake(39.1201,-76.877),
        CLLocationCoordinate2DMake(39.1187,-76.876),
        CLLocationCoordinate2DMake(39.117,-76.8751),
        CLLocationCoordinate2DMake(39.1167,-76.8749),
        CLLocationCoordinate2DMake(39.1163,-76.8743),
        CLLocationCoordinate2DMake(39.1146,-76.8729),
        CLLocationCoordinate2DMake(39.1141,-76.8714),
        CLLocationCoordinate2DMake(39.1141,-76.8709),
        CLLocationCoordinate2DMake(39.1126,-76.8701),
        CLLocationCoordinate2DMake(39.1121,-76.8687),
        CLLocationCoordinate2DMake(39.1108,-76.8637),
        CLLocationCoordinate2DMake(39.1103,-76.8629),
        CLLocationCoordinate2DMake(39.1104,-76.8617),
        CLLocationCoordinate2DMake(39.1107,-76.861),
        CLLocationCoordinate2DMake(39.1105,-76.8589),
        CLLocationCoordinate2DMake(39.1105,-76.8574),
        CLLocationCoordinate2DMake(39.1107,-76.8566),
        CLLocationCoordinate2DMake(39.1104,-76.8557),
        CLLocationCoordinate2DMake(39.11,-76.8551),
        CLLocationCoordinate2DMake(39.1099,-76.8544),
        CLLocationCoordinate2DMake(39.11,-76.8539),
        CLLocationCoordinate2DMake(39.1097,-76.8527),
        CLLocationCoordinate2DMake(39.1091,-76.8517),
        CLLocationCoordinate2DMake(39.1089,-76.851),
        CLLocationCoordinate2DMake(39.1092,-76.8496),
        CLLocationCoordinate2DMake(39.1091,-76.849),
        CLLocationCoordinate2DMake(39.1087,-76.8482),
        CLLocationCoordinate2DMake(39.1081,-76.8477),
        CLLocationCoordinate2DMake(39.108,-76.8461),
        CLLocationCoordinate2DMake(39.1075,-76.8447),
        CLLocationCoordinate2DMake(39.1069,-76.8433),
        CLLocationCoordinate2DMake(39.1063,-76.8426),
        CLLocationCoordinate2DMake(39.1058,-76.8415),
        CLLocationCoordinate2DMake(39.1053,-76.841),
        CLLocationCoordinate2DMake(39.1047,-76.8409),
        CLLocationCoordinate2DMake(39.1043,-76.8411),
        CLLocationCoordinate2DMake(39.104,-76.8411),
        CLLocationCoordinate2DMake(39.1036,-76.8409),
        CLLocationCoordinate2DMake(39.1031,-76.8404),
        CLLocationCoordinate2DMake(39.104,-76.8388),
        CLLocationCoordinate2DMake(39.1048,-76.8369),
        CLLocationCoordinate2DMake(39.1065,-76.8306),
        CLLocationCoordinate2DMake(39.1071,-76.8294),
        CLLocationCoordinate2DMake(39.1079,-76.8282),
        CLLocationCoordinate2DMake(39.1092,-76.827),
        CLLocationCoordinate2DMake(39.1107,-76.8263),
        CLLocationCoordinate2DMake(39.1117,-76.8261),
        CLLocationCoordinate2DMake(39.1144,-76.826),
        CLLocationCoordinate2DMake(39.116,-76.8255),
        CLLocationCoordinate2DMake(39.1176,-76.8242),
        CLLocationCoordinate2DMake(39.1184,-76.8231),
        CLLocationCoordinate2DMake(39.119,-76.822),
        CLLocationCoordinate2DMake(39.1219,-76.8148),
        CLLocationCoordinate2DMake(39.1225,-76.813),
        CLLocationCoordinate2DMake(39.1228,-76.8115),
        CLLocationCoordinate2DMake(39.123,-76.8096),
        CLLocationCoordinate2DMake(39.123,-76.808),
        CLLocationCoordinate2DMake(39.1228,-76.8065),
        CLLocationCoordinate2DMake(39.1223,-76.8035),
        CLLocationCoordinate2DMake(39.1221,-76.8016),
        CLLocationCoordinate2DMake(39.1223,-76.7992),
        CLLocationCoordinate2DMake(39.1226,-76.7969),
        CLLocationCoordinate2DMake(39.1232,-76.7948),
        CLLocationCoordinate2DMake(39.1239,-76.7932),
        CLLocationCoordinate2DMake(39.125,-76.7911),
        CLLocationCoordinate2DMake(39.1262,-76.7894),
        CLLocationCoordinate2DMake(39.1276,-76.7879),
        CLLocationCoordinate2DMake(39.1289,-76.7868),
        CLLocationCoordinate2DMake(39.1303,-76.7859),
        CLLocationCoordinate2DMake(39.1318,-76.7852),
        CLLocationCoordinate2DMake(39.1337,-76.7847),
        CLLocationCoordinate2DMake(39.1401,-76.784),
        CLLocationCoordinate2DMake(39.1426,-76.7832),
        CLLocationCoordinate2DMake(39.1448,-76.7819),
        CLLocationCoordinate2DMake(39.1616,-76.7677),
        CLLocationCoordinate2DMake(39.1662,-76.7637),
        CLLocationCoordinate2DMake(39.168,-76.7616),
        CLLocationCoordinate2DMake(39.1693,-76.7596),
        CLLocationCoordinate2DMake(39.1718,-76.7545),
        CLLocationCoordinate2DMake(39.1734,-76.752),
        CLLocationCoordinate2DMake(39.1756,-76.7496),
        CLLocationCoordinate2DMake(39.1795,-76.7464),
        CLLocationCoordinate2DMake(39.1792,-76.7451),
        CLLocationCoordinate2DMake(39.1794,-76.7448),
        CLLocationCoordinate2DMake(39.1792,-76.7444),
        CLLocationCoordinate2DMake(39.1793,-76.7441),
        CLLocationCoordinate2DMake(39.1791,-76.7437),
        CLLocationCoordinate2DMake(39.1794,-76.7434),
        CLLocationCoordinate2DMake(39.1792,-76.743),
        CLLocationCoordinate2DMake(39.1795,-76.7425),
        CLLocationCoordinate2DMake(39.1796,-76.7418),
        CLLocationCoordinate2DMake(39.1793,-76.7405),
        CLLocationCoordinate2DMake(39.1791,-76.74),
        CLLocationCoordinate2DMake(39.1791,-76.7397),
        CLLocationCoordinate2DMake(39.1789,-76.7391),
        CLLocationCoordinate2DMake(39.179,-76.7389),
        CLLocationCoordinate2DMake(39.1792,-76.739),
        CLLocationCoordinate2DMake(39.1794,-76.7387),
        CLLocationCoordinate2DMake(39.1795,-76.7382),
        CLLocationCoordinate2DMake(39.1798,-76.7376),
        CLLocationCoordinate2DMake(39.1798,-76.7369),
        CLLocationCoordinate2DMake(39.1801,-76.7361),
        CLLocationCoordinate2DMake(39.1799,-76.7357),
        CLLocationCoordinate2DMake(39.1801,-76.7354),
        CLLocationCoordinate2DMake(39.1803,-76.7354),
        CLLocationCoordinate2DMake(39.1805,-76.735),
        CLLocationCoordinate2DMake(39.1807,-76.7341),
        CLLocationCoordinate2DMake(39.1814,-76.7337),
        CLLocationCoordinate2DMake(39.1814,-76.7329),
        CLLocationCoordinate2DMake(39.1816,-76.7324),
        CLLocationCoordinate2DMake(39.1818,-76.7325),
        CLLocationCoordinate2DMake(39.1824,-76.7316),
        CLLocationCoordinate2DMake(39.1828,-76.731),
        CLLocationCoordinate2DMake(39.1829,-76.7304),
        CLLocationCoordinate2DMake(39.1836,-76.73),
        CLLocationCoordinate2DMake(39.1838,-76.7295),
        CLLocationCoordinate2DMake(39.1836,-76.7289),
        CLLocationCoordinate2DMake(39.1836,-76.7284),
        CLLocationCoordinate2DMake(39.1838,-76.7283),
        CLLocationCoordinate2DMake(39.184,-76.7284),
        CLLocationCoordinate2DMake(39.1842,-76.7279),
        CLLocationCoordinate2DMake(39.1841,-76.7277),
        CLLocationCoordinate2DMake(39.1837,-76.7277),
        CLLocationCoordinate2DMake(39.1834,-76.7273),
        CLLocationCoordinate2DMake(39.1837,-76.7261),
        CLLocationCoordinate2DMake(39.1835,-76.7261),
        CLLocationCoordinate2DMake(39.1835,-76.7252),
        CLLocationCoordinate2DMake(39.1832,-76.7242),
        CLLocationCoordinate2DMake(39.1831,-76.7233),
        CLLocationCoordinate2DMake(39.1827,-76.7225),
        CLLocationCoordinate2DMake(39.1829,-76.7217),
        CLLocationCoordinate2DMake(39.1831,-76.7216),
        CLLocationCoordinate2DMake(39.1835,-76.7222),
        CLLocationCoordinate2DMake(39.1838,-76.7222),
        CLLocationCoordinate2DMake(39.1846,-76.7213),
        CLLocationCoordinate2DMake(39.1857,-76.7215),
        CLLocationCoordinate2DMake(39.1859,-76.7211),
        CLLocationCoordinate2DMake(39.1863,-76.7211),
        CLLocationCoordinate2DMake(39.1868,-76.7202),
        CLLocationCoordinate2DMake(39.1871,-76.72),
        CLLocationCoordinate2DMake(39.1876,-76.7203),
        CLLocationCoordinate2DMake(39.1875,-76.7206),
        CLLocationCoordinate2DMake(39.1877,-76.7209),
        CLLocationCoordinate2DMake(39.1885,-76.7212),
        CLLocationCoordinate2DMake(39.1895,-76.721),
        CLLocationCoordinate2DMake(39.1896,-76.7207),
        CLLocationCoordinate2DMake(39.1896,-76.72),
        CLLocationCoordinate2DMake(39.1903,-76.7195),
        CLLocationCoordinate2DMake(39.1916,-76.7192),
        CLLocationCoordinate2DMake(39.1917,-76.7189),
        CLLocationCoordinate2DMake(39.1917,-76.7181),
        CLLocationCoordinate2DMake(39.1914,-76.7174),
        CLLocationCoordinate2DMake(39.1918,-76.7171),
        CLLocationCoordinate2DMake(39.1917,-76.7163),
        CLLocationCoordinate2DMake(39.1918,-76.7161),
        CLLocationCoordinate2DMake(39.1917,-76.716),
        CLLocationCoordinate2DMake(39.192,-76.7156),
        CLLocationCoordinate2DMake(39.1921,-76.7151),
        CLLocationCoordinate2DMake(39.1923,-76.715),
        CLLocationCoordinate2DMake(39.1926,-76.7144),
        CLLocationCoordinate2DMake(39.1929,-76.7142),
        CLLocationCoordinate2DMake(39.1932,-76.7132),
        CLLocationCoordinate2DMake(39.1934,-76.7132),
        CLLocationCoordinate2DMake(39.1938,-76.7137),
        CLLocationCoordinate2DMake(39.194,-76.7136),
        CLLocationCoordinate2DMake(39.1941,-76.714),
        CLLocationCoordinate2DMake(39.1944,-76.7142),
        CLLocationCoordinate2DMake(39.1947,-76.7139),
        CLLocationCoordinate2DMake(39.1946,-76.7135),
        CLLocationCoordinate2DMake(39.1947,-76.7132),
        CLLocationCoordinate2DMake(39.1953,-76.7135),
        CLLocationCoordinate2DMake(39.1955,-76.7134),
        CLLocationCoordinate2DMake(39.1955,-76.7129),
        CLLocationCoordinate2DMake(39.1961,-76.7132),
        CLLocationCoordinate2DMake(39.1965,-76.7125),
        CLLocationCoordinate2DMake(39.197,-76.7125),
        CLLocationCoordinate2DMake(39.1974,-76.712),
        CLLocationCoordinate2DMake(39.1977,-76.7119),
        CLLocationCoordinate2DMake(39.1988,-76.7124),
        CLLocationCoordinate2DMake(39.1995,-76.7122),
        CLLocationCoordinate2DMake(39.1995,-76.7126),
        CLLocationCoordinate2DMake(39.1997,-76.7127),
        CLLocationCoordinate2DMake(39.2003,-76.7123),
        CLLocationCoordinate2DMake(39.201,-76.7125),
        CLLocationCoordinate2DMake(39.2018,-76.7124),
        CLLocationCoordinate2DMake(39.2021,-76.7119),
        CLLocationCoordinate2DMake(39.2018,-76.7115),
        CLLocationCoordinate2DMake(39.2019,-76.7108),
        CLLocationCoordinate2DMake(39.2022,-76.7106),
        CLLocationCoordinate2DMake(39.2026,-76.7099),
        CLLocationCoordinate2DMake(39.2026,-76.7093),
        CLLocationCoordinate2DMake(39.203,-76.7088),
        CLLocationCoordinate2DMake(39.203,-76.7083),
        CLLocationCoordinate2DMake(39.2031,-76.7079),
        CLLocationCoordinate2DMake(39.2037,-76.7075),
        CLLocationCoordinate2DMake(39.2044,-76.7079),
        CLLocationCoordinate2DMake(39.2046,-76.7081),
        CLLocationCoordinate2DMake(39.205,-76.7081),
        CLLocationCoordinate2DMake(39.2053,-76.7081),
        CLLocationCoordinate2DMake(39.2053,-76.7076),
        CLLocationCoordinate2DMake(39.2056,-76.7073),
        CLLocationCoordinate2DMake(39.2061,-76.7075),
        CLLocationCoordinate2DMake(39.2062,-76.7069),
        CLLocationCoordinate2DMake(39.2061,-76.7063),
        CLLocationCoordinate2DMake(39.2063,-76.7062),
        CLLocationCoordinate2DMake(39.2062,-76.7066),
        CLLocationCoordinate2DMake(39.2063,-76.7067),
        CLLocationCoordinate2DMake(39.2067,-76.7064),
        CLLocationCoordinate2DMake(39.2068,-76.706),
        CLLocationCoordinate2DMake(39.2067,-76.7055),
        CLLocationCoordinate2DMake(39.2068,-76.705),
        CLLocationCoordinate2DMake(39.2073,-76.7046),
        CLLocationCoordinate2DMake(39.2079,-76.7048),
        CLLocationCoordinate2DMake(39.2081,-76.7048),
        CLLocationCoordinate2DMake(39.2083,-76.7044),
        CLLocationCoordinate2DMake(39.2085,-76.7049),
        CLLocationCoordinate2DMake(39.2091,-76.7048),
        CLLocationCoordinate2DMake(39.2096,-76.7041),
        CLLocationCoordinate2DMake(39.21,-76.7039),
        CLLocationCoordinate2DMake(39.21,-76.7036),
        CLLocationCoordinate2DMake(39.2102,-76.7034),
        CLLocationCoordinate2DMake(39.2104,-76.7028),
        CLLocationCoordinate2DMake(39.2111,-76.7018),
        CLLocationCoordinate2DMake(39.2118,-76.7013),
        CLLocationCoordinate2DMake(39.2122,-76.7012),
        CLLocationCoordinate2DMake(39.2124,-76.7009),
        CLLocationCoordinate2DMake(39.2124,-76.7003),
        CLLocationCoordinate2DMake(39.2121,-76.6998),
        CLLocationCoordinate2DMake(39.2123,-76.6992),
        CLLocationCoordinate2DMake(39.2122,-76.6986),
        CLLocationCoordinate2DMake(39.2119,-76.6981),
        CLLocationCoordinate2DMake(39.212,-76.6975),
        CLLocationCoordinate2DMake(39.2124,-76.6966),
        CLLocationCoordinate2DMake(39.2133,-76.6964)
    };
    
    MKPolygon *boundPoly1 = [MKPolygon polygonWithCoordinates:boundCoords count:1517];
    [self.mapView addOverlay:boundPoly1];
    
    self.navigationItem.title = @"Detail";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc]initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(addNewIssue)];
    newButton.tintColor = [UIColor blueColor];
    [self.navigationItem setRightBarButtonItem:newButton];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time:) userInfo:nil repeats:YES];
    
    //UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(openSocial)];
    //[self.navigationItem setRightBarButtonItem:shareButton];
    
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

- (void)addNewIssue {
    NewIssueViewController *newVC = [[NewIssueViewController alloc]init];
    newVC.emailItem = emailItem;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[self navigationController]pushViewController:newVC animated:YES];
}

-(void)start {
    NSLog(@"%@",idItem);
    NSString *str1 = @"http://data.howardcountymd.gov/iOStellHC/getInfoByID.asp";
    NSString *str2 = [NSString stringWithFormat:@"%@?id=%@", str1,idItem];
    NSURL *url = [NSURL URLWithString:str2];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self getData:data];
}

-(void) getData:(NSData *) data {
    NSError *error;
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    [self configureView];
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay{
    if([overlay isKindOfClass:[MKPolygon class]]){
        MKPolygonView *polyView = [[MKPolygonView alloc] initWithOverlay:overlay];
        polyView.lineWidth=2;
        polyView.strokeColor=[UIColor colorWithRed:0 green:64/255 blue:0 alpha:1];
        polyView.fillColor=[[UIColor greenColor] colorWithAlphaComponent:0];
        return polyView;
    }
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor redColor];
        circleView.lineWidth = 1;
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        return circleView;
    }
    return nil;
}

#pragma mark - Managing the detail item

- (void)configureView
{
    for (NSDictionary *info in json) {
        self.categoryItem = [info objectForKey:@"Category"];
        self.incidentItem = [info objectForKey:@"Incident"];
        self.statusItem = [info objectForKey:@"Status"];
        self.descriptionText.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"information"]];
        self.FSimageItem1 = [info objectForKey:@"Fullsize_Image1"];
        self.FSimageItem2 = [info objectForKey:@"Fullsize_Image2"];
        self.FSimageItem3 = [info objectForKey:@"Fullsize_Image3"];
        self.FSimageItem4 = [info objectForKey:@"Fullsize_Image4"];
        self.FSimageItem5 = [info objectForKey:@"Fullsize_Image5"];
        self.FSimageItem6 = [info objectForKey:@"Fullsize_Image6"];
        self.FSimageItem7 = [info objectForKey:@"Fullsize_Image7"];
        self.FSimageItem8 = [info objectForKey:@"Fullsize_Image8"];
        self.FSimageItem9 = [info objectForKey:@"Fullsize_Image9"];
        self.FSimageItem10 = [info objectForKey:@"Fullsize_Image10"];
        self.latItem = [[info objectForKey:@"Y"]doubleValue];
        self.lngItem = [[info objectForKey:@"X"]doubleValue];
    }

    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",categoryItem]];
    
    NSString *dataString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@", FSimageItem1,FSimageItem2,FSimageItem3,FSimageItem4,FSimageItem5,FSimageItem6,FSimageItem7,FSimageItem8,FSimageItem9,FSimageItem10];
    NSString *cleanedStr=[dataString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    int imageLength=[cleanedStr length];
    NSLog(@"%i", imageLength);
    
    imageData = [NSData dataFromBase64String:cleanedStr];
    image = [UIImage imageWithData:imageData];
    [imageView setImage:image];
    
    imageView.hidden = NO;
    
    /*
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:latItem longitude:lngItem];
    
    //Geocoding Block
    [self.geoCoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //Get nearby address
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        //String to hold address
        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        
        //Print the location to console
        //NSLog(@"I am currently at %@",locatedAt);
        
        //Set the label text to current location
        locationText.text = [NSString stringWithFormat:@"%@",locatedAt];
        
    }];
    */
}

//for when the view come back, we have to reset the timer
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.descriptionText = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setDisplay:(id)sender {
    switch(((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            imageView.hidden = NO;
            self.descriptionText.hidden = YES;
            self.mapView.hidden = YES;
            self.mapTypeSegment.hidden = YES;
            break;
            default:
        case 1:
            imageView.hidden = YES;
            self.descriptionText.hidden = NO;
            self.mapView.hidden = YES;
            self.mapTypeSegment.hidden = YES;
            break;
        case 2:
            imageView.hidden = YES;
            self.descriptionText.hidden = NO;
            self.mapView.hidden = NO;
            self.mapTypeSegment.hidden = NO;
            [self removeAllAnnotations];
            [self setPin];
            break;
    }
}

-(void)removeAllAnnotations
{
    id userAnnotation = self.mapView.userLocation;
    
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    
    [self.mapView removeAnnotations:annotations];
}

- (void)setPin {
    
    MKCoordinateRegion region = {{0.0, 0.0},{0.0, 0.0}};
    CLLocationCoordinate2D location;
    location.latitude = latItem;
    location.longitude = lngItem;
    Annotation *ann = [[Annotation alloc] init];
    ann.title = self.categoryItem;
    ann.subtitle = self.incidentItem;
    ann.coordinate = location;
    [mapView addAnnotation:ann];
    
    region.center.latitude = latItem;
    region.center.longitude = lngItem;
    region.span.latitudeDelta = 0.1f;
    region.span.longitudeDelta = 0.1f;
    [mapView setRegion:region animated:YES];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[Annotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString *annotationIdentifier = @"AnnotationIdentifier";
        MKAnnotationView *pinView = (MKAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView)
        {

             MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
             reuseIdentifier:annotationIdentifier];
            if ([statusItem isEqualToString:@"Acknowledged"]) {
                annotationView.pinColor = MKPinAnnotationColorRed;
            } else if ([statusItem isEqualToString:@"Work In Progress"]) {
                annotationView.pinColor = MKPinAnnotationColorPurple;
            } else if ([statusItem isEqualToString:@"Completed"]) {
                annotationView.pinColor = MKPinAnnotationColorGreen;
            }
            
             annotationView.animatesDrop = YES;
             annotationView.canShowCallout = YES;
            
            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)openSocial {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"FaceBook",@"Twitter",nil];
    [actionSheet showFromToolbar:(UIToolbar *)myToolBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self getFB];
    }
    else if (buttonIndex==1) {
        [self getTW];
    }
}

-(void)getFB {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController addImage:[UIImage imageWithData:imageData]];
        [slComposeViewController addURL:[NSURL URLWithString:@"http://data.howardcountymd.gov"]];
        [self presentViewController:slComposeViewController animated:YES completion:NULL];
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"No Facebook Account" message:@"There are no facebook accounts configured. You can add or create a facebook account in settings" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getTW {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposeViewController addImage:[UIImage imageWithData:imageData]];
        [slComposeViewController addURL:[NSURL URLWithString:@"http://data.howardcountymd.gov"]];
        [self presentViewController:slComposeViewController animated:YES completion:NULL];
    }
    else {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"No Twitter Account" message:@"There are no Twitter accounts configured, to configure a Twitter Account go to Setings" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)setMapType:(id)sender {
    switch(((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}
@end
