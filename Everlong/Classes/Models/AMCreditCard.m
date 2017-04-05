//
//  AMCreditCard.m
//  Everlong
//
//  Created by Brian Morton on 12/18/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "AMCreditCard.h"

// Singletons
static RKObjectMapping *serializationMapping = nil;

@implementation AMCreditCard

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize cardType = _cardType;
@synthesize cardNumber = _cardNumber;
@synthesize expirationMonth = _expirationMonth;
@synthesize expirationYear = _expirationYear;

#pragma mark - Class methods

+ (RKObjectMapping*)serializationMapping {
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        serializationMapping.rootKeyPath = @"credit_card";
        [serializationMapping mapKeyPath:@"firstName" toAttribute:@"first_name"];
        [serializationMapping mapKeyPath:@"lastName" toAttribute:@"last_name"];
        [serializationMapping mapKeyPath:@"cardType" toAttribute:@"type"];
        [serializationMapping mapKeyPath:@"cardNumber" toAttribute:@"number"];
        [serializationMapping mapKeyPath:@"expirationMonth" toAttribute:@"month"];
        [serializationMapping mapKeyPath:@"expirationYear" toAttribute:@"year"];
    }
    return serializationMapping;
}

@end
