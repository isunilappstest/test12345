//
//  ECPaymentProfile.m
//  Everlong
//
//  Created by Brian Morton on 12/17/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECPaymentProfile.h"

// Singletons
static RKManagedObjectMapping *objectMapping = nil;
static RKObjectMapping *serializationMapping = nil;

@implementation ECPaymentProfile

@dynamic paymentProfileID;
@dynamic userID;
@dynamic user;
@dynamic name;
@synthesize creditCard = _creditCard;
@synthesize billingAddress = _billingAddress;

#pragma mark - Class methods

+ (RKManagedObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKManagedObjectMapping mappingForClass:self];
        objectMapping.primaryKeyAttribute = @"paymentProfileID";
        [objectMapping mapKeyPath:@"id" toAttribute:@"paymentProfileID"];
        [objectMapping mapKeyPath:@"user_id" toAttribute:@"userID"];
        [objectMapping mapAttributes:@"name", nil];
    }
    return objectMapping;
}

+ (RKObjectMapping*)serializationMapping {
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        serializationMapping.rootKeyPath = @"payment_profile";
        [serializationMapping mapKeyPath:@"userID" toAttribute:@"user_id"];
        [serializationMapping mapKeyPath:@"creditCard" toRelationship:@"credit_card" withMapping:[AMCreditCard serializationMapping] serialize:YES];
        if (kSupportsMockingbird) {
            [serializationMapping mapKeyPath:@"billingAddress" toRelationship:@"billing_address" withMapping:[AMBillingAddress serializationMapping] serialize:YES];
        }
    }
    return serializationMapping;
}


#pragma mark - NSObject overrides

- (NSString*)description {
    return [NSString stringWithFormat:@"%@: %@", [self paymentProfileID], [self name]];
}

@end
