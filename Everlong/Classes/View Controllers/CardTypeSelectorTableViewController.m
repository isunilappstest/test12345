//
//  CardTypeSelectorTableViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "CardTypeSelectorTableViewController.h"


@implementation CardTypeSelectorTableViewController

@synthesize cardTypeValue = _cardTypeValue;
@synthesize cardTypeDisplay = _cardTypeDisplay;
@synthesize parentController = _parentController;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Card Type";

    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Visa";
            break;
        case 1:
            cell.textLabel.text = @"MasterCard";
            break;
        case 2:
            cell.textLabel.text = @"American Express";
            break;
        case 3:
            cell.textLabel.text = @"Discover";
            break;
    }
    
    if ([cell.textLabel.text isEqualToString:self.cardTypeDisplay]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            self.cardTypeDisplay = @"Visa";
            self.cardTypeValue = @"visa";
            break;
        case 1:
            self.cardTypeDisplay = @"MasterCard";
            self.cardTypeValue = @"master";
            break;
        case 2:
            self.cardTypeDisplay = @"American Express";
            self.cardTypeValue = @"american_express";
            break;
        case 3:
            self.cardTypeDisplay = @"Discover";
            self.cardTypeValue = @"discover";
            break;
    }
    self.parentController.cardTypeDisplay = self.cardTypeDisplay;
    self.parentController.cardTypeValue = self.cardTypeValue;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
