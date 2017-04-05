//
//  ECOrder.h
//  Everlong
//
//  Created by Brian Morton on 12/17/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECOrderItem.h"

@interface ECOrder : NSObject<RKObjectLoaderDelegate>

@property (nonatomic, retain) NSNumber *orderID;
@property (nonatomic, retain) NSNumber *userID;
@property (nonatomic, retain) NSNumber *paymentProfileID;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSString *state;

@property(nonatomic, retain) NSMutableDictionary *attributes;


+ (RKObjectMapping*)objectMapping;
+ (RKObjectMapping*)serializationMapping;
- (BOOL)isComplete;

@end
