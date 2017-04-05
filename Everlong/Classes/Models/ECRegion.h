//
//  ECRegion.h
//  Everlong
//
//  Created by Brian Morton on 1/12/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notifications
extern NSString * const ECRegionDidChangeNotification;

@interface ECRegion : NSManagedObject

@property (nonatomic, retain) NSNumber *regionID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *distance;

+ (ECRegion *)currentRegion;
+ (void)setCurrentRegion:(ECRegion *)region;
+ (RKManagedObjectMapping *)objectMapping;
+ (ECRegion *)regionForLocation:(CLLocation*)location;
- (CLLocation *)location;
- (NSString *)resourcePathForPlacements;

@end
