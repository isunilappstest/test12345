//
//  CertificatesViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/26/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "CertificatesViewController.h"
#import "CertificateDetailViewController.h"
#import "ECUser.h"
#import "ECCertificate.h"
#import "ProductTableViewCell.h"
#import "SigninViewController.h"
#import "AnalyticsHelper.h"
@implementation CertificatesViewController {
    SSHUDView *_hud;
}

@synthesize signedOutView = _signedOutView;


@synthesize certificatesTableView = _certificatesTableView;
@synthesize certificates = _certificates;
@synthesize activeCertificates = _activeCertificates;
@synthesize expiredCertificates = _expiredCertificates;

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Certificates"];          
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    

    
    NSArray *signedOutNibViews =  [[NSBundle mainBundle] loadNibNamed:@"SignedOutView" owner:self options:nil];
    self.signedOutView = [signedOutNibViews objectAtIndex:0]; 
        
    [self buildTableView];
    [self refreshView];
    
    [self presentSigninViewControllerIfNecessary];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self additionalViewWillAppearForTableView];
    NSLog(@"View will appear for certificates view controller.");
    self.view.frame = CGRectMake(0,0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-113);

    self.certificatesTableView.frame = self.view.frame;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadCertificatesFromRemote];
    self.signedOutView.frame = CGRectMake(0,0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-113);
    
    //	The scrollbars won't flash unless the tableview is long enough.
    [self.certificatesTableView flashScrollIndicators];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)buildTableView {
    _certificatesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,367) style:UITableViewStylePlain];
    self.certificatesTableView.dataSource = self;
    self.certificatesTableView.delegate = self;
    self.certificatesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.certificatesTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_background", ECTenantName]]];
    
    [self.certificatesTableView registerNib:[UINib nibWithNibName:@"CertificateTableViewCell" bundle:nil] forCellReuseIdentifier:@"CertificateCell"];
    [self.view addSubview:self.certificatesTableView];
}

- (void)presentSigninViewControllerIfNecessary {
    if (![[ECUser currentUser] isLoggedIn]) {
        [[[UIAlertView alloc] initWithTitle:@"Sign-in to continue"
                                    message:@"You must sign-in to view your certificates."
                                   delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self clearAllCertificates];
        [self refreshView];
    } else {
        SigninViewController *signinViewController = [[SigninViewController alloc] init];
        UINavigationController *signinNavigationController = [[UINavigationController alloc] initWithRootViewController:signinViewController];
        signinViewController.delegate = self;
        [self presentModalViewController:signinNavigationController animated:YES];
    }
}

- (void)signinControllerDidCancel:(SigninViewController*)signinController {
    [self clearAllCertificates];
    [self refreshView];
}

- (IBAction)presentSigninViewController:(id)sender {
    SigninViewController *signinViewController = [[SigninViewController alloc] init];
    UINavigationController *signinNavigationController = [[UINavigationController alloc] initWithRootViewController:signinViewController];
    [self presentModalViewController:signinNavigationController animated:YES];
}

- (void)refreshView {
    if ([[ECUser currentUser] isLoggedIn]) {
        [self loadSignedInView];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/list-certificates"];        
    } else {
        [self loadSignedOutView];
    }
}

- (void)loadSignedInView {
    [self.signedOutView removeFromSuperview];
    [self.navigationItem setRightBarButtonItem:nil];
}

- (void)loadSignedOutView {
    self.signedOutView.frame = self.view.frame;
    [self.view addSubview:self.signedOutView];    
    UIBarButtonItem *signinButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign-in" style:UIBarButtonItemStyleDone target:self action:@selector(presentSigninViewController:)];
    [self.navigationItem setRightBarButtonItem:signinButton];
}


#pragma mark - UITableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.activeCertificates.count > 0 && self.expiredCertificates.count > 0) {
        return 2;
    } else if (self.activeCertificates.count > 0 || self.expiredCertificates.count > 0) {
        return 1;
    } else {
        return 0;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.activeCertificates.count > 0) {
        return @"Active certificates";
    } else {
        return @"Expired certificates";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.activeCertificates.count > 0) {
        return self.activeCertificates.count;
    } else {
        return self.expiredCertificates.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CertificateCell"];
    
    ECCertificate *certificate = nil;
    switch (indexPath.section) {
        case 0:
            if (self.activeCertificates.count > 0) {
                certificate = [self.activeCertificates objectAtIndex:[indexPath row]];
            } else {
                certificate = [self.expiredCertificates objectAtIndex:[indexPath row]];
            }
            break;
        default:
            certificate = [self.expiredCertificates objectAtIndex:[indexPath row]];
            break;
    }
    
    cell.clientLabel.text = [certificate.client.name uppercaseString];
    cell.titleLabel.text = certificate.option.name;
    cell.expirationLabel.text = certificate.expiresOnFormatted;
    [cell resizeTitleLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CertificateDetailViewController *certificateDetailViewController = [[CertificateDetailViewController alloc] init];
    certificateDetailViewController.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0 && self.activeCertificates.count > 0) {
        certificateDetailViewController.certificate = [self.activeCertificates objectAtIndex:indexPath.row];
    } else {
        certificateDetailViewController.certificate = [self.expiredCertificates objectAtIndex:indexPath.row];
    }
    
    [self.navigationController pushViewController:certificateDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    [headerView setBackgroundColor:[UIColor certificateListViewHeaderBackgroundColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, tableView.bounds.size.width - 7, 18)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont boldSystemFontOfSize:14.0];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor certificateListViewHeaderBackgroundColor];
    label.shadowColor = [UIColor primaryColor];
    label.shadowOffset = CGSizeMake(0, -1);
    [headerView addSubview:label];
    
    SSLineView *lineView = [[SSLineView alloc] initWithFrame:CGRectMake(0, 21, tableView.bounds.size.width, 1)];
    lineView.lineColor = [UIColor primaryColor];
    [headerView addSubview:lineView];
    
    return headerView;
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)loadCertificatesFromRemote {
    if ([[ECUser currentUser] isLoggedIn]) {
        _hud = [[SSHUDView alloc] initWithTitle:@"Refreshing certificates..."];
        _hud.hudSize = CGSizeMake(220.0f, 100.0f);
        [_hud show];
        NSString *resourcePath = [NSString stringWithFormat:@"/users/%@/certificates", [[ECUser currentUser] userID]];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath delegate:self];
    } else {
        [self clearAllCertificates];
    }
    [self refreshView];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    _activeCertificates = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isValid == TRUE && isExpired == FALSE"]];
    _expiredCertificates = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isExpired == TRUE && isValid == TRUE"]];
    _certificates = objects;
    
    [self.certificatesTableView reloadData];
    [_hud dismissAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [_hud dismiss];
	[[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)clearAllCertificates {
    _activeCertificates = nil;
    _expiredCertificates = nil;
    _certificates = nil;
    [self.certificatesTableView reloadData];
}


#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)additionalViewWillAppearForTableView {
    // Unselect the selected row if any
    NSIndexPath *selection = [self.certificatesTableView indexPathForSelectedRow];
    if (selection) {
        [self.certificatesTableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.certificatesTableView setEditing:editing animated:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.certificatesTableView flashScrollIndicators];
}

@end
