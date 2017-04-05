//
//  ECInventory.m
//  Everlong
//
//  Created by Brian Morton on 12/19/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECInventory.h"

// Object mapping singleton
static RKObjectMapping *objectMapping = nil;

@implementation ECInventory

@synthesize inventoryID = _inventoryID;
@synthesize price = _price;
@synthesize retailValue = _retailValue;
@synthesize userLimit = _userLimit;

#pragma mark - Class methods

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"inventoryID"];
        [objectMapping mapKeyPath:@"price" toAttribute:@"price"];
        [objectMapping mapKeyPath:@"retail_value" toAttribute:@"retailValue"];
        [objectMapping mapKeyPath:@"per_user_limit" toAttribute:@"userLimit"];
    }
    return objectMapping;
}


#pragma mark - Instance methods

- (NSString*)priceInDollars {
    return [self priceInDollarsForQuantity:1];
}

- (NSString*)priceInDollarsForQuantity:(NSInteger)quantity {
    NSDecimalNumber *dollars = [NSDecimalNumber decimalNumberWithMantissa:([self.price unsignedLongValue] * quantity)
                                                                 exponent:-2
                                                               isNegative:NO];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    if ([self.price intValue] % 100 == 0) {
        [formatter setMaximumFractionDigits:0];
    }
    
    return [formatter stringFromNumber:dollars];
}

- (NSString*)retailValueInDollars {
    NSDecimalNumber *dollars = [NSDecimalNumber decimalNumberWithMantissa:[[self retailValue] unsignedLongValue]
                                                                 exponent:-2
                                                               isNegative:NO];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    if ([self.price intValue] % 100 == 0) {
        [formatter setMaximumFractionDigits:0];
    }
    
    return [formatter stringFromNumber:dollars];
}


#pragma mark - NSObject overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"Inventory %@: %@ / %@", [self inventoryID], [self priceInDollars], [self retailValueInDollars]];
}


@end
