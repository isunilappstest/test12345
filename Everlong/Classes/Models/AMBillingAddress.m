//
//  AMBillingAddress.m
//  Everlong
//
//  Created by Brian Morton on 1/10/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "AMBillingAddress.h"

// Singletons
static RKObjectMapping *serializationMapping = nil;

@implementation AMBillingAddress

@synthesize addressLine = _addressLine;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;

#pragma mark - Class methods

+ (RKObjectMapping*)serializationMapping {
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        serializationMapping.rootKeyPath = @"billing_address";
        [serializationMapping mapKeyPath:@"addressLine" toAttribute:@"address"];
        [serializationMapping mapKeyPath:@"city" toAttribute:@"city"];
        [serializationMapping mapKeyPath:@"state" toAttribute:@"state"];
        [serializationMapping mapKeyPath:@"zip" toAttribute:@"zip"];
    }
    return serializationMapping;
}

@end
