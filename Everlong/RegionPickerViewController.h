//
//  RegionPickerViewController.h
//  Everlong
//
//  Created by Brian Morton on 1/11/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacementsViewController.h"

@interface RegionPickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *regions;
@property (nonatomic, retain) PlacementsViewController *placementsViewController;

- (void)buildTableView;
- (void)cancelButtonPressed:(id)sender;
- (void)loadObjectsFromDataStore;

@end
