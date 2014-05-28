//
//  UIImage+HRImage.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (HRImage)

+ (UIImage *)changeWhiteColorTransparent: (UIImage *)image;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *) convertToGreyscale:(UIImage *)i;

@end
