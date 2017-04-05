//
//  CheckoutViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/18/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "CheckoutViewController.h"
#import "QuantitySelectorViewController.h"
#import "NewPaymentProfileTableViewController.h"
#import "AttributesSelectionViewController.h"
#import "ECUser.h"
#import "ECOrder.h"
#import "ECError.h"
#import "ECAttribute.h"
#import "ECAttributeOption.h"
#import "AnalyticsHelper.h"
@implementation CheckoutViewController {
	SSHUDView *_hud;
    UIButton *_footerButton;
}

@synthesize option = _option;
@synthesize attributes = _attributes;
@synthesize profiles = _profiles;
@synthesize selectedProfile = _selectedProfile;
@synthesize selectedRow = _selectedRow;
@synthesize quantity = _quantity;

#pragma mark - Initialization methods

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"Checkout"];
        self.quantity = [NSNumber numberWithInt:1];
               
    }
    return self;
}


#pragma mark - Instance methods

- (void)setQuantity:(NSNumber *)quantity {
    _quantity = quantity;
    [self refreshFooterButtonTitle];
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/purchase"];     
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
    self.tableView.tableFooterView = self.tableViewFooter;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadProfilesFromDataStore];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentSigninViewControllerIfNecessary];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1: //Required Product Attributes
            return (self.attributes != nil) ? self.attributes.count : 0;
        case 2:
            return ([self.profiles count] + 1);
        default:
            return 0;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerString;
    switch (section) {
        case 0: headerString = @"Order Details"; break;
        case 1: headerString = (self.attributes != nil && self.attributes.count > 0) ? @"Required Information" : nil; break;
        case 2: headerString = @"Payment Information"; break;
    }
    
    return headerString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DefaultCell";
    static NSString *SubtitleCellIdentifier = @"SubtitleCell";
    static NSString *AttributeIdentifier = @"AttributeCell";
    UITableViewCell *cell;
    
    switch ([indexPath section]) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:SubtitleCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SubtitleCellIdentifier];
            }
            
            switch ([indexPath row]) {
                case 0:
                    cell.textLabel.text = self.option.name;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x %@", self.quantity, self.option.activeInventory.priceInDollars];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:AttributeIdentifier];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AttributeIdentifier];
            }
            ECAttribute *attribute = [self.attributes objectAtIndex:indexPath.row];
            if(attribute.selectedOption != nil){
                cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", attribute.name, attribute.selectedOption.option];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@ - (Required)", attribute.name];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            // Show an add action if this is the last item of the section
            if ([indexPath row] == [self.profiles count]) {
                [[cell textLabel] setText:@"Add payment profile..."];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            } else {
                ECPaymentProfile *paymentProfile = [self.profiles objectAtIndex:[indexPath row]];
                [[cell textLabel] setText:[paymentProfile name]];
                
                if (paymentProfile == _selectedProfile) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                } else {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
            }
            
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *addProfileIndexPath = [NSIndexPath indexPathForRow:[self.profiles count] inSection:2];
    
    if ([indexPath isEqual:addProfileIndexPath]) {
        NewPaymentProfileTableViewController *newProfileController = [[NewPaymentProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:newProfileController animated:YES];
    } else if ([indexPath section] == 0) {
        QuantitySelectorViewController *quantitySelectorViewController = [[QuantitySelectorViewController alloc] init];
        quantitySelectorViewController.quantity = self.quantity;
        quantitySelectorViewController.maxQuantity = self.option.activeInventory.userLimit;
        quantitySelectorViewController.checkoutViewController = self;
        [self.navigationController pushViewController:quantitySelectorViewController animated:YES];
    }else if ([indexPath section] == 1) {
        //An attribute was selected!!!!!!!!
        
        AttributesSelectionViewController *asvc = [[AttributesSelectionViewController alloc] initWithNibName:@"AttributeSelectionView" bundle:nil];
        asvc.attribute = [self.attributes objectAtIndex:indexPath.row];
        asvc.quantityToBuy = self.quantity;
        [self.navigationController pushViewController:asvc animated:YES];
        
        
    }else if ([indexPath section] == 2) {
        
        NSIndexPath *indexPathIterator = nil;

        for(int i = 0; i<=self.profiles.count-1; i++){
            if(i < 0){
                i = 0;
            }
            indexPathIterator = [NSIndexPath indexPathForRow:i inSection:2];
            UITableViewCell *removeCheck = [tableView cellForRowAtIndexPath:indexPathIterator];
            [removeCheck setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *selectedProfileCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:1]];
        [selectedProfileCell setAccessoryType:UITableViewCellAccessoryNone];
        _selectedProfile = [self.profiles objectAtIndex:[indexPath row]];
        _selectedRow = [indexPath row];
        UITableViewCell *newSelectedProfileCell = [tableView cellForRowAtIndexPath:indexPath];
        [newSelectedProfileCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}


#pragma mark - UITableViewDatasource methods

- (void)loadProfilesFromDataStore {
	NSFetchRequest *request = [ECPaymentProfile fetchRequest];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"user == %@", [ECUser currentUser]];
    [request setPredicate:pred];
    
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	_profiles = [ECPaymentProfile objectsWithFetchRequest:request];
    NSLog(@"Profiles: %@", _profiles);
    if ([self.profiles count] > 0 && _selectedProfile == nil) {
        _selectedProfile = [self.profiles objectAtIndex:0];
        _selectedRow = 0;
    }
    [self.tableView reloadData];
}


#pragma mark - UITableView helpers

- (UIView*)tableViewFooter {
    CGFloat topMargin = 10.0;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65 + topMargin)];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finalize_background"]];
    backgroundView.frame = CGRectMake(0, topMargin, 320, 65);
    [footerView addSubview:backgroundView];
    
    self.footerButton.frame = CGRectMake(56, 2 + topMargin, 208, 59);
    [footerView addSubview:self.footerButton];
    
    return footerView;
}

- (UIButton*)footerButton {
    if (_footerButton == nil) {
        _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerButton setBackgroundImage:[UIImage imageForCurrentTargetNamed:@"finalize_button"] forState:UIControlStateNormal];
        [_footerButton setBackgroundImage:[UIImage imageForCurrentTargetNamed:@"finalize_button_highlight"] forState:UIControlStateHighlighted];
        _footerButton.titleLabel.textColor = [UIColor whiteColor];
        _footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_footerButton addTarget:self action:@selector(postCheckoutRequest) forControlEvents:UIControlEventTouchUpInside];
    }
    [_footerButton setTitle:self.buttonTitle forState:UIControlStateNormal];
    return _footerButton;
}

- (NSString*)buttonTitle {
    return [NSString stringWithFormat:@"Purchase for %@", [self.option.activeInventory priceInDollarsForQuantity:[self.quantity integerValue]]];
}

- (void)refreshFooterButtonTitle {
    [self.footerButton setTitle:self.buttonTitle forState:UIControlStateNormal];
}


#pragma mark - SigninViewControllerDelegate methods

- (void)presentSigninViewControllerIfNecessary {
    if (![[ECUser currentUser] isLoggedIn]) {
        [[[UIAlertView alloc] initWithTitle:@"Sign-in to continue"
                                    message:@"You must sign-in or register before you can complete your purchase."
                                   delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        SigninViewController *signinViewController = [[SigninViewController alloc] init];
        UINavigationController *signinNavigationController = [[UINavigationController alloc] initWithRootViewController:signinViewController];
        signinViewController.delegate = self;
        [self presentModalViewController:signinNavigationController animated:YES];
    }
}
/* Caused crash... Removed because viewWillAppear will pop up an alertView
   that the user can cancel.
- (void)signinControllerDidCancel:(SigninViewController*)signinController 
{
	//[self.navigationController popViewControllerAnimated:YES];
}
*/


#pragma mark - Checkout methods

- (void)postCheckoutRequest {
    if(self.attributes != nil && self.attributes.count > 0 ){
        bool isOk = YES;
        NSString *attributeName = nil;
        for(ECAttribute *attribute in self.attributes){
            if(attribute.selectedOption == nil){
                isOk = NO;
                attributeName = attribute.name;
                break;
            }
        }
        if(isOk == NO){
            [[[UIAlertView alloc] initWithTitle:@"Required Information"
                                        message:[NSString stringWithFormat:@"%@", attributeName]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
    }
    if (!self.selectedProfile) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"Please add a payment profile to continue."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        NewPaymentProfileTableViewController *newProfileController = [[NewPaymentProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:newProfileController animated:YES];
        return;
    }
    
    _hud = [[SSHUDView alloc] initWithTitle:@"Processing order..."];
    _hud.hudSize = CGSizeMake(150.0f, 150.0f);
	[_hud show];
    
    ECOrder *newOrder = [[ECOrder alloc] init];
    newOrder.userID = [[ECUser currentUser] userID];
    newOrder.paymentProfileID = [self.selectedProfile paymentProfileID];
    
    
    
    
    // NEED TO ADD ATTRIBUTE SHITS TO THIS ORDER!!!!!!!!
    
    
    
    // DO THIS DO THIS DO THIS DO THIS!!!
    
    
    
    ECOrderItem *newItem = [[ECOrderItem alloc] init];
    newItem.inventoryID = [self.option activeInventoryID];
    if(self.option.attributeID != nil){
        newItem.attributeID = self.option.attributeID;
    }
    newItem.quantity = self.quantity;
    
    newOrder.items = [NSSet setWithObject:newItem];
    
    if(self.attributes != nil){
        newOrder.attributes = [NSMutableDictionary dictionary];
        for(ECAttribute *attr in self.attributes){
            if(attr.attributeType == AttributeTypeInput){
                //[[ECOrder serializationMapping] mapKeyPath:attr.selectedOption.inputValue toAttribute:[NSString stringWithFormat:@"option_%@", attr.objID]];
                [newOrder.attributes setObject:attr.selectedOption.inputValue forKey:[NSString stringWithFormat:@"option_%@", attr.objID]];
                [[ECOrder serializationMapping] mapKeyPath:[NSString stringWithFormat:@"option_%@", attr.objID] toAttribute:[NSString stringWithFormat:@"option_%@", attr.objID]];
                
            }
            //TODO: FIX THE JSON ENCODE SO IT ACTULALY ENCODES
            if(attr.attributeType == AttributeTypeAddress){
                [newOrder.attributes setObject:attr.selectedOption.addressJSON forKey:[NSString stringWithFormat:@"option_%@", attr.objID]];
//                [[ECOrder serializationMapping] mapKeyPath:attr.selectedOption.addressJSON toAttribute:[NSString stringWithFormat:@"option_%@", attr.objID]];
                [[ECOrder serializationMapping] mapKeyPath:[NSString stringWithFormat:@"option_%@", attr.objID] toAttribute:[NSString stringWithFormat:@"option_%@", attr.objID]];

            }
            if(attr.attributeType == AttributeTypeSelect){
                [newOrder.attributes setObject:attr.selectedOption.option forKey:[NSString stringWithFormat:@"option_%@", attr.objID]];
                
                //                [[ECOrder serializationMapping] mapKeyPath:attr.selectedOption.selectedValue toAttribute:[NSString stringWithFormat:@"option_%@", attr.objID]];

                [[ECOrder serializationMapping] mapKeyPath:[NSString stringWithFormat:@"option_%@", attr.objID] toAttribute:[NSString stringWithFormat:@"option_%@", attr.objID]];
            }


        }
    }
    
    [[RKObjectManager sharedManager] postObject:newOrder delegate:self  block:^(RKObjectLoader* loader) {
        loader.resourcePath = @"/orders";
        /*
        loader.serializationMapping = [RKObjectMapping serializationMappingWithBlock:^(RKObjectMapping* mapping) {
            mapping.rootKeyPath = @"user";
            [mapping mapAttributes:@"email", @"password", @"name", nil];
        }];
        */
    }];
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    [_hud dismissAnimated:YES];
    
    if([objects count] > 0 && [[objects objectAtIndex:0] isKindOfClass:[ECOrder class]]){
        ECOrder *order = [objects objectAtIndex:0];
        
        if (order.isComplete) {
            [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/purchase-complete"];
            [[[UIAlertView alloc] initWithTitle:@"Success!"
                                        message:@"Your order is complete! Check the 'Certificates' tab to find your goodies."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/purchase-error"];     
            [[[UIAlertView alloc] initWithTitle:@"Something went wrong"
                                        message:@"It appears that something went wrong while processing your order. We'll send you an email with more details. If you have any questions, please contact support."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }        
    }
    //Something went wrong with the chingas.
    if(objects.count < 1){
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/purchase-error"];             
        [[[UIAlertView alloc] initWithTitle:@"Something went wrong"
                                    message:@"It appears that something went wrong while processing your order. We'll send you an email with more details. If you have any questions, please contact support."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [_hud dismiss];
    NSLog(@"Encountered an error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Order Error"
                                message:[error localizedDescription]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


-(void)signinControllerDidCancel:(SigninViewController *)signinController
{
    NSLog(@"HOLY SHIT THIS SHIT DOES SOME SHIT!!!!");
}

@end
