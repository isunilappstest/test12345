//
//  ECAttribute.h
//  Everlong
//
//  Created by Jason Cox on 9/27/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    AttributeTypeInput,
    AttributeTypeSelect,
    AttributeTypeAddress
}AttributeType;


@class ECAttributeOption;
@interface ECAttribute : NSObject<RKObjectLoaderDelegate>

@property(nonatomic, retain) NSNumber *objID;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *stringDescription;
@property(nonatomic, retain) NSArray *options;
@property(nonatomic, retain) ECAttributeOption *selectedOption;

@property(nonatomic, assign) AttributeType attributeType;

+ (RKManagedObjectMapping *)objectMapping;
+ (RKObjectMapping*)serializationMapping;



@end
