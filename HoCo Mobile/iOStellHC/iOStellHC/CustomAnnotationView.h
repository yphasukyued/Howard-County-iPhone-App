//
//  CustomAnnotationView.h
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/15/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotationView : MKAnnotationView  {

}

- (id)initWithAnnotationWithImage:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier annotationViewImage:(UIImage *)annoViewImage;


@end
