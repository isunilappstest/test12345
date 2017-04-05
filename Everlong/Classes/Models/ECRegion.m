//
//  ECRegion.m
//  Everlong
//
//  Created by Brian Morton on 1/12/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "ECRegion.h"

// Singletons and constants
static RKManagedObjectMapping *objectMapping = nil;
static ECRegion *currentRegion = nil;
static NSString * const kECRegionDefaultKey = @"ECRegionDefaultID";

// Notifications
NSString * const ECRegionDidChangeNotification = @"ECRegionDidChangeNotification";

@implementation ECRegion

@dynamic regionID;
@dynamic name;
@dynamic latitude;
@dynamic longitude;
@synthesize distance = _distance;


#pragma mark - Class methods

+ (ECRegion *)currentRegion {
	if (currentRegion == nil) {
        // If the user has previously selected a region, we're going to pass it along here.
		id regionID = [[NSUserDefaults standardUserDefaults] objectForKey:kECRegionDefaultKey];
		if (regionID) {
            currentRegion = [self findFirstByAttribute:@"regionID" withValue:regionID];
		}
	}
    
	return currentRegion;
}

+ (void)setCurrentRegion:(ECRegion *)region {
    if (![region isEqual:currentRegion]) {
        NSLog(@"Changing the region to %@", region.name);
        [[NSUserDefaults standardUserDefaults] setObject:region.regionID forKey:kECRegionDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        currentRegion = region;
        
        // Inform listeners of the region change
        [[NSNotificationCenter defaultCenter] postNotificationName:ECRegionDidChangeNotification object:currentRegion];
    }
}

+ (RKManagedObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKManagedObjectMapping mappingForClass:self];
        objectMapping.primaryKeyAttribute = @"regionID";
        [objectMapping mapKeyPath:@"id" toAttribute:@"regionID"];
        [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
        [objectMapping mapKeyPath:@"latitude" toAttribute:@"latitude"];
        [objectMapping mapKeyPath:@"longitude" toAttribute:@"longitude"];
    }
    return objectMapping;
}

+ (ECRegion*)regionForLocation:(CLLocation*)location {
    NSArray *regions = [ECRegion findAll];
    
    for (ECRegion *region in regions) {
        region.distance = [NSNumber numberWithDouble:[location distanceFromLocation:region.location]];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedRegions;
    sortedRegions = [regions sortedArrayUsingDescriptors:sortDescriptors];

    return [sortedRegions objectAtIndex:0];
}


#pragma mark - Instance methods

- (NSString*)resourcePathForPlacements {
    return [NSString stringWithFormat:@"/regions/%@/placements.json?hide_sold_out=1", self.regionID];
}

- (CLLocation*)location {
    return [[CLLocation alloc] initWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
}

#pragma mark - NSObject overrides

- (NSString*)description {
    return [NSString stringWithFormat:@"Region %@: %@", self.regionID, self.name];
}

@end
