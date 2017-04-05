//
//  MapViewAnnotation.m
//  Everlong
//
//  Created by Brian Morton on 10/11/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title;
@synthesize coordinate;

- (id)initWithTitle:(NSString *)aTitle coordinate:(CLLocationCoordinate2D)aCoordinate {
	self = [super init];
    if (self) {
        title = aTitle;
        coordinate = aCoordinate;
    }

	return self;
}

@end
