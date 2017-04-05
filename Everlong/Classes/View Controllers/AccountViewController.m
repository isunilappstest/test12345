//
//  AccountViewController.m
//  Everlong
//
//  Created by Brian Morton on 8/11/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "AccountViewController.h"
#import "NewPaymentProfileTableViewController.h"
#import "AnalyticsHelper.h"
#import "PrivacyViewController.h"

@implementation AccountViewController {
	SSHUDView *_hud;
}

@synthesize containerView;
@synthesize signedInView;
@synthesize signedOutView;
@synthesize profiles = _profiles;
@synthesize accountTableView = _accountTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"My Account"];

    }
    return self;
}

#pragma mark - UITableView methods

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DefaultCell";
    static NSString *SubtitleCellIdentifier = @"SubtitleCell";
    
    UITableViewCell *cell;
    
    switch ([indexPath section]) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:SubtitleCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:SubtitleCellIdentifier];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            switch ([indexPath row]) {
                case 0:
                    [[cell textLabel] setText:@"Name"];
                    [[cell detailTextLabel] setText:[[ECUser currentUser] name]];
                    break;

                case 1:
                    [[cell textLabel] setText:@"Email"];
                    [[cell detailTextLabel] setText:[[ECUser currentUser] email]];
                    break;
                    
                case 2:
                    [[cell detailTextLabel] setText:@"Privacy Policy"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
            }

            break;
        default:
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
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:

            return ([self.profiles count] + 1);
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == 2){
            PrivacyViewController *pvc = [[PrivacyViewController alloc] initWithNibName:@"PrivacyView" bundle:nil];
            [self presentModalViewController:pvc animated:YES];
            return;
        }
    }
    
    NSIndexPath *addProfileIndexPath = [NSIndexPath indexPathForRow:[self.profiles count] inSection:1];
    
    if ([indexPath isEqual:addProfileIndexPath]) {
        NewPaymentProfileTableViewController *newProfileController = [[NewPaymentProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:newProfileController animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerString;
    switch (section) {
        case 0: headerString = @"Account Information"; break;
        case 1: headerString = @"Payment Information"; break;
    }
    
    return headerString;
}


#pragma mark - UITableViewDatasource methods

- (void)loadObjectsFromDataStore {
	NSFetchRequest *request = [ECPaymentProfile fetchRequest];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"user == %@", [ECUser currentUser]];
    [request setPredicate:pred];
    
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	_profiles = [ECPaymentProfile objectsWithFetchRequest:request];

    NSMutableArray *validCardData = [NSMutableArray array];
    for(ECPaymentProfile *profile in self.profiles){
        if([[profile name] length] > 1){
            [validCardData addObject: profile];
        }
    }
    _profiles = [NSArray arrayWithArray:validCardData];

    [self.accountTableView reloadData];
}


#pragma mark - View lifecycle

- (void)loadView {
	// create and store a container view
    
	UIView *localContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.containerView = localContainerView;
    
    // Add logic here to determine if user is signed in
    
    // create the signed in view
    NSArray *signedInNibViews =  [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:self options:nil];
    signedInView = [signedInNibViews objectAtIndex:0];

    // create the signed out view
    NSArray *signedOutNibViews =  [[NSBundle mainBundle] loadNibNamed:@"SignedOutView" owner:self options:nil];
    signedOutView = [signedOutNibViews objectAtIndex:0];
    [self refreshView];
    [self setView:containerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/profile"];            
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:ECUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutComplete) name:ECUserDidLogoutNotification object:nil];
    self.accountTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
    if (![[ECUser currentUser] isLoggedIn]) {
        [self presentSigninViewController:nil];
    }
}

- (void)viewDidUnload {
    accountTableView = nil;
    [super viewDidUnload];
}

- (void)refreshView {
    if ([[ECUser currentUser] isLoggedIn]) {
        [self loadSignedInView];
    } else {
        [self loadSignedOutView];
    }
}

- (void)loadSignedInView {
    [[containerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [containerView addSubview:signedInView];
    UIBarButtonItem *signinButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign-out" style:UIBarButtonItemStyleDone target:self action:@selector(logoutUser)];
    [self loadObjectsFromDataStore];
    [self.navigationItem setRightBarButtonItem:signinButton];
}

- (void)loadSignedOutView {
    [[containerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [containerView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:247.0/255.0f blue:247.0/255.0f alpha:1.0f]];
    [containerView addSubview:signedOutView];
    UIBarButtonItem *signinButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign-in" style:UIBarButtonItemStyleDone target:self action:@selector(presentSigninViewController:)];
    [self.navigationItem setRightBarButtonItem:signinButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)presentSigninViewController:(id)sender {
    SigninViewController *signinViewController = [[SigninViewController alloc] init];
    UINavigationController *signinNavigationController = [[UINavigationController alloc] initWithRootViewController:signinViewController];
    [self presentModalViewController:signinNavigationController animated:YES];
}

- (void)logoutUser {
	//_hud = [[SSHUDView alloc] initWithTitle:@"Logging out..."];
    //_hud.hudSize = CGSizeMake(120.0f, 120.0f);
	//[_hud show];
    [[ECUser currentUser] setDelegate:nil];
    [[ECUser currentUser] logout];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/logout"];                    
}

- (void)logoutComplete {
    [self refreshView];
	//[_hud completeWithTitle:@"Logged out!"];
	//[_hud performSelector:@selector(dismiss) withObject:nil afterDelay:0.7];
}


#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"View will appear for signin view controller.");
    self.view.frame = CGRectMake(0,0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-113);

    if ([[ECUser currentUser] isLoggedIn]) {
        [self loadObjectsFromDataStore];
    }


    self.accountTableView.frame = self.view.frame;
        
    // Unselect the selected row if any
    NSIndexPath *selection = [self.accountTableView indexPathForSelectedRow];
    if (selection) {
        [self.accountTableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    //	The scrollbars won't flash unless the tableview is long enough.
    [self.accountTableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.accountTableView setEditing:editing animated:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.accountTableView flashScrollIndicators];
}



@end
