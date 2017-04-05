//
//  CheckoutViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/18/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigninViewController.h"
#import "ECOption.h"

//Required Information header

@interface CheckoutViewController : UITableViewController <SigninViewControllerDelegate, RKObjectLoaderDelegate, UIAlertViewDelegate>
@property(nonatomic, retain) NSArray *attributes;
@property (nonatomic, retain) ECOption *option;
@property (nonatomic, retain) NSArray *profiles;
@property (nonatomic, retain) ECPaymentProfile *selectedProfile;
@property (nonatomic, retain) NSNumber *quantity;
@property (nonatomic) int selectedRow;

- (void)presentSigninViewControllerIfNecessary;
- (void)loadProfilesFromDataStore;
- (void)postCheckoutRequest;
- (UIView*)tableViewFooter;
- (UIButton*)footerButton;
- (NSString*)buttonTitle;
- (void)refreshFooterButtonTitle;

@end
