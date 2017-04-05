//
//  ECPlacement.m
//  Everlong
//
//  Created by Brian Morton on 12/9/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECPlacement.h"

// Object mapping singleton
static RKObjectMapping *objectMapping = nil;

@implementation ECPlacement

@synthesize placementID = _placementID;
@synthesize featureID = _featureID;
@synthesize feature = _feature;
@synthesize productID = _productID;
@synthesize product = _product;
@synthesize lowestPrice = _lowestPrice;
@synthesize lowestRetailValue = _lowestRetailValue;
@synthesize timeRemaining = _timeRemaining;
@synthesize fullURL = _fullURL;
@synthesize shortURL = _shortURL;


#pragma mark - Class methods

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"placementID"];
        [objectMapping mapKeyPath:@"product_id" toAttribute:@"productID"];
        [objectMapping mapKeyPath:@"lowest_price" toAttribute:@"lowestPrice"];
        [objectMapping mapKeyPath:@"lowest_retail_value" toAttribute:@"lowestRetailValue"];
        [objectMapping mapKeyPath:@"time_remaining" toAttribute:@"timeRemaining"];
        [objectMapping mapKeyPath:@"full_url" toAttribute:@"fullURL"];
        [objectMapping mapKeyPath:@"short_url" toAttribute:@"shortURL"];
        [objectMapping mapKeyPath:@"product" toRelationship:@"product" withMapping:[ECProduct objectMapping]];
        [objectMapping mapKeyPath:@"feature" toRelationship:@"feature" withMapping:[ECFeature objectMapping]];
    }
    return objectMapping;
}


#pragma mark - Instance methods

- (NSString*)lowestPriceInDollars {
    NSDecimalNumber *dollars = [NSDecimalNumber decimalNumberWithMantissa:[self.lowestPrice unsignedLongValue]
                                                                 exponent:-2
                                                               isNegative:NO];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    if ([self.lowestPrice intValue] % 100 == 0) {
        [formatter setMaximumFractionDigits:0];
    }
    return [formatter stringFromNumber:dollars];
}

- (NSString*)lowestRetailValueInDollars {
    NSDecimalNumber *dollars = [NSDecimalNumber decimalNumberWithMantissa:[self.lowestRetailValue unsignedLongValue]
                                                                 exponent:-2
                                                               isNegative:NO];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    if ([self.lowestRetailValue intValue] % 100 == 0) {
        [formatter setMaximumFractionDigits:0];
    }
    return [formatter stringFromNumber:dollars];
}

- (BOOL)hasMultiplePricePoints {
    return (self.product.options.count > 1);
}


#pragma mark - NSObject overrides

- (NSString*)description {
    return [NSString stringWithFormat:@"%@: [%@] [%@]", [self placementID], [self feature], [self product]];
}

@end
