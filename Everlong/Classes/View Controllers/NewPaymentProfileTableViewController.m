//
//  NewPaymentProfileTableViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/18/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "NewPaymentProfileTableViewController.h"
#import "CardTypeSelectorTableViewController.h"
#import "ECPaymentProfile.h"
#import "UIView+FindFirstResponder.h"
#import "AnalyticsHelper.h"
@implementation NewPaymentProfileTableViewController {
    UITextField *_firstNameField;
    UITextField *_lastNameField;
    UITextField *_cardNumberField;
    UITextField *_expirationMonthField;
    UITextField *_expirationYearField;
    UITextField *_addressField;
    UITextField *_cityField;
    UITextField *_stateField;
    UITextField *_zipField;
    NSIndexPath *_cardTypeIndexPath;
    SSHUDView *_hud;
    ECPaymentProfile *_newProfile;
}

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize cardTypeDisplay = _cardTypeDisplay;
@synthesize cardTypeValue = _cardTypeValue;
@synthesize cardNumber = _cardNumber;
@synthesize expirationMonth = _expirationMonth;
@synthesize expirationYear = _expirationYear;
@synthesize billingAddress = _billingAddress;


#pragma mark - Initialization methods

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"Add card"];
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(postPaymentProfileRequest)];
        [self.navigationItem setRightBarButtonItem:saveButton];
        _cardTypeIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        _cardTypeDisplay = @"Tap to select";
        _billingAddress = [[AMBillingAddress alloc] init];
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/purchase-addpayment"];                
    }
    return self;
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 4;
        case 2:
            return 4;
        default:
            return 0;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerString;
    switch (section) {
        case 0: headerString = @"Billing Information"; break;
        case 1: headerString = @"Card Information"; break;
        case 2: headerString = @"Billing Address"; break;
    }
    
    return headerString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // We're not going to use reusable cells here because it gets pretty messy.
    UITableViewCell *cell = nil;
    
    if ([indexPath isEqual:_cardTypeIndexPath]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    UITextField *textField = nil;
    int tag = 0;
    CGRect frame = CGRectMake(120, 11, 175, 30);
    
    switch (indexPath.section) {
        case 0: {
            tag = [indexPath row] + 1;
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"First name";
                    textField = _firstNameField = [self makeTextField:self.firstName placeholder:@"John"];
                    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                    [cell addSubview:_firstNameField];
                    break;
                }
                case 1: {
                    cell.textLabel.text = @"Last name";
                    textField = _lastNameField = [self makeTextField:self.lastName placeholder:@"Appleseed"];
                    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                    [cell addSubview:_lastNameField];
                    break;
                }
            }
            break;
        }
        case 1: {
            tag = [indexPath row] + 3;
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"Type";
                    cell.detailTextLabel.text = self.cardTypeDisplay;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1: {
                    cell.textLabel.text = @"Number";
                    textField = _cardNumberField = [self makeTextField:self.cardNumber placeholder:@"4111111111111111"];
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    [cell addSubview:_cardNumberField];
                    break;
                }
                case 2: {
                    cell.textLabel.text = @"Exp month";
                    textField = _expirationMonthField = [self makeTextField:self.expirationMonth placeholder:@"5"];
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    [cell addSubview:_expirationMonthField];
                    break;
                }
                case 3: {
                    cell.textLabel.text = @"Exp year";
                    textField = _expirationYearField = [self makeTextField:self.expirationYear placeholder:@"2014"];
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    [cell addSubview:_expirationYearField];
                    break;
                }
            }
            break;
        }
        case 2: {
            tag = [indexPath row] + 7;
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"Address";
                    textField = _addressField = [self makeTextField:self.billingAddress.addressLine placeholder:@"1 Infinite Loop"];
                    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                    [cell addSubview:_addressField];
                    break;
                }
                case 1: {
                    cell.textLabel.text = @"City";
                    textField = _cityField = [self makeTextField:self.billingAddress.city placeholder:@"Cupertino"];
                    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                    [cell addSubview:_cityField];
                    break;
                }
                case 2: {
                    cell.textLabel.text = @"State";
                    textField = _stateField = [self makeTextField:self.billingAddress.state placeholder:@"CA"];
                    [cell addSubview:_stateField];
                    break;
                }
                case 3: {
                    cell.textLabel.text = @"Zip";
                    textField = _zipField = [self makeTextField:self.billingAddress.zip placeholder:@"95014"];
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    textField.returnKeyType = UIReturnKeyDone;
                    [cell addSubview:_zipField];
                    break;
                }
            }
            break;
        }
    }
    
    if (textField != nil) {
        textField.tag = tag;
        textField.frame = frame;
        textField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:_cardTypeIndexPath]) {
        CardTypeSelectorTableViewController *selectorViewController = [[CardTypeSelectorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        selectorViewController.cardTypeValue = _cardTypeValue;
        selectorViewController.cardTypeDisplay = _cardTypeDisplay;
        selectorViewController.parentController = self;
        [self.navigationController pushViewController:selectorViewController animated:YES];
    }
}


#pragma mark - UITextField delegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == _firstNameField) {
		self.firstName = textField.text;
	} else if (textField == _lastNameField) {
        self.lastName = textField.text;
    } else if (textField == _cardNumberField) {
        self.cardNumber = textField.text;
    } else if (textField == _expirationMonthField) {
        self.expirationMonth = textField.text;
    } else if (textField == _expirationYearField) {
        self.expirationYear = textField.text;
    } else if (textField == _addressField) {
        self.billingAddress.addressLine = textField.text;
    } else if (textField == _cityField) {
        self.billingAddress.city = textField.text;
    } else if (textField == _stateField) {
        self.billingAddress.state = textField.text;
    } else if (textField == _zipField) {
        self.billingAddress.zip = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _zipField && kSupportsMockingbird) {
		self.billingAddress.zip = textField.text;
        [textField resignFirstResponder];
        [self postPaymentProfileRequest];
		return YES;
    } else if (textField == _expirationYearField) {
        self.expirationYear = textField.text;
        [textField resignFirstResponder];
        [self postPaymentProfileRequest];
		return YES;     
	} else {
        int tag = [textField tag];
        if (textField == _lastNameField) {
            tag = tag + 1;
        }
        int section = 0;
        int row = tag;
        if (tag > 6) {
            section = 2;
            row = row - 6;
        } else if (tag > 1) {
            section = 1;
            row = row - 2;
        }
        NSLog(@"%i, %i", row, section);
        
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		UITextField *selectedField = (UITextField *)[cell viewWithTag:tag+1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
		[selectedField becomeFirstResponder];
		return YES;
	}
}


#pragma mark - Private helper methods

- (UITextField*)makeTextField:(NSString*)text placeholder:(NSString*)placeholder  {
	UITextField *textField = [[UITextField alloc] init];
	textField.placeholder = placeholder;
	textField.text = text;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.adjustsFontSizeToFitWidth = NO;
    textField.returnKeyType = UIReturnKeyNext;
	textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f]; 	
	return textField;
}

- (void)postPaymentProfileRequest {
    //_hud = [[SSHUDView alloc] initWithTitle:@"Processing..."];
    //_hud.hudSize = CGSizeMake(120.0f, 120.0f);
	//[_hud show];
    
    id firstResponder = [self.view findFirstResponder];
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
    }
    
    ECUser *currentUser = [ECUser currentUser];
    if (kSupportsMockingbird &&  currentUser.hasPaymentProfile) {
        _newProfile = currentUser.firstPaymentProfile;
    } else {
        _newProfile = [ECPaymentProfile object];
    }
    _newProfile.paymentProfileID = [[ECUser currentUser] userID];
    _newProfile.userID = [[ECUser currentUser] userID];
    _newProfile.user = [ECUser currentUser];
    
    AMCreditCard *newCard = [[AMCreditCard alloc] init];
    newCard.firstName = self.firstName;
    newCard.lastName = self.lastName;
    newCard.cardType = self.cardTypeValue;
    newCard.cardNumber = self.cardNumber;
    newCard.expirationMonth = [NSString stringWithFormat:@"%i", [self.expirationMonth intValue]];
    newCard.expirationYear = self.expirationYear;
    
    _newProfile.creditCard = newCard;
    _newProfile.billingAddress = self.billingAddress;
    
    [[RKObjectManager sharedManager] postObject:_newProfile delegate:self  block:^(RKObjectLoader* loader) {
        loader.resourcePath = @"/payment_profiles";
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
   // [_hud completeWithTitle:@"Added!"];
///	[_hud performSelector:@selector(dismiss) withObject:nil afterDelay:0.7];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [[ECPaymentProfile managedObjectContext] deleteObject:_newProfile];
    //[_hud dismiss];
    NSLog(@"Encountered an error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
