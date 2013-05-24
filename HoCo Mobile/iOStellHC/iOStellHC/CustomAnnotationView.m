//
//  CustomAnnotationView.m
//  iOStellHC
//
//  Created by Yongyuth Phasukyued on 1/15/13.
//  Copyright (c) 2013 Howard County. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithAnnotationWithImage:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier annotationViewImage:(UIImage *)annoViewImage; {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.image = annoViewImage;
    return self;
    
}

@end
