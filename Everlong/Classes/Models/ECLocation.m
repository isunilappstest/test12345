//
//  ECLocation.m
//  Everlong
//
//  Created by Brian Morton on 12/29/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECLocation.h"
#import "ECProduct.h"

// Singletons
static RKObjectMapping *objectMapping = nil;

@implementation ECLocation

@synthesize locationID = _locationID;
@synthesize name = _name;
@synthesize neighborhood = _neighborhood;
@synthesize address = _address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize phoneNumber = _phoneNumber;
@synthesize clientID = _clientID;
@synthesize client = _client;
@synthesize clientName = _clientName;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize products = _products;


#pragma mark - Class methods

+ (RKObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKObjectMapping mappingForClass:self];
        [objectMapping mapKeyPath:@"id" toAttribute:@"locationID"];
        [objectMapping mapKeyPath:@"phone_number" toAttribute:@"phoneNumber"];
        [objectMapping mapKeyPath:@"client_id" toAttribute:@"clientID"];
        [objectMapping mapKeyPath:@"client_name" toAttribute:@"clientName"];
        [objectMapping mapAttributes:@"name", @"neighborhood", @"address", @"city", @"state", @"zip", @"latitude", @"longitude", nil];
        [objectMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:[ECProduct objectMapping]];
    }
    return objectMapping;
}


#pragma mark - Instance methods

- (NSString*)title {
    NSLog(@"%@ %@", _clientID, _clientName);
    if (self.clientName != nil) {
        return self.clientName;
    } else {
        return self.client.name;
    }
}

- (NSString*)subtitle {
    if (self.neighborhood) {
        return self.neighborhood;
    } else if (self.address) {
        return self.address;
    } else {
        return [NSString stringWithFormat:@"%@, %@", self.city, self.state];
    }
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
}

- (NSURL*)googleMapsURL {
    NSString *url = [NSString stringWithFormat:@"http://www.google.com/maps?q=%@", [self.fullAddress stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
    return [NSURL URLWithString:url];
}

- (NSString*)fullAddress {
    return [NSString stringWithFormat:@"%@, %@, %@ %@", self.address, self.city, self.state, self.zip];
}

#pragma mark - NSObject overrides

- (NSString*)description {
    return [NSString stringWithFormat:@"%@: %@", self.locationID, self.name];
}

@end
