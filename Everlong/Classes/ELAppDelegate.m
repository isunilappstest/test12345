//
//  ELAppDelegate.m
//  Everlong
//
//  Created by Brian Morton on 8/9/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ELAppDelegate.h"
#import "PlacementsViewController.h"
#import "LocationsViewController.h"
#import "CertificatesViewController.h"
#import "LocationController.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"
#import "ECPlacement.h"
#import "ECError.h"
#import "ECTag.h"
#import "ECOrder.h"
#import "ECCertificate.h"
#import "ECLocation.h"
#import "SBJson.h"
#import "AnalyticsHelper.h"


@implementation ELAppDelegate
@synthesize appCheck = _appCheck;
@synthesize responseData = _responseData;
@synthesize upgradeData = _upgradeData;
@synthesize upgradeView = _upgradeView;

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize objectManager = _objectManager;
@synthesize facebook = _facebook;
@synthesize initialLaunch = _initialLaunch;

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/app-suspend"];
}
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    if(self.initialLaunch == NO){
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/app-resume"];
    }
    self.initialLaunch = NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.initialLaunch = YES;

    //RKLogConfigureByName("RestKit", RKLogLevelError);
    //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);


    NSString *url = [NSString stringWithFormat:@"%@/api/appverification?version=%@", ECRestKitBaseURL, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSLog(@"Checking on app validation using url: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"appVersion"];
    self.appCheck = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/app-launch"];
    
    [self styleApplication];
    [self initializeRestKit];
    [self checkCurrentUser];
    [self startLocatingUser];
    
    //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // Setup a cache store
    _objectManager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
    NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/Images"] ;
	HJMOFileCache *fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	[self.objectManager setFileCache:fileCache];
    
    // Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	[fileCache setFileCountLimit:100];
    [fileCache setFileAgeLimit:60*60*24*7]; //1 week
	[fileCache trimCacheUsingBackgroundThread];
    
    // Bring in the stupid Facebook framework
    _facebook = [[Facebook alloc] initWithAppId:kFacebookAppID andDelegate:self];
    
    [self constructViews];
    
    self.window.backgroundColor = [UIColor shadowedTableViewColor];
    self.window.rootViewController = self.tabBarController;
    //[self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)startLocatingUser {
    LocationController *locationController = [LocationController sharedInstance];
    [locationController.locationManager startUpdatingLocation];
}

- (void)styleApplication {
    self.window.backgroundColor = [UIColor primaryColor];
    self.window.tintColor = [UIColor primaryColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; // Was primaryColor
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_nav_bg", ECTenantName]] forBarMetrics:UIBarMetricsDefault];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor tabBarSelectedTintColor]];


    [[UINavigationBar appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor navigationBarTitleTextColor], UITextAttributeTextColor, 
            [UIColor navigationBarTitleTextShadowColor], UITextAttributeTextShadowColor, 
            [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset, 
            nil]];

    [[UITabBarItem appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor whiteColor], UITextAttributeTextColor, 
            [UIColor blackColor], UITextAttributeTextShadowColor, 
            [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset, 
            [UIFont fontWithName:@"Rok" size:0.0], UITextAttributeFont, 
            nil] forState:UIControlStateNormal];



    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor tabBarSelectedTintColor], UITextAttributeTextColor,
      [UIColor blackColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Rok" size:0.0], UITextAttributeFont,
      nil] forState:UIControlStateSelected];


}

- (void)initializeRestKit {
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:ECRestKitBaseURL];
    [manager.requestQueue setShowsNetworkActivityIndicatorWhenBusy:YES];

    [manager.client setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"appVersion"];

    [manager.client setValue:ECTenantID forHTTPHeaderField:kECTenantIDHTTPHeaderField];
    [manager.client setValue:ECAuthID forHTTPHeaderField:kECAuthIDHTTPHeaderField];
    
    manager.acceptMIMEType = RKMIMETypeJSON;
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    manager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"Encore.sqlite"];
    
    [manager.router routeClass:[ECPlacement class] toResourcePath:@"/placements/:placementID"];
    [manager.router routeClass:[ECOrder class] toResourcePath:@"/orders" forMethod:RKRequestMethodPOST];
    [manager.router routeClass:[ECPaymentProfile class] toResourcePath:@"/payment_profiles" forMethod:RKRequestMethodPOST];
    [manager.router routeClass:[ECPaymentProfile class] toResourcePath:@"/payment_profiles" forMethod:RKRequestMethodPUT];
    [manager.router routeClass:[ECTag class] toResourcePath:@"/tags/:tagID/products/?page=1&per_page=5000"];
    [manager.router routeClass:[ECLocation class] toResourcePath:@"/locations"];

	[manager.router routeClass:[ECUser class] toResourcePath:@"/sign_up" forMethod:RKRequestMethodPOST];
	[manager.router routeClass:[ECUser class] toResourcePath:@"/login" forMethod:RKRequestMethodPUT];
    [manager.router routeClass:[ECCertificate class] toResourcePath:@"/certificates/:certificateID/redeem" forMethod:RKRequestMethodPUT];
    [manager.router routeClass:[ECRegion class] toResourcePath:@"/regions"];
    
    
    [manager.mappingProvider setMapping:[ECUser objectMapping] forKeyPath:@"user"];
//    [manager.mappingProvider setMapping:[ECError objectMapping] forKeyPath:@"error"];
    [manager.mappingProvider setSerializationMapping:[ECUser serializationMapping] forClass:[ECUser class]];
    [manager.mappingProvider setMapping:[ECPlacement objectMapping] forKeyPath:@"placements"];
    [manager.mappingProvider setMapping:[ECTag objectMapping] forKeyPath:@"tags"];
    [manager.mappingProvider setMapping:[ECProduct objectMapping] forKeyPath:@"products"];
    [manager.mappingProvider setMapping:[ECLocation objectMapping] forKeyPath:@"locations"];
    [manager.mappingProvider setMapping:[ECPaymentProfile objectMapping] forKeyPath:@"payment_profile"];
    [manager.mappingProvider setMapping:[ECPaymentProfile objectMapping] forKeyPath:@"payment_profiles"];
    [manager.mappingProvider setSerializationMapping:[ECPaymentProfile serializationMapping] forClass:[ECPaymentProfile class]];
    [manager.mappingProvider setMapping:[ECOrder objectMapping] forKeyPath:@"order"];
    [manager.mappingProvider setSerializationMapping:[ECOrder serializationMapping]forClass:[ECOrder class]];
    [manager.mappingProvider setMapping:[ECOrderItem objectMapping] forKeyPath:@"order_items"];
    [manager.mappingProvider setSerializationMapping:[ECOrderItem serializationMapping] forClass:[ECOrderItem class]];
    [manager.mappingProvider setMapping:[ECCertificate objectMapping] forKeyPath:@"certificates"];
    [manager.mappingProvider setMapping:[ECCertificate objectMapping] forKeyPath:@"certificate"];
    [manager.mappingProvider setSerializationMapping:[ECCertificate serializationMapping] forClass:[ECCertificate class]];
    [manager.mappingProvider setMapping:[ECRegion objectMapping] forKeyPath:@"regions"];
}

- (void)constructViews {
    // We need a UITabBarController to control our entire interface
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    self.tabBarController.tabBar.tintColor = [UIColor primaryColor];
    //self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_tabbar_bg", ECTenantName]];



    // First tab: "Featured"
    PlacementsViewController *placementsViewController = [[PlacementsViewController alloc] init];
    UINavigationController *placementsNavigationController = [[UINavigationController alloc] initWithRootViewController:placementsViewController];
    UIImage *featuredIcon = [UIImage imageNamed:@"tab_feature"];
    [placementsNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Featured" image:featuredIcon tag:1]];
    
    // Second tab: "Nearby"
    LocationsViewController *locationsViewController = [[LocationsViewController alloc] init];
    UINavigationController *locationsNavigationController = [[UINavigationController alloc] initWithRootViewController:locationsViewController];
    UIImage *nearbyIcon = [UIImage imageNamed:@"tab_nearby"];
    UITabBarItem *nearByItem = [[UITabBarItem alloc] initWithTitle:@"Nearby" image:nearbyIcon tag:1];
    [locationsNavigationController setTabBarItem:nearByItem];

    
    // Third tab: "Browse"
    CategoryPickerViewController *categoryPickerViewController = [[CategoryPickerViewController alloc] init];
    UINavigationController *browseNavigationController = [[UINavigationController alloc] initWithRootViewController:categoryPickerViewController];
    [browseNavigationController.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    UIImage *browseIcon = [UIImage imageNamed:@"tab_browse"];
    [browseNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Browse" image:browseIcon tag:0]];
    
    // Fourth tab: "Certificates"
    CertificatesViewController *certificatesViewController = [[CertificatesViewController alloc] init];
    UINavigationController *certificatesNavigationController = [[UINavigationController alloc] initWithRootViewController:certificatesViewController];
    UIImage *certificateIcon = [UIImage imageNamed:@"tab_certificates"];
    [certificatesNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Certificates" image:certificateIcon tag:4]];
    
    // Last tab: "My Account"
    AccountViewController *accountViewController = [[AccountViewController alloc] init];
    UINavigationController *accountNavigationController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
    UIImage *accountIcon = [UIImage imageNamed:@"tab_account"];
    [accountNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Account" image:accountIcon tag:4]];
    
    // Add all controllers with tab buttons to the tab bar controller stack
    NSArray *viewControllers = [NSArray arrayWithObjects:placementsNavigationController, locationsNavigationController, browseNavigationController, certificatesNavigationController, accountNavigationController, nil];
    [self.tabBarController setViewControllers:viewControllers];
}

- (void)checkCurrentUser {
    // Register for authentication notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAccessTokenHeaderFromAuthenticationNotification:) name:ECUserDidLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAccessTokenHeaderFromAuthenticationNotification:) name:ECUserDidLogoutNotification object:nil];
    
	// Initialize authenticated access if we have a logged in current User reference
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"version"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] forKey:@"version"];
        ECUser *user = [ECUser currentUser];
        [user logout];
    }else{
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] isEqualToString:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]]){
            [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] forKey:@"version"];
            ECUser *user = [ECUser currentUser];
            [user logout];
        }else{
            ECUser *user = [ECUser currentUser];
            if ([user isLoggedIn]) {
                RKObjectManager *manager = [RKObjectManager sharedManager];
                NSLog(@"Found logged in User record for '%@' [Access Token: %@]", user.email, user.singleAccessToken);
                [manager.client setValue:user.singleAccessToken forHTTPHeaderField:kECAccessTokenHTTPHeaderField];
                
            }   
        }        
    }
    
}

// Watch for login/logout events and set the Access Token HTTP Header
- (void)setAccessTokenHeaderFromAuthenticationNotification:(NSNotification*)notification {
    ECUser *user = (ECUser *) [notification object];
    NSLog(@"Setting access token to %@", user.singleAccessToken);
    [[NSUserDefaults standardUserDefaults] setObject:user.singleAccessToken forKey:kECAccessTokenHTTPHeaderField];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager.client setValue:user.singleAccessToken forHTTPHeaderField:kECAccessTokenHTTPHeaderField];
    
}

- (void)userDidLogin:(ECUser *)user {
    NSLog(@"%@", user);
}

- (void)user:(ECUser *)user didFailLoginWithError:(NSError *)error {
    NSLog(@"%@", user);
    NSLog(@"%@", error);
}


#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



#pragma MARK UPDATE SHIT

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *jsonData = [[NSString alloc] initWithData:_responseData encoding: NSASCIIStringEncoding];
    
    SBJSON *jsonParser = [[SBJSON alloc] init];

    NSDictionary *jsonResult = (NSDictionary *)[jsonParser objectWithString:jsonData error:nil];
    if(jsonResult){
        self.upgradeData = jsonResult;
        if([jsonResult objectForKey:@"switchLevel"] != nil){
            switch([[jsonResult objectForKey:@"switchLevel"] intValue]){
                case 0:
                    //Test
                    //[self warnWithDictionary:jsonResult forceUpgrade:NO];
                    return;
                    break;
                case 1:
                    [self warnWithDictionary:jsonResult forceUpgrade:NO];
                    break;
                case 2:
                    [self warnWithDictionary:jsonResult forceUpgrade:YES];
                    break;
            }
        }
    }
    
}
-(void)warnWithDictionary:(NSDictionary *)data forceUpgrade:(BOOL) force;
{
    UIView *upgradeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.upgradeView = upgradeView;

    //[self.upgradeView setBackgroundColor:[UIColor colorWithRed:210.0f/255 green:210.0f/255 blue:210.0f/255 alpha:1]];
    [self.upgradeView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, [[UIScreen mainScreen] bounds].size.width-60, 280)];
    message.textColor = [UIColor darkGrayColor];
    message.font = [UIFont systemFontOfSize:15];
    message.shadowOffset = CGSizeMake(0, 1);
    message.shadowColor = [UIColor whiteColor];
    message.text = [data objectForKey:@"message"];
    
    //making escaped \n strings into newlines
    NSString *myNewLineStr = @"\n";
    message.text = [message.text stringByReplacingOccurrencesOfString:@"\\n" withString:myNewLineStr];
    
    message.lineBreakMode = UILineBreakModeWordWrap;
    message.backgroundColor = [UIColor clearColor];
    message.numberOfLines = 0;
    [message sizeToFit];
    [self.upgradeView addSubview:message];
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 44)];
    bar.tintColor = [UIColor blackColor];
    [bar setDelegate:self];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"App Update!"];
    if(force == NO){
        UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
        [navItem setLeftBarButtonItem:dismiss];
    }
    
    /*
     UIBarButtonItem *upgrade = [[UIBarButtonItem alloc] initWithTitle:@"Upgrade" style:UIBarButtonItemStylePlain target:self action:@selector(upgrade:)];
     navItem.rightBarButtonItem = upgrade;
     [upgrade release];
     */
    
    
    UIButton *upgradeButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    upgradeButton.frame = CGRectMake(60, 400, 200, 44);
    upgradeButton.titleLabel.font = [UIFont systemFontOfSize:27];
    
    [upgradeButton setBackgroundColor:[UIColor blackColor]];
    [upgradeButton setTitle:@"Update Now!" forState:UIControlStateNormal];
    [upgradeButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    
    [upgradeButton addTarget:self action:@selector(upgrade:) forControlEvents:UIControlEventTouchUpInside];
    [self.upgradeView addSubview:upgradeButton];
    
    
    [bar pushNavigationItem:navItem animated:NO];

    [upgradeView addSubview:bar];
    
    [self.window addSubview:self.upgradeView];
}

-(IBAction)dismiss:(id)sender;
{
    [self.upgradeView removeFromSuperview];
}
-(IBAction)upgrade:(id)sender;
{
    NSLog(@"Upgrade to app with URL: %@", [self.upgradeData objectForKey:@"appUrl"]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.upgradeData objectForKey:@"appUrl"]]];
    //[self.upgradeView removeFromSuperview];
}

@end
