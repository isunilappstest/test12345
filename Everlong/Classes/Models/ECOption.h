//
//  ECOption.h
//  Everlong
//
//  Created by Brian Morton on 12/19/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECInventory.h"

@interface ECOption : NSObject

@property (nonatomic, retain) NSNumber *optionID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *activeInventoryID;
@property (nonatomic, retain) ECInventory *activeInventory;
@property (nonatomic, retain) NSNumber *attributeID;

+ (RKObjectMapping*)objectMapping;

@end
