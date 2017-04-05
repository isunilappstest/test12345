//
//  ECTag.m
//  Everlong
//
//  Created by Brian Morton on 12/13/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECTag.h"

// Singletons
static RKManagedObjectMapping *objectMapping = nil;

@implementation ECTag

@dynamic tagID;
@dynamic name;


#pragma mark - Class methods

+ (RKManagedObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKManagedObjectMapping mappingForClass:self];
        objectMapping.primaryKeyAttribute = @"tagID";
        [objectMapping mapKeyPath:@"id" toAttribute:@"tagID"];
        [objectMapping mapAttributes:@"name", nil];
    }
    return objectMapping;
}


#pragma mark - NSObject overrides

- (NSString*)description {
    return [NSString stringWithFormat:@"%@: %@", [self tagID], [self name]];
}

@end
