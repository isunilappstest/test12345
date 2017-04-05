//
//  OptionSelectionViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "OptionSelectionViewController.h"
#import "CheckoutViewController.h"
#import "ECOption.h"
#import "AnalyticsHelper.h"

@implementation OptionSelectionViewController

@synthesize optionsTableView = _optionsTableView;
@synthesize options = _options;
@synthesize attributes = _attributes;
#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Options"];
              
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildTableView];
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/purchase-options"];      
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)buildTableView {
    _optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,416) style:UITableViewStyleGrouped];
    self.optionsTableView.dataSource = self;
    self.optionsTableView.delegate = self;
    self.optionsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
    [self.view addSubview:self.optionsTableView];
}


#pragma mark - UITableView delegate and datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select an option";
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ECOption *option = [self.options objectAtIndex:indexPath.row];
    
    cell.textLabel.text = option.name;
    cell.detailTextLabel.text = option.activeInventory.priceInDollars;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckoutViewController *checkoutViewController = [[CheckoutViewController alloc] initWithStyle:UITableViewStyleGrouped];
    checkoutViewController.option = [self.options objectAtIndex:indexPath.row];
    checkoutViewController.attributes = self.attributes;
    [self.navigationController pushViewController:checkoutViewController animated:YES];
}


#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)viewWillAppear:(BOOL)animated {
    // Unselect the selected row if any
    NSIndexPath *selection = [self.optionsTableView indexPathForSelectedRow];
    if (selection) {
        [self.optionsTableView deselectRowAtIndexPath:selection animated:YES];
    }
    self.optionsTableView.frame = self.view.frame;
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    //	The scrollbars won't flash unless the tableview is long enough.
    [self.optionsTableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.optionsTableView setEditing:editing animated:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.optionsTableView flashScrollIndicators];
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
