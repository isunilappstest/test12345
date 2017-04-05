//
//  ECProduct.m
//  Everlong
//
//  Created by Brian Morton on 12/11/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECProduct.h"
#import "ECOption.h"
#import "ECLocation.h"
#import "ECAttribute.h"
#import "ECAttributeOption.h"

// Object mapping singleton
static RKObjectMapping *objectMapping = nil;

@implementation ECProduct

@synthesize productID = _productID;
@synthesize clientID = _clientID;
@synthesize client = _client;
@synthesize name = _name;
@synthesize terms = _terms;
@synthesize options = _options;
@synthesize attributes = _attributes;
@synthesize lowestPrice = _lowestPrice;
@synthesize lowestRetailValue = _lowestRetailValue;
@synthesize allImages = _allImages;
@synthesize bodyDescription = _bodyDescription;
@synthesize numberAvailable = _numberAvailable;
@synthesize locations = _locations;
@synthesize fullURL = _fullURL;
@synthesize shortURL = _shortURL;
@synthesize highlights = _highlights;

#pragma mark - Class methods

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"productID"];
        [objectMapping mapKeyPath:@"client_id" toAttribute:@"clientID"];
        [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
        [objectMapping mapKeyPath:@"description" toAttribute:@"bodyDescription"];
        [objectMapping mapKeyPath:@"number_available" toAttribute:@"numberAvailable"];
        [objectMapping mapKeyPath:@"terms" toAttribute:@"terms"];
        [objectMapping mapKeyPath:@"lowest_price" toAttribute:@"lowestPrice"];
        [objectMapping mapKeyPath:@"lowest_retail_value" toAttribute:@"lowestRetailValue"];
        [objectMapping mapKeyPath:@"primary_image_versions" toAttribute:@"allImages"];
        [objectMapping mapKeyPath:@"full_url" toAttribute:@"fullURL"];
        [objectMapping mapKeyPath:@"short_url" toAttribute:@"shortURL"];
        [objectMapping mapKeyPath:@"client" toRelationship:@"client" withMapping:[ECClient objectMapping]];
        [objectMapping mapKeyPath:@"with_options_and_inventory" toRelationship:@"options" withMapping:[ECOption objectMapping]];
        [objectMapping mapKeyPath:@"attributes" toRelationship:@"attributes" withMapping:[ECAttribute objectMapping]];
        [objectMapping mapKeyPath:@"highlights_stripped" toAttribute:@"highlights"];
        [objectMapping mapKeyPath:@"locations" toRelationship:@"locations" withMapping:[ECLocation objectMapping]];

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

- (NSDictionary*)primaryImage {
    return [self.allImages anyObject];
}

- (BOOL)hasMultiplePricePoints {
    return (self.options.count > 1);
}

- (NSString*)highlights {
    NSArray *highlightLines = [_highlights componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    NSString *newString;
    NSMutableArray *withAppendedString = [[NSMutableArray alloc] init];
    
    for (NSString *line in highlightLines) {
        if (![line isEqualToString:@""]) {
            newString = [[NSString stringWithFormat:@"• "] stringByAppendingString:line];
            [withAppendedString addObject:newString];
        } else {
            [withAppendedString addObject:line];
        }
    }
    
    return [withAppendedString componentsJoinedByString:@"\n"];
}


#pragma mark - NSObject overrides

- (NSString*)description {
    return [NSString stringWithFormat:@"%@, %@, %@", [self productID], [self name], [self terms]];
}

@end
