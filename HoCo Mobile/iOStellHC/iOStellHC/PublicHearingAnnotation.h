//
//  PublicHearingAnnotation.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/16/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface PublicHearingAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (assign) double latItem;
@property (assign) double lngItem;
@property (nonatomic, copy) NSString *idItem;

@end
