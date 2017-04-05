//
//  SigninViewController.m
//  Everlong
//
//  Created by Brian Morton on 8/15/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "SigninViewController.h"
#import "AnalyticsHelper.h"
#import "PrivacyViewController.h"
@interface SigninViewController ()
- (UITextField *)makeTextField:(NSString *)text placeholder:(NSString *)placeholder;
@end

@implementation SigninViewController {
	SSHUDView *_hud;
    UITextField *_emailField;
    UITextField *_passwordField;
}

@synthesize emailAddress = _emailAddress;
@synthesize password = _password;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Sign-in";
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
        
        UIBarButtonItem *signinButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(processSignin)];
        [self.navigationItem setRightBarButtonItem:signinButton];
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/login"];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    if(self.delegate != nil && [(NSObject *)self.delegate respondsToSelector:@selector(signinControllerDidCancel:)]){
        [_delegate signinControllerDidCancel:self];        
    }
}

#pragma mark - User signin methods

- (void)processSignin {
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];

    /*
    _hud = [[SSHUDView alloc] initWithTitle:@"Signing in..."];
    _hud.hudSize = CGSizeMake(120.0f, 120.0f);
	[_hud show];
     */
    ECUser *user = [ECUser currentUser];
    [user loginWithEmail:_emailAddress andPassword:_password delegate:self];
}


#pragma mark ECUserAuthenticationDelegate methods

- (void)userDidLogin:(ECUser*)user {
    //[_hud completeWithTitle:@"Signed in!"];
	//[_hud performSelector:@selector(dismiss) withObject:nil afterDelay:0.7];
    
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)user:(ECUser*)user didFailLoginWithError:(NSError*)error {
    //[_hud dismiss];
	[[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 && buttonIndex == 1) {
        UITextField *alertTextField = [alertView textFieldAtIndex:0];
        ECUser *passwordResetUser = [ECUser object];
        passwordResetUser.email = alertTextField.text;
        [passwordResetUser sendPasswordReset];
        
        _hud = [[SSHUDView alloc] initWithTitle:@"Requesting reset..."];
        _hud.hudSize = CGSizeMake(180.0f, 120.0f);
        [_hud show];
    }
}

- (void)passwordResetWasSent:(NSNotification *)notification {
    [_hud completeWithTitle:@"Email sent!"];
    [_hud performSelector:@selector(dismiss) withObject:nil afterDelay:0.9];
}

- (void)passwordResetFailed:(NSNotification *)notification {
    [_hud failWithTitle:@"Reset failed!"];
    [_hud performSelector:@selector(dismiss) withObject:nil afterDelay:0.9];
}


#pragma mark - UITableView delegate and datasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// We'll use a reusable cell for the action cells
    static NSString *actionCellIdentifier = @"ActionCell";
    
    // We're not going to use reusable cells for input because it gets pretty messy.
    UITableViewCell *cell = nil;
    UITextField *textField = nil;
    int tag = 0;
    CGRect frame = CGRectMake(120, 11, 175, 30);
    
    if ([indexPath section] == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        tag = [indexPath row] + 1;
        
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"Email";
                textField = _emailField = [self makeTextField:self.emailAddress placeholder:@"user@example.com"];
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                [cell addSubview:_emailField];
                break;
            }
            case 1: {
                cell.textLabel.text = @"Password";
                textField = _passwordField = [self makeTextField:self.password placeholder:@"Required"];
                textField.secureTextEntry = YES;
                textField.returnKeyType = UIReturnKeyDone;
                [cell addSubview:_passwordField];
                break;
            }
        }
        
        textField.tag = tag;
        textField.frame = frame;
        textField.delegate = self;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:actionCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:actionCellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
        }
        switch ([indexPath row]) {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"I need an account";
                break;
            case 1:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"Privacy Policy";
                break;
                
                /*
            case 1:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"I forgot my password";
                break;
                 */
        }
        
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITextField *selectedField = (UITextField *)[cell viewWithTag:([indexPath row]+1)];
        [selectedField becomeFirstResponder];
    } else {
        if (indexPath.row == 0) {
            RegistrationViewController *viewController = [[RegistrationViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            
            PrivacyViewController *pvc = [[PrivacyViewController alloc] initWithNibName:@"PrivacyView" bundle:nil];
            [self presentModalViewController:pvc animated:YES];

            /*
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            UITableViewCell *cell = [signinTableView cellForRowAtIndexPath:indexPath];
            UITextField *selectedField = (UITextField *)[cell viewWithTag:(indexPath.row + 1)];
            [selectedField resignFirstResponder];
            
            UIAlertView *resetPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Reset Password"
                                                                         message:@"We'll send you an email with instructions to reset your password."
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                               otherButtonTitles:@"OK", nil];
            resetPasswordAlert.tag = 1;
            resetPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *alertTextField = [resetPasswordAlert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
            alertTextField.placeholder = @"Email address";
            [resetPasswordAlert show];
             */
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = 0;
    switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            if (kSupportsMockingbird) {
                rows = 2;
            } else {
                rows = 2;
            }
        default:
            break;
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footerTitle;
    if (section == 1 && !kSupportsMockingbird) {
        footerTitle = @"If you use Facebook or Twitter to login, please choose 'I forgot my password' and create a password for the iPhone app.";
    }
    
    return footerTitle;
}


#pragma mark - UITextField methods

- (UITextField *)makeTextField:(NSString *)text placeholder:(NSString *)placeholder {
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == _emailField) {
		self.emailAddress = textField.text;
	} else if (textField == _passwordField) {
        self.password = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _passwordField) {
		self.password = textField.text;
        [textField resignFirstResponder];
        [self processSignin];
		return NO;
	} else {
		[_passwordField becomeFirstResponder];
        return NO;
	}
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    signinTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passwordResetWasSent:)
                                                 name:ECUserDidResetPasswordNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passwordResetFailed:)
                                                 name:ECUserDidFailResetPasswordNotification
                                               object:nil];
     */
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // Resign as the delegate
	if ([ECUser currentUser].delegate == self) {
		[ECUser currentUser].delegate = nil;
	}
}

- (void)viewDidUnload {
    signinTableView = nil;
    
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ECUserDidResetPasswordNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ECUserDidFailResetPasswordNotification
                                                  object:nil];
     */   
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
#pragma mark - Keyboard resizing

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:NO]; 
}

- (void)moveTextViewForKeyboard:(NSNotification *)aNotification up:(BOOL)up {
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = signinTableView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    newFrame.size.height -= keyboardFrame.size.height * (up? 1 : -1);
    signinTableView.frame = newFrame;
    
    [UIView commitAnimations];
}
*/

#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath *selection = [signinTableView indexPathForSelectedRow];
    if (selection) {
        [signinTableView deselectRowAtIndexPath:selection animated:YES];
    }

}

@end
