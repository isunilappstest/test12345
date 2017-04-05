//
//  RegistrationViewController.m
//  Everlong
//
//  Created by Brian Morton on 8/15/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AnalyticsHelper.h"

@implementation RegistrationViewController {
	SSHUDView *_hud;
}

@synthesize inputTexts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Sign-up"];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(processRegistration)];
        [self.navigationItem setRightBarButtonItem:doneButton];
        
        inputTexts = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/userCreate"];
        
    }
    return self;
}

#pragma mark - API interaction methods

- (void)processRegistration {
    id firstResponder = [self.view findFirstResponder];
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
    }
    
    //_hud = [[SSHUDView alloc] initWithTitle:@"Creating account..."];
    //_hud.hudSize = CGSizeMake(150.0f, 100.0f);
	//[_hud show];
    
    NSString *emailAddress = [inputTexts objectAtIndex:0];
	NSString *password = [inputTexts objectAtIndex:1];
    NSString *name = [inputTexts objectAtIndex:2];
    
    ECUser *user = [ECUser object];
    user.email = emailAddress;
    user.password = password;
    user.name = name;
    [user signUpWithDelegate:self];
}

- (void)userDidLogin:(ECUser*)user {
    //[_hud completeWithTitle:@"Created!"];
	//[_hud performSelector:@selector(dismiss) withObject:nil afterDelay:0.7];
    
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)user:(ECUser*)user didFailSignUpWithError:(NSError*)error {
    //[_hud dismiss];
	[[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}



#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView delegate and datasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"InputCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *tableTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 11, 175, 30)];
        [tableTextField setTextColor:[UIColor blackColor]];
        
        switch ([indexPath row]) {
            case 0:
                [tableTextField setPlaceholder:@"user@example.com"];
                [tableTextField setKeyboardType:UIKeyboardTypeEmailAddress];
                [tableTextField setReturnKeyType:UIReturnKeyNext];
                break;
            case 1:
                [tableTextField setPlaceholder:@"Required"];
                [tableTextField setKeyboardType:UIKeyboardTypeDefault];
                [tableTextField setReturnKeyType:UIReturnKeyNext];
                [tableTextField setSecureTextEntry:YES];
                break;
            case 2:
                [tableTextField setPlaceholder:@"Required"];
                [tableTextField setKeyboardType:UIKeyboardTypeDefault];
                [tableTextField setReturnKeyType:UIReturnKeyDone];
                break;
        }
        
        [tableTextField setAdjustsFontSizeToFitWidth:NO];
        [tableTextField setTextColor:[UIColor blackColor]];
        [tableTextField setBackgroundColor:[UIColor whiteColor]];
        [tableTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [tableTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [tableTextField setTextAlignment:UITextAlignmentLeft];
        [tableTextField setTag:([indexPath row] + 1)];
        [tableTextField setDelegate:self];
        
        [tableTextField setClearButtonMode:UITextFieldViewModeNever];
        [tableTextField setEnabled: YES];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:tableTextField];
    }
    
    NSString *headerText;
    switch ([indexPath row]) {
        case 0:
            headerText = @"Email";
            break;
        case 1:
            headerText = @"Password";
            break;
        case 2:
        default:
            headerText = @"Name";
            break;
    }
    [[cell textLabel] setText:headerText];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITextField *selectedField = (UITextField *)[cell viewWithTag:([indexPath row]+1)];
        [selectedField becomeFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [inputTexts replaceObjectAtIndex:(textField.tag - 1) withObject:textField.text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField tag] == 3) {
		[inputTexts replaceObjectAtIndex:(textField.tag - 1) withObject:textField.text];
		[self processRegistration];
		return YES;
	} else {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([textField tag]) inSection:0];
		UITableViewCell *cell = [registrationTableView cellForRowAtIndexPath:indexPath];
		UITextField *selectedField = (UITextField *)[cell viewWithTag:([indexPath row]+1)];
		[selectedField becomeFirstResponder];
		return YES;
	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    registrationTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
}

- (void)viewDidUnload {
    registrationTableView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
