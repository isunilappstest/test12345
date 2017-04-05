//
//  ECError.m
//  Everlong
//
//  Created by Jason Cox on 10/15/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "ECError.h"

static RKObjectMapping *objectMapping = nil;

@implementation ECError
@synthesize errorMessage = _errorMessage;

+ (RKObjectMapping*)objectMapping;
{
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"error" toAttribute:@"errorStrings"];
    }
    return objectMapping;
}

@end
