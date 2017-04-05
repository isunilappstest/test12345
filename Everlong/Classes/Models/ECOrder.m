//
//  ECOrder.m
//  Everlong
//
//  Created by Brian Morton on 12/17/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECOrder.h"
#import "ECAttribute.h"

// Object mapping singleton
static RKObjectMapping *objectMapping = nil;
static RKObjectMapping *serializationMapping = nil;

@implementation ECOrder

@synthesize attributes = _attributes;

@synthesize orderID = _orderID;
@synthesize userID = _userID;
@synthesize paymentProfileID = _paymentProfileID;
@synthesize items = _items;
@synthesize state = _state;

#pragma mark - Class methods

- (id)valueForUndefinedKey:(NSString *)key;
{
    if([self.attributes objectForKey:key] != nil){
        return [self.attributes objectForKey:key];
    }
    return @"";
}

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"orderID"];
        [objectMapping mapKeyPath:@"user_id" toAttribute:@"userID"];
        [objectMapping mapKeyPath:@"payment_profile_id" toAttribute:@"paymentProfileID"];
        [objectMapping mapKeyPath:@"state" toAttribute:@"state"];
        [objectMapping mapKeyPath:@"items" toRelationship:@"items" withMapping:[ECOrderItem objectMapping]];
    }
    return objectMapping;
}

+ (RKObjectMapping*)serializationMapping {
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        serializationMapping.rootKeyPath = @"order";
        [serializationMapping mapKeyPath:@"orderID" toAttribute:@"id"];
        [serializationMapping mapKeyPath:@"userID" toAttribute:@"user_id"];
        [serializationMapping mapKeyPath:@"paymentProfileID" toAttribute:@"payment_profile_id"];
        [serializationMapping mapKeyPath:@"items" toRelationship:@"items" withMapping:[ECOrderItem serializationMapping] serialize:YES];
    }
    return serializationMapping;
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Mapper failed. error: %@", error.localizedDescription);
}

#pragma mark - Instance methods

- (BOOL)isComplete {
    if ([self.state isEqualToString:@"fulfilled"] || [self.state isEqualToString:@"paid"]) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - NSObject overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"Order %@: %i items", [self orderID], [[self items] count]];
}


@end
