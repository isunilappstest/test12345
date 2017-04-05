//
//  ECUser.h
//  Everlong
//
//  Created by Brian Morton on 12/13/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECPaymentProfile.h"



@protocol ECUserAuthenticationDelegate;

@class ECPaymentProfile;

@interface ECUser : NSManagedObject <RKObjectLoaderDelegate>

@property (nonatomic, retain) NSNumber *userID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *singleAccessToken;
@property (nonatomic, retain) NSSet *paymentProfiles;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) NSObject<ECUserAuthenticationDelegate> *delegate;

- (void)signUpWithDelegate:(NSObject<ECUserAuthenticationDelegate>*)delegate;
- (void)loginWithEmail:(NSString*)email andPassword:(NSString*)password delegate:(NSObject<ECUserAuthenticationDelegate>*)delegate;
- (void)logout;
- (void)sendPasswordReset;
- (BOOL)isLoggedIn;

- (BOOL)hasPaymentProfile;
- (ECPaymentProfile*)firstPaymentProfile;

+ (ECUser*)currentUser;
+ (RKManagedObjectMapping*)objectMapping;
+ (RKObjectMapping*)serializationMapping;

@end

// Notifications
extern NSString * const ECUserDidLoginNotification; // Posted when the User logs in
extern NSString * const ECUserDidLogoutNotification; // Posted when the User logs out
extern NSString * const ECUserDidResetPasswordNotification; // Posted after a password reset request is successful
extern NSString * const ECUserDidFailResetPasswordNotification; // Posted after a password reset fails

@protocol ECUserAuthenticationDelegate

@optional

/**
 * Sent to the delegate when sign up has completed successfully. Immediately
 * followed by an invocation of userDidLogin:
 */
- (void)userDidSignUp:(ECUser*)user;

/**
 * Sent to the delegate when sign up failed for a specific reason
 */
- (void)user:(ECUser*)user didFailSignUpWithError:(NSError*)error;

/**
 * Sent to the delegate when the User has successfully authenticated
 */
- (void)userDidLogin:(ECUser*)user;

/**
 * Sent to the delegate when the User failed login for a specific reason
 */
- (void)user:(ECUser*)user didFailLoginWithError:(NSError*)error;

/**
 * Sent to the delegate when the User logged out of the system
 */
- (void)userDidLogout:(ECUser*)user;

@end