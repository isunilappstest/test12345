//
//  AccountViewController.h
//  Everlong
//
//  Created by Brian Morton on 8/11/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigninViewController.h"
#import "ECUser.h"

@interface AccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *accountTableView;
    UIView *containerView;
    UIView *signedInView;
    UIView *signedOutView;
}

@property (nonatomic, retain) NSArray *profiles;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIView *signedInView;
@property (nonatomic, retain) UIView *signedOutView;
@property (nonatomic, retain) UITableView *accountTableView;

- (IBAction)presentSigninViewController:(id)sender;
- (void)refreshView;
- (void)loadSignedInView;
- (void)loadSignedOutView;
- (void)loadObjectsFromDataStore;

@end
