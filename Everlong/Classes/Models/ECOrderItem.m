//
//  ECOrderItem.m
//  Everlong
//
//  Created by Brian Morton on 12/17/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECOrderItem.h"

// Object mapping singleton
static RKObjectMapping *objectMapping = nil;
static RKObjectMapping *serializationMapping = nil;

@implementation ECOrderItem

@synthesize orderItemID = _orderItemID;
@synthesize orderID = _orderID;
@synthesize inventoryID = _inventoryID;
@synthesize attributeID = _attributeID;
@synthesize unitPrice = _unitPrice;
@synthesize quantity = _quantity;


#pragma mark - Class methods

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"orderItemID"];
        [objectMapping mapKeyPath:@"order_id" toAttribute:@"orderID"];
        [objectMapping mapKeyPath:@"inventory_id" toAttribute:@"inventoryID"];
        [objectMapping mapKeyPath:@"attribute_id" toAttribute:@"attributeID"];
        [objectMapping mapKeyPath:@"unit_price" toAttribute:@"unitPrice"];
        [objectMapping mapKeyPath:@"quantity" toAttribute:@"quantity"];
    }
    return objectMapping;
}

+ (RKObjectMapping*)serializationMapping {
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        serializationMapping.rootKeyPath = @"order_item";
        [serializationMapping mapKeyPath:@"inventoryID" toAttribute:@"inventory_id"];
        [serializationMapping mapKeyPath:@"attributeID" toAttribute:@"attribute_id"];
        [serializationMapping mapKeyPath:@"quantity" toAttribute:@"quantity"];
    }
    return serializationMapping;
}


#pragma mark - NSObject overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"Order item %@ attribute: %@ for order %@ with quantity of %@ ", [self orderItemID], [self attributeID], [self orderID], [self quantity]];
}

@end
