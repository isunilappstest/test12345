//
//  ECProduct.h
//  Everlong
//
//  Created by Brian Morton on 12/11/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECClient.h"

@interface ECProduct : NSObject

@property (nonatomic, retain) NSNumber *productID;
@property (nonatomic, retain) NSNumber *clientID;
@property (nonatomic, retain) ECClient *client;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *bodyDescription;
@property (nonatomic, retain) NSNumber *numberAvailable;
@property (nonatomic, retain) NSString *terms;
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, retain) NSArray *attributes;
@property (nonatomic, retain) NSNumber *lowestPrice;
@property (nonatomic, retain) NSNumber *lowestRetailValue;
@property (nonatomic, retain) NSSet *allImages;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSString *fullURL;
@property (nonatomic, retain) NSString *shortURL;
@property (nonatomic, retain) NSString *highlights;

+ (RKObjectMapping*)objectMapping;
- (NSString *)lowestPriceInDollars;
- (NSString*)lowestRetailValueInDollars;
- (NSDictionary *)primaryImage;
- (BOOL)hasMultiplePricePoints;

@end
