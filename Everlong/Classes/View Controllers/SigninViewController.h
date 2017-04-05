//
//  SigninViewController.h
//  Everlong
//
//  Created by Brian Morton on 8/15/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationViewController.h"
#import "ECUser.h"

@protocol SigninViewControllerDelegate;

@interface SigninViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, ECUserAuthenticationDelegate> {
    IBOutlet UITableView *signinTableView;
}

@property (nonatomic, assign) id<SigninViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *emailAddress;
@property (nonatomic, retain) NSString *password;

- (void)processSignin;

@end

@protocol SigninViewControllerDelegate

- (void)signinControllerDidCancel:(SigninViewController*)signinController;

@end