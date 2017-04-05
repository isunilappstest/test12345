//
//  ECOption.m
//  Everlong
//
//  Created by Brian Morton on 12/19/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECOption.h"

// Object mapping singleton
static RKObjectMapping *objectMapping = nil;

@implementation ECOption

@synthesize optionID = _optionID;
@synthesize name = _name;
@synthesize activeInventoryID = _activeInventoryID;
@synthesize activeInventory = _activeInventory;
@synthesize attributeID = _attributeID;


#pragma mark - Class methods

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"optionID"];
        [objectMapping mapKeyPath:@"active_inventory.id" toAttribute:@"activeInventoryID"];
        [objectMapping mapKeyPath:@"active_inventory.attribute_id" toAttribute:@"attributeID"];
        [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
        [objectMapping mapKeyPath:@"active_inventory" toRelationship:@"activeInventory" withMapping:[ECInventory objectMapping]];
    }
    return objectMapping;
}


#pragma mark - NSObject overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"Option %@: %@ (Inventory %@)", [self optionID], [self name], [self activeInventoryID]];
}

@end
