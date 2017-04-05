//
//  ECCertificate.h
//  Everlong
//
//  Created by Brian Morton on 12/26/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECInventory.h"
#import "ECOption.h"
#import "ECProduct.h"

@interface ECCertificate : NSObject

@property (nonatomic, retain) NSNumber *certificateID;
@property (nonatomic, retain) NSNumber *inventoryID;
@property (nonatomic, retain) ECInventory *inventory;
@property (nonatomic, retain) NSNumber *optionID;
@property (nonatomic, retain) ECOption *option;
@property (nonatomic, retain) NSNumber *productID;
@property (nonatomic, retain) ECProduct *product;
@property (nonatomic, retain) NSNumber *clientID;
@property (nonatomic, retain) ECClient *client;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSString *terms;
@property (nonatomic, retain) NSString *expiresOnString;

+ (RKObjectMapping*)objectMapping;
+ (RKObjectMapping*)serializationMapping;

- (BOOL)isValid;
- (BOOL)isRedeemed;
- (BOOL)isCancelled;
- (BOOL)isPending;
- (BOOL)isExpired;
- (NSDate*)expiresOn;
- (NSString*)expiresOnFormatted;
- (NSString*)expiresOnFormattedShort;

@end