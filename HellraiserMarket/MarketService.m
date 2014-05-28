//
//  MarketService.m
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import "MarketService.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Brand.h"
#import "Product.h"

@implementation MarketService{
    CoreDataHelper *cdh;
    AppDelegate *mainDelegate;
}

- (id) init{
    self = [super init];
    if (self) {
        mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        cdh = [mainDelegate cdh];
    }
    return self;
}

- (void) loadData:(ResultBlock)block{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    if([mainDelegate hasInternetConnection]){
        [self loadDataRemote:block];
    }
    [self loadDataLocal:block];
}

- (BOOL) databaseIsEmpty{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Brand"];
    NSError *error = nil;
    NSArray *fetchedBrands = [cdh.context executeFetchRequest:request error:&error];
    if (fetchedBrands.count != 0){
        return NO;
    }
    
    return YES;
}

- (void) loadDataRemote:(ResultBlock)block{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    /*
     Content-type: application/x-www-form-urlencoded
     Authorization: 85e4a615f62c711d3aac0e7def5b4903
     
    [
     {
         "id": 1,
         "created": "2012-06-20T10:55:27-0300",
         "image": "http://upload.wikimedia.org/wikipedia/en/thumb/9/9f/Apple-logo.svg/125px-Apple-logo.svg.png",
         "name": "Apple",
         "description": "Apple Inc. é uma empresa multinacional norte-americana que tem o objetivo de projetar e comercializar produtos eletrônicos de consumo, software de computador e computadores pessoais",
         "product_collection": [
                                {
                                    "id": 1,
                                    "created": "2012-06-20T10:57:52-0300",
                                    "description": "iPhone 4",
                                    "featured": true,
                                    "price": 1400,
                                    "status": 1,
                                    "snapshot": "http://km.support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT3939/HT3939-iphone_4-side_front_dimensions-001-en.png"
                                },
                                {
                                    "id": 2,
                                    "created": "2012-06-20T10:58:50-0300",
                                    "description": "iPad",
                                    "featured": true,
                                    "price": 1600,
                                    "status": 1,
                                    "snapshot": "http://www.zurb.com/playground/playground/ipad-stencil/ipad-normal.jpg"
                                }
                                ]
     },
     {
         "id": 2,
         "created": "2012-06-20T10:56:05-0300",
         "image": "http://images.dailytech.com/nimage/samsung-logo.jpg",
         "name": "Samsung",
         "description": "O grupo Samsung é uma corporação multinacional que atua em diversos ramos da área de tecnologia da informação com sede em Seul, Coreia do Sul",
         "product_collection": [
                                {
                                    "id": 3,
                                    "created": "2012-06-20T11:04:40-0300",
                                    "description": "Galaxy Tab",
                                    "featured": true,
                                    "price": 1650,
                                    "status": 1,
                                    "snapshot": "http://static.guim.co.uk/sys-images/Technology/Pix/pictures/2010/9/2/1283427691059/Galaxy-Tab-001.jpg"
                                },
                                {
                                    "id": 4,
                                    "created": "2012-06-20T11:05:34-0300",
                                    "description": "Galaxy S3",
                                    "featured": true,
                                    "price": 1150,
                                    "status": 1,
                                    "snapshot": "http://cdn9.mos.techradar.com///art/mobile_phones/Samsung/GalaxyS3/Galaxy%20Fire/Samsung_Galaxy_S3_08-380-75.JPG"
                                }
                                ]
     }
     ] 
    */
    
    NSString *authToken = [mainDelegate restAuthToken];
    
    NSURL *url = [NSURL URLWithString:@"http://soa.coderockr.com/brand"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setValue:authToken forHTTPHeaderField:@"Authorization"];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if(connectionError){
             NSLog(@"Error: %@", connectionError);
             block(nil, connectionError);
             return;
         }
         
         if (data.length > 0 && connectionError == nil)
         {
             NSError *errorParser = nil;
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorParser];
             
             if(errorParser){
                 NSLog(@"Error: %@", errorParser);
                 block(nil, errorParser);
                 return;
             }
             
             NSMutableArray *brands = [[NSMutableArray alloc] init];
             for(NSDictionary *brandJson in jsonArray){
                 Brand *brand  = [self convertBrandJsonDataToManObject:brandJson];
                 [brands addObject:brand];
             }
             
             [cdh backgroundSaveContext];
             block(brands, nil);
         }
     }];
}

- (Product *) convertProductJsonDataToManObject:(NSDictionary *) jsonData{
    int idInt = [[jsonData objectForKey:@"id"] integerValue];
    NSNumber *productId = [NSNumber numberWithInt:idInt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss-SSS"];
    NSString *datestring = [jsonData objectForKey:@"created"];
    NSDate *created = [dateFormat dateFromString:datestring];
    NSString *description = [jsonData objectForKey:@"description"];
    BOOL featured = [[jsonData objectForKey:@"featured"] boolValue];
    double priceFloat = [[jsonData objectForKey:@"price"] floatValue];
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithDecimal:
                              [[NSNumber numberWithFloat:priceFloat] decimalValue]];
                           
    int statusInt = [[jsonData objectForKey:@"status"] intValue];
    NSNumber *status = [NSNumber numberWithInt:statusInt];
    NSString *snapshot = [jsonData objectForKey:@"snapshot"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", productId ];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedProducts = [cdh.context executeFetchRequest:request error:&error];
    Product *product = nil;
    if(fetchedProducts.count == 0){
        product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:cdh.context];
    }else{
        product = [fetchedProducts objectAtIndex:0];
    }
    
    [product setId:productId];
    [product setCreated:created];
    [product setDescriptionProduct:description];
    [product setFeatured:[NSNumber numberWithBool:featured]];
    [product setPrice:price];
    [product setStatus:status];
    [product setSnapshot:snapshot];
    
    return product;
}

- (Brand *) convertBrandJsonDataToManObject:(NSDictionary *) jsonData{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    int brandIdInt = [[jsonData objectForKey:@"id"] integerValue];
    NSNumber *brandId = [NSNumber numberWithInt:brandIdInt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss-SSS"];
    NSString *createdString = [jsonData objectForKey:@"created"];
    NSLog(@"%@", createdString);
    NSDate *created = [dateFormat dateFromString:createdString];
    NSString *name = [jsonData objectForKey:@"name"];
    NSString *image = [jsonData objectForKey:@"image"];
    NSString *description = [jsonData objectForKey:@"description"];
    NSArray *products = [jsonData objectForKey:@"product_collection"];
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Brand"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", brandId ];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedBrands = [cdh.context executeFetchRequest:request error:&error];
    Brand *brand = nil;
    if (fetchedBrands.count == 0){
        brand = [NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:cdh.context];
    }else{
        brand = [fetchedBrands objectAtIndex:0];
    }
    
    [brand setId:brandId];
    [brand setCreated:created];
    [brand setImage:image];
    [brand setName:name];
    [brand setDescriptionBrand:description];

    for(NSDictionary *productJson in products){
        Product *product = [self convertProductJsonDataToManObject:productJson];
        [product setBrand:brand];
    }
    
    return brand;
}

- (void) loadDataLocal:(ResultBlock)block{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Brand"];
    NSError *error = nil;
    NSArray *fetchedBrands = [cdh.context executeFetchRequest:request error:&error];
    if (error){
        NSLog(@"Error: %@", error);
        block(nil, error);
    }else{
        block(fetchedBrands, nil);
    }
    
}


@end
