//
//  ECPlacement.h
//  Everlong
//
//  Created by Brian Morton on 12/9/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECProduct.h"
#import "ECFeature.h"

@interface ECPlacement : NSObject

@property (nonatomic, retain) NSNumber *placementID;
@property (nonatomic, retain) NSNumber *featureID;
@property (nonatomic, retain) ECFeature *feature;
@property (nonatomic, retain) NSNumber *productID;
@property (nonatomic, retain) ECProduct *product;
@property (nonatomic, retain) NSNumber *lowestPrice;
@property (nonatomic, retain) NSNumber *lowestRetailValue;
@property (nonatomic, retain) NSString *timeRemaining;
@property (nonatomic, retain) NSString *fullURL;
@property (nonatomic, retain) NSString *shortURL;

+ (RKObjectMapping*)objectMapping;
- (NSString*)lowestPriceInDollars;
- (NSString*)lowestRetailValueInDollars;
- (BOOL)hasMultiplePricePoints;

@end
