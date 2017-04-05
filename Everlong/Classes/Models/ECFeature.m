//
//  ECFeature.m
//  Everlong
//
//  Created by Brian Morton on 12/12/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECFeature.h"

// Object mapping singleton
static RKObjectMapping *objectMapping = nil;

@implementation ECFeature

@synthesize featureID = _featureID;
@synthesize title = _title;
@synthesize body = _body;
@synthesize highlights = _highlights;
@synthesize primaryImage = _primaryImage;

- (NSString*)description {
    return [NSString stringWithFormat:@"%@, %@", [self featureID], [self title]];
}

- (NSString*)titleWithoutLineBreaks {
    return [[_title componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
}

- (NSString*)highlights {
    NSArray *highlightLines = [_highlights componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    NSString *newString;
    NSMutableArray *withAppendedString = [[NSMutableArray alloc] init];
    
    for (NSString *line in highlightLines) {
        if (![line isEqualToString:@""]) {
            newString = [[NSString stringWithFormat:@"• "] stringByAppendingString:line];
            [withAppendedString addObject:newString];
        } else {
            [withAppendedString addObject:line];
        }
    }
    
    return [withAppendedString componentsJoinedByString:@"\n"];
}


+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"featureID"];
        [objectMapping mapKeyPath:@"primary_image_versions" toAttribute:@"primaryImage"];
        [objectMapping mapKeyPath:@"title_stripped" toAttribute:@"title"];
        [objectMapping mapKeyPath:@"body_stripped" toAttribute:@"body"];
        [objectMapping mapKeyPath:@"highlights_stripped" toAttribute:@"highlights"];
    }
    return objectMapping;
}

@end
