//
//  CertificatesViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/26/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECUser.h"
#import "SigninViewController.h"

@interface CertificatesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, UIAlertViewDelegate, ECUserAuthenticationDelegate, SigninViewControllerDelegate>

@property (nonatomic, retain) UITableView *certificatesTableView;
@property (nonatomic, retain) NSArray *certificates;
@property (nonatomic, retain) NSArray *activeCertificates;
@property (nonatomic, retain) NSArray *expiredCertificates;

@property (nonatomic, retain) UIView *signedOutView;


- (IBAction)presentSigninViewController:(id)sender;

- (void)loadCertificatesFromRemote;
- (void)buildTableView;
- (void)additionalViewWillAppearForTableView;
- (void)presentSigninViewControllerIfNecessary;
- (void)clearAllCertificates;

- (void)refreshView;
- (void)loadSignedInView;
- (void)loadSignedOutView;

@end
