//
//  LocationController.m
//  Everlong
//
//  Created by Brian Morton on 8/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "LocationController.h"

// Notifications
NSString * const ECLocationDeniedNotification = @"ECLocationDeniedNotification";

@implementation LocationController

@synthesize locationManager;
@synthesize location;
@synthesize delegate;

static LocationController* _sharedInstance = nil;


#pragma mark - Singleton Object Methods

+ (LocationController*)sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
    }
    return _sharedInstance;
}

+ (id)alloc {
	@synchronized(self) {
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
    
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)init {
 	self = [super init];
	if (self != nil) {
        //self.location = [[CLLocation alloc] init];
		self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setPurpose:@"To provide search results targeted to the user's current location."];
	}
	return self;
}


#pragma mark - Instance methods

- (void)getNewLocationOrSendCurrentLocation {
    if (self.location) {
        [self.delegate locationUpdate:self.location];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopUpdating {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation {
    if (self.location.coordinate.latitude != newLocation.coordinate.latitude || self.location.coordinate.longitude != newLocation.coordinate.longitude) {
        self.location = newLocation;
        if ([self.delegate respondsToSelector:@selector(locationUpdate:)]) {
            [self.delegate locationUpdate:self.location];
        }
    }
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    if (error.code == kCLErrorDenied) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ECLocationDeniedNotification object:nil];
    }
}


@end
