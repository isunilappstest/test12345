//
//  ECAttributeOption.h
//  Everlong
//
//  Created by Jason Cox on 11/30/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECAttributeOption : NSObject
@property(nonatomic, retain) NSNumber *objID;
@property(nonatomic, retain) NSString *option;
//@property(nonatomic, retain) NSString *price_modifier; //This is only for ECOptions (which to the backend is the same thing)
@property(nonatomic, retain) NSNumber *quantity;
@property(nonatomic, retain) NSNumber *is_sold_out;

//Address Fields:
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *address1;
@property(nonatomic, copy) NSString *address2;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *state;
@property(nonatomic, copy) NSString *zip;

//Input Fields:
@property(nonatomic, copy) NSString *inputValue;

//Select Fields:
@property(nonatomic, copy) NSString *selectedValue;

+ (RKManagedObjectMapping *)objectMapping;
+ (RKObjectMapping*)serializationMapping;
            //TODO: FIX THE JSON ENCODE SO IT ACTULALY ENCODES
-(NSString *)addressJSON;

@end
