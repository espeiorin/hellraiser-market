//
//  Product.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brand;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * descriptionProduct;
@property (nonatomic, retain) NSNumber * featured;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * snapshot;
@property (nonatomic, retain) Brand *brand;

@end
