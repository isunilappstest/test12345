//
//  PlacementsViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/23/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "PlacementsViewController.h"
#import "FeaturedTableViewCell.h"
#import "ProductDetailViewController.h"
#import "RegionPickerViewController.h"
#import "LocationController.h"
#import "ECPlacement.h"
#import "ELAppDelegate.h"
#import "HJObjManager.h"
#import "ECRegion.h"
#import "LocationController.h"
#import "AnalyticsHelper.h"

// Constants
static NSTimeInterval const kELCurrentLocationTimeoutInterval = 15.0;
static int const kELRegionSelectionButtonMaxLength = 8;

@implementation PlacementsViewController {
    HJObjManager *_objectManager;
    LocationController *_locationController;
    NSTimer *_currentLocationTimer;
    BOOL _awaitingLocationResponse;
    BOOL _regionsLoaded;
    SSHUDView *_hud;
    UIScrollView *_errorScrollView;
    UIView *_tableViewHeader;
    UILabel *_tableViewHeaderLabel;
    UIBarButtonItem *_regionSelectionButton;
}

@synthesize placementsTableView = _placementsTableView;
@synthesize placements = _placements;


#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_nav_title", ECTenantName]]];
        [self.navigationItem setTitleView:imageView];
        // Get the application delegate and the object cache
        ELAppDelegate *appDelegate = (ELAppDelegate *)[[UIApplication sharedApplication] delegate];
        _objectManager = [appDelegate objectManager];
        _locationController = [LocationController sharedInstance];
        _awaitingLocationResponse = YES;
        _regionsLoaded = NO;
        
        if (kSupportsMultipleRegions) {
            _regionSelectionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"city_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(presentRegionSelectorViewController)];
            self.navigationItem.leftBarButtonItem = _regionSelectionButton;
        }
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
        [self setTitle:@"Featured"];
    self.placements = [NSArray array];
    [self buildTableView];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/list-placements"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRegionFromNotification) name:ECRegionDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLocationUpdateAndPresentModal) name:ECLocationDeniedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self locateOrLoadPlacements];
    [self additionalViewWillAppearForTableView];
    self.placementsTableView.frame = CGRectMake(0,0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64); //113
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // If the view is disappearing, we don't want to recieve location callbacks anymore
    _locationController.delegate = nil;
    [_currentLocationTimer invalidate];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)buildTableView {
    _placementsTableView = [[BMShadowedTableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    self.placementsTableView.dataSource = self;
    self.placementsTableView.delegate = self;
    self.placementsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.placementsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_background", ECTenantName]]];
    
    if (kSupportsMultipleRegions) {
        self.placementsTableView.tableHeaderView = self.headerForTableView;
    }
    
    [self.placementsTableView registerNib:[UINib nibWithNibName:@"FeaturedTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeaturedCell"];
    
    [self.view addSubview:self.placementsTableView];
}


#pragma mark - UITableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeaturedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeaturedCell"];
        
    ECPlacement *placement = [self.placements objectAtIndex:[indexPath row]];

    cell.backgroundColor = [UIColor primaryColor];

    cell.clientLabel.text = [placement.product.client.name uppercaseString];
    cell.titleLabel.text = placement.feature.titleWithoutLineBreaks;
    cell.priceLabel.text = placement.lowestPriceInDollars;
    [cell.managedImageView showLoadingWheel];
    [cell.managedImageView setUrl:[NSURL URLWithString:[placement.feature.primaryImage objectForKey:@"large"]]];
    [_objectManager manage:cell.managedImageView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] init];
    ECPlacement *currentPlacement = [self.placements objectAtIndex:[indexPath row]];
    productDetailViewController.placement = currentPlacement;
    productDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ((indexPath.row + 1) == self.placements.count) {
        return 174.0f;
    } else {
        return 179.0f;
    }
}

- (UIView*)headerForTableView {
    if (!_tableViewHeader) {
        _tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.placementsTableView.bounds.size.width, 22)];
        _tableViewHeader.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
        
        _tableViewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _tableViewHeader.bounds.size.width - 7, 22)];
        
        _tableViewHeaderLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _tableViewHeaderLabel.textColor = [UIColor whiteColor];
        _tableViewHeaderLabel.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
        [_tableViewHeader addSubview:_tableViewHeaderLabel];
    }
    
    _tableViewHeaderLabel.text = [[[ECRegion currentRegion] name] uppercaseString];
    
    return _tableViewHeader;
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)loadPlacements {
    NSLog(@"Loading placements...");
    if (!self.placements || self.placements.count == 0) {
        [self removeErrorScrollView];
        _hud = [[SSHUDView alloc] initWithTitle:@"Finding deals..."];
        _hud.hudSize = CGSizeMake(150.0f, 100.0f);
        [_hud show];
    }
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/placements.json?hide_sold_out=1" delegate:self];
}

- (void)loadPlacementsForCurrentRegion {
    NSLog(@"Loading placements for region %@...", [[ECRegion currentRegion] name]);
    if (!self.placements || self.placements.count == 0) {
        [self removeErrorScrollView];
        _hud = [[SSHUDView alloc] initWithTitle:@"Finding deals..."];
        _hud.hudSize = CGSizeMake(150.0f, 100.0f);
        [_hud show];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[[ECRegion currentRegion] resourcePathForPlacements] delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    //NSLog(@"Found deals... objects: %@", objects);
    [_hud dismissAnimated:YES];
    if([objects count] > 0){
        if([[objects objectAtIndex:0] isKindOfClass:[ECRegion class]]){
            // OK WE HAVE REGIONS AND SHOULDNT!!!!!!!!!!!
            [self cancelLocationUpdateAndPresentModal];
            return;
        }
    }
    
    
    
    if ([objectLoader wasSentToResourcePath:@"/regions"]) {
        while (!_locationController.location && _awaitingLocationResponse) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
        [_currentLocationTimer invalidate];
        [ECRegion setCurrentRegion:[ECRegion regionForLocation:_locationController.location]];
        [self loadPlacementsForCurrentRegion];
    } else {
        if (objects.count == 0) {
            [self addErrorScrollView];
        } else {
            _placements = objects;
            [self removeErrorScrollView];
        }
        
        [self.placementsTableView reloadData];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [self addErrorScrollView];
    [_hud dismiss];
    if ([objectLoader wasSentToResourcePath:@"/regions"]) {
        [self cancelLocationUpdateAndPresentModal];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[error localizedDescription]
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}



#pragma mark - Error view helper methods

- (void)addErrorScrollView {
    self.placementsTableView.backgroundColor = [UIColor errorPageBackgroundColor];
    if (kSupportsMultipleRegions) {
        self.placementsTableView.tableHeaderView = nil;
    }
    [self.errorScrollView removeFromSuperview];
    [self.view addSubview:self.errorScrollView];
}

- (void)removeErrorScrollView {
    self.placementsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_background", ECTenantName]]];
    if (kSupportsMultipleRegions) {
        self.placementsTableView.tableHeaderView = self.headerForTableView;
    }
    [self.errorScrollView removeFromSuperview];
}

- (UIScrollView*)errorScrollView {
    if (_errorScrollView == nil) {
        _errorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_no_data_found", ECTenantName]]];
        errorImageView.contentMode = UIViewContentModeTop;
        errorImageView.frame = CGRectMake(0, -170, self.view.frame.size.width, self.view.frame.size.height);
        [_errorScrollView addSubview:errorImageView];
        
        UIButton *reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 310, 100, 35)];
        reloadButton.backgroundColor = [UIColor retryButtonColor];
        [reloadButton setTitle:@"Retry" forState:UIControlStateNormal];
        reloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        reloadButton.titleLabel.textColor = [UIColor whiteColor];
        reloadButton.showsTouchWhenHighlighted = YES;
        [reloadButton addTarget:self action:@selector(locateOrLoadPlacements) forControlEvents:UIControlEventTouchUpInside];
        [_errorScrollView addSubview:reloadButton];
        
        _errorScrollView.contentSize = CGSizeMake(320, 368);
        _errorScrollView.frame = self.view.frame;
    }
    
    return _errorScrollView;
}


#pragma mark - Location and region helper methods

- (void)locateOrLoadPlacements {
    if ([ECRegion currentRegion]) {
        [self loadPlacementsForCurrentRegion];
    } else if (kSupportsMultipleRegions) {
        [self findNearestRegion];
    } else {
        [self loadPlacements];
    }
}   

- (void)findNearestRegion {
    if ([CLLocationManager locationServicesEnabled]) {
        _hud = [[SSHUDView alloc] initWithTitle:@"Updating location..."];
        _hud.hudSize = CGSizeMake(150.0f, 100.0f);
        [_hud show];
        
        // Store all regions in core data so we can query against them
        // once we have a location
        RKObjectManager* objectManager = [RKObjectManager sharedManager];
        [objectManager loadObjectsAtResourcePath:@"/regions.json" delegate:self];
        
        _currentLocationTimer = [NSTimer timerWithTimeInterval:kELCurrentLocationTimeoutInterval target:self selector:@selector(cancelLocationUpdateAndPresentModal) userInfo:nil repeats:NO];
        
        _locationController.delegate = self;
        [_locationController getNewLocationOrSendCurrentLocation];
    } else {
        [self addErrorScrollView];
        [self presentRegionSelectorViewController];
    }
}

- (void)updateRegionFromNotification {
    _placements = nil;
    [self.placementsTableView reloadData];
    _tableViewHeaderLabel.text = [[[ECRegion currentRegion] name] uppercaseString];
}

- (void)cancelLocationUpdateAndPresentModal {
    _awaitingLocationResponse = NO;
    [_hud dismiss];
    if (![ECRegion currentRegion]) {
        [self presentRegionSelectorViewController];
    }
}

- (void)presentRegionSelectorViewController {
    RegionPickerViewController *regionPickerViewController = [[RegionPickerViewController alloc] init];
    regionPickerViewController.placementsViewController = self;
    UINavigationController *regionNavigationController = [[UINavigationController alloc] initWithRootViewController:regionPickerViewController];
    [self presentModalViewController:regionNavigationController animated:YES];
}


#pragma mark - LocationController delegate methods

- (void)locationUpdate:(CLLocation *)location {
    _locationController.delegate = nil;
    _awaitingLocationResponse = NO;
}

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)additionalViewWillAppearForTableView {
    // Unselect the selected row if any
    NSIndexPath *selection = [self.placementsTableView indexPathForSelectedRow];
    if (selection) {
        [self.placementsTableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //	The scrollbars won't flash unless the tableview is long enough.
    [self.placementsTableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.placementsTableView setEditing:editing animated:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.placementsTableView flashScrollIndicators];
}

@end
