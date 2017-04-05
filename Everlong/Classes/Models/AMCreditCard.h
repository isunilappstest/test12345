//
//  AMCreditCard.h
//  Everlong
//
//  Created by Brian Morton on 12/18/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBillingAddress.h"

@interface AMCreditCard : NSObject

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *cardType;
@property (nonatomic, retain) NSString *cardNumber;
@property (nonatomic, retain) NSString *expirationMonth;
@property (nonatomic, retain) NSString *expirationYear;

+ (RKObjectMapping*)serializationMapping;

@end
