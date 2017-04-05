//
//  ECCertificate.m
//  Everlong
//
//  Created by Brian Morton on 12/26/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECCertificate.h"
#import "ECLocation.h"

// Object mapping singletons
static RKObjectMapping *objectMapping = nil;
static RKObjectMapping *serializationMapping = nil;

@implementation ECCertificate

@synthesize certificateID = _certificateID;
@synthesize inventoryID = _inventoryID;
@synthesize inventory = _inventory;
@synthesize clientID = _clientID;
@synthesize client = client;
@synthesize optionID = _optionID;
@synthesize option = _option;
@synthesize productID = _productID;
@synthesize product = _product;
@synthesize state = _state;
@synthesize code = _code;
@synthesize locations = _locations;
@synthesize terms = _terms;
@synthesize expiresOnString = _expiresOnString;

#pragma mark - Class methods

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"certificateID"];
        [objectMapping mapKeyPath:@"inventory.id" toAttribute:@"inventoryID"];
        [objectMapping mapKeyPath:@"inventory.option.id" toAttribute:@"optionID"];
        [objectMapping mapKeyPath:@"inventory.product.id" toAttribute:@"productID"];
        [objectMapping mapKeyPath:@"state" toAttribute:@"state"];
        [objectMapping mapKeyPath:@"code" toAttribute:@"code"];
        [objectMapping mapKeyPath:@"terms" toAttribute:@"terms"];
        [objectMapping mapKeyPath:@"expires_on" toAttribute:@"expiresOnString"];
        [objectMapping mapKeyPath:@"inventory" toRelationship:@"inventory" withMapping:[ECInventory objectMapping]];
        [objectMapping mapKeyPath:@"inventory.option" toRelationship:@"option" withMapping:[ECOption objectMapping]];
        [objectMapping mapKeyPath:@"inventory.product" toRelationship:@"product" withMapping:[ECProduct objectMapping]];
        [objectMapping mapKeyPath:@"inventory.client" toRelationship:@"client" withMapping:[ECClient objectMapping]];
        [objectMapping mapKeyPath:@"locations" toRelationship:@"locations" withMapping:[ECLocation objectMapping]];
    }
    return objectMapping;
}

+ (RKObjectMapping*)serializationMapping {
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        serializationMapping.rootKeyPath = @"certificate";
        [serializationMapping mapKeyPath:@"certificateID" toAttribute:@"id"];
    }
    return serializationMapping;
}


#pragma mark - Instance methods

- (BOOL)isValid {
    if ([self.state isEqualToString:@"active"] || [self.state isEqualToString:@"flagged"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isRedeemed {
    if ([self.state isEqualToString:@"redeemed"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isPending {
    if ([self.state isEqualToString:@"pending"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isCancelled {
    if ([self.state isEqualToString:@"cancelled"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isExpired {
    return ([self.expiresOn compare:[NSDate date]] == NSOrderedAscending);
}

- (NSDate*)expiresOn {
    NSInteger stringLength = _expiresOnString.length;
    NSRange stringRange = NSMakeRange(stringLength - 3, 3);
    NSString *parseableDate = [self.expiresOnString stringByReplacingOccurrencesOfString:@":" withString:@"" options:NSLiteralSearch range:stringRange];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormatter dateFromString:parseableDate];
}

- (NSString*)expiresOnFormatted {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    return [dateFormatter stringFromDate:self.expiresOn];
}

- (NSString*)expiresOnFormattedShort {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    return [dateFormatter stringFromDate:self.expiresOn];
}


#pragma mark - NSObject overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"Certificate %@: %@ (Inventory %@)", [self code], [self state], [self inventoryID]];
}

@end
