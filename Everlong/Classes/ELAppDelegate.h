//
//  ELAppDelegate.h
//  Everlong
//
//  Created by Brian Morton on 8/9/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "CategoryPickerViewController.h"
#import "AccountViewController.h"
#import "ECUser.h"
#import "Facebook.h"

@class HJObjManager, Facebook;

@interface ELAppDelegate : UIResponder <UIApplicationDelegate, ECUserAuthenticationDelegate, FBSessionDelegate>

@property(nonatomic, retain) NSURLConnection *appCheck;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) HJObjManager *objectManager;
@property(assign)bool initialLaunch;

- (NSURL *)applicationDocumentsDirectory;
- (void)styleApplication;
- (void)initializeRestKit;
- (void)checkCurrentUser;
- (void)constructViews;
- (void)startLocatingUser;

//Upgrade stuff
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, retain) UIView *upgradeView;
@property(nonatomic, retain) NSDictionary *upgradeData;
-(void)warnWithDictionary:(NSDictionary *)data forceUpgrade:(BOOL) force;

-(IBAction)dismiss:(id)sender;
-(IBAction)upgrade:(id)sender;

@end