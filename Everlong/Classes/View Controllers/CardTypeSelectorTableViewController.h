//
//  CardTypeSelectorTableViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPaymentProfileTableViewController.h"

@interface CardTypeSelectorTableViewController : UITableViewController

@property (nonatomic, retain) NewPaymentProfileTableViewController *parentController;
@property (nonatomic, retain) NSString *cardTypeDisplay;
@property (nonatomic, retain) NSString *cardTypeValue;

@end
