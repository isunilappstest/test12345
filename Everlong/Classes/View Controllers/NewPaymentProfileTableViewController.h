//
//  NewPaymentProfileTableViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/18/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBillingAddress.h"

@interface NewPaymentProfileTableViewController : UITableViewController <UITextFieldDelegate, RKObjectLoaderDelegate>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, retain) NSString *cardTypeDisplay;
@property (nonatomic, retain) NSString *cardTypeValue;
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *expirationMonth;
@property (nonatomic, copy) NSString *expirationYear;
@property (nonatomic, retain) AMBillingAddress *billingAddress;

- (UITextField*)makeTextField:(NSString*)text placeholder:(NSString*)placeholder;
- (void)postPaymentProfileRequest;

@end
