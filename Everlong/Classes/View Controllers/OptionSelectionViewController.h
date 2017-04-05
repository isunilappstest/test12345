//
//  OptionSelectionViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *optionsTableView;
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, retain) NSArray *attributes;
- (void)buildTableView;

@end
