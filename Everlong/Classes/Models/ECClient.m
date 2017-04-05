//
//  ECClient.m
//  Everlong
//
//  Created by Brian Morton on 12/12/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECClient.h"

// Object mapping singleton
static RKObjectMapping *objectMapping = nil;

@implementation ECClient

@synthesize clientID = _clientID;
@synthesize name = _name;
@synthesize website = _website;

- (NSString*)description {
    return [NSString stringWithFormat:@"%@: %@ (%@)", [self clientID], [self name], [self website]];
}

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"clientID"];
        [objectMapping mapAttributes:@"name", @"website", nil];
    }
    return objectMapping;
}

@end
