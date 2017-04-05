//
//  ECOrderItem.h
//  Everlong
//
//  Created by Brian Morton on 12/17/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECOrderItem : NSObject

@property (nonatomic, retain) NSNumber *orderItemID;
@property (nonatomic, retain) NSNumber *orderID;
@property (nonatomic, retain) NSNumber *inventoryID;
@property (nonatomic, retain) NSNumber *attributeID;
@property (nonatomic, retain) NSNumber *unitPrice;
@property (nonatomic, retain) NSNumber *quantity;

+ (RKObjectMapping*)objectMapping;
+ (RKObjectMapping*)serializationMapping;

@end
