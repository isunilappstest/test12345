//
//  ECPaymentProfile.h
//  Everlong
//
//  Created by Brian Morton on 12/17/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECUser.h"
#import "AMCreditCard.h"
#import "AMBillingAddress.h"

@class ECUser;
@class AMCreditCard;

@interface ECPaymentProfile : NSManagedObject

@property (nonatomic, retain) NSNumber *paymentProfileID;
@property (nonatomic, retain) NSNumber *userID;
@property (nonatomic, retain) ECUser *user;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) AMCreditCard *creditCard;
@property (nonatomic, retain) AMBillingAddress *billingAddress;

+ (RKManagedObjectMapping*)objectMapping;
+ (RKObjectMapping*)serializationMapping;

@end
