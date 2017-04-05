//
//  QuantitySelectorViewController.m
//  Everlong
//
//  Created by Brian Morton on 1/17/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "QuantitySelectorViewController.h"
#import "AnalyticsHelper.h"

@implementation QuantitySelectorViewController

@synthesize tableView = _tableView;
@synthesize quantity = _quantity;
@synthesize maxQuantity = _maxQuantity;
@synthesize checkoutViewController = _checkoutViewController;

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Quantity";
    }
    return self;
}


#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    [self buildTableView];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/purchase-quantity"];
    
}

- (void)buildTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,416) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
    [self.view addSubview:self.tableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableView delegate and datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.maxQuantity intValue];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"How many would you like?";
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.quantity intValue] == (indexPath.row + 1)) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%i", indexPath.row + 1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.checkoutViewController.quantity = [NSNumber numberWithInt:(indexPath.row + 1)];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Instance methods

- (NSNumber*)maxQuantity {
    if (!_maxQuantity) {
        _maxQuantity = [NSNumber numberWithInt:8];
    }
    
    return _maxQuantity;
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
