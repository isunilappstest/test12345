//
//  LocationController.h
//  Everlong
//
//  Created by Brian Morton on 8/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NSString * const ECLocationDeniedNotification;

@protocol LocationControllerDelegate <NSObject>
@required
- (void)locationUpdate:(CLLocation*)location;
@end

@interface LocationController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager* locationManager;
	CLLocation* location;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* location;
@property (nonatomic, strong) id <LocationControllerDelegate> delegate;

+ (LocationController*)sharedInstance; // Singleton method
- (void)getNewLocationOrSendCurrentLocation;
- (void)stopUpdating;

@end