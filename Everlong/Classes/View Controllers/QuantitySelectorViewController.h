//
//  QuantitySelectorViewController.h
//  Everlong
//
//  Created by Brian Morton on 1/17/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutViewController.h"

@interface QuantitySelectorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSNumber *quantity;
@property (nonatomic, retain) NSNumber *maxQuantity;
@property (nonatomic, retain) CheckoutViewController *checkoutViewController;

- (void)buildTableView;

@end
