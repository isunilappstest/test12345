//
//  ECLocation.h
//  Everlong
//
//  Created by Brian Morton on 12/29/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECClient.h"

@interface ECLocation : NSObject <MKAnnotation>

@property (nonatomic, retain) NSNumber *locationID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *neighborhood;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSNumber *clientID;
@property (nonatomic, retain) ECClient *client;
@property (nonatomic, retain) NSString *clientName;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSSet *products;

+ (RKObjectMapping*)objectMapping;
- (NSString*)title;
- (NSString*)subtitle;
- (CLLocationCoordinate2D)coordinate;
- (NSString*)fullAddress;
- (NSURL*)googleMapsURL;

@end
