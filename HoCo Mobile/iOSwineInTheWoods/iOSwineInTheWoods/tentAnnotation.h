//
//  tentAnnotation.h
//  iOSwineInTheWoods
//
//  Created by Yongyuth Phasukyued on 4/26/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface tentAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSString *urltitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *urltitle;


@end
