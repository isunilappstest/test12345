//
//  AMBillingAddress.h
//  Everlong
//
//  Created by Brian Morton on 1/10/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMBillingAddress : NSObject

@property (nonatomic, retain) NSString *addressLine;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zip;

+ (RKObjectMapping*)serializationMapping;

@end
