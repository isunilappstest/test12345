//
//  ECInventory.h
//  Everlong
//
//  Created by Brian Morton on 12/19/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECInventory : NSObject

@property (nonatomic, retain) NSNumber *inventoryID;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *retailValue;
@property (nonatomic, retain) NSNumber *userLimit;

+ (RKObjectMapping*)objectMapping;
- (NSString*)priceInDollars;
- (NSString*)priceInDollarsForQuantity:(NSInteger)quantity;
- (NSString*)retailValueInDollars;

@end
