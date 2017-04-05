//
//  RegistrationViewController.h
//  Everlong
//
//  Created by Brian Morton on 8/15/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECUser.h"

@interface RegistrationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ECUserAuthenticationDelegate> {
    NSMutableArray *inputTexts;
    IBOutlet UITableView *registrationTableView;
}

@property (nonatomic, retain) NSMutableArray *inputTexts;

- (void)processRegistration;

@end
