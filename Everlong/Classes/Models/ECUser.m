//
//  ECUser.m
//  Everlong
//
//  Created by Brian Morton on 12/13/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ECUser.h"

// Constants
static NSString * const kECUserCurrentUserIDDefaultsKey = @"kDBUserCurrentUserIDDefaultsKey";

// Notifications
NSString * const ECUserDidLoginNotification = @"ECUserDidLoginNotification";
NSString * const ECUserDidFailLoginNotification = @"ECUserDidFailLoginNotification";
NSString * const ECUserDidLogoutNotification = @"ECUserDidLogoutNotification";
NSString * const ECUserDidResetPasswordNotification = @"ECUserDidResetPasswordNotification";
NSString * const ECUserDidFailResetPasswordNotification = @"ECUserDidFailResetPasswordNotification";

// Singletons
static ECUser *currentUser = nil;
static RKManagedObjectMapping *objectMapping = nil;
static RKObjectMapping *serializationMapping = nil;

@implementation ECUser

@dynamic userID;
@dynamic name;
@dynamic email;
@dynamic singleAccessToken;
@dynamic paymentProfiles;
@synthesize password = _password;
@synthesize delegate = _delegate;


#pragma mark - Class methods

+ (ECUser*)currentUser {
	if (currentUser == nil) {
        // If the user has previously logged in, we should have all this information locally
		id userID = [[NSUserDefaults standardUserDefaults] objectForKey:kECUserCurrentUserIDDefaultsKey];
		if (userID) {
            currentUser = [self findFirstByAttribute:@"userID" withValue:userID];
		}
        
        // If the user is not logged in, pass back a usable empty object.
        // Also, if for some reason we have a default key set, but no record available, lets start over.
        if (currentUser == nil) {
            // Clear the stored credentials
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kECUserCurrentUserIDDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            currentUser = [self object];
        }else{
            currentUser.singleAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kECAccessTokenHTTPHeaderField];
        }
	}
    
	return currentUser;
}

+ (void)setCurrentUser:(ECUser*)user {
	currentUser = user;
}

+ (RKManagedObjectMapping*)objectMapping {
    if (objectMapping == nil) {
        objectMapping = [RKManagedObjectMapping mappingForClass:self];
        objectMapping.primaryKeyAttribute = @"userID";
        objectMapping.setNilForMissingRelationships = YES;
        [objectMapping mapKeyPath:@"id" toAttribute:@"userID"];
        [objectMapping mapKeyPath:@"authentication_token" toAttribute:@"singleAccessToken"];
        [objectMapping mapAttributes:@"name", @"email", nil];
        [objectMapping mapKeyPath:@"payment_profiles" toRelationship:@"paymentProfiles" withMapping:[ECPaymentProfile objectMapping]];
    }
    return objectMapping;
}

+ (RKObjectMapping*)serializationMapping {
    if (serializationMapping == nil) {
        serializationMapping = [RKObjectMapping serializationMapping];
        serializationMapping.rootKeyPath = @"user";
        [serializationMapping mapKeyPath:@"email" toAttribute:@"email"];
        [serializationMapping mapKeyPath:@"password" toAttribute:@"password"];
        [serializationMapping mapKeyPath:@"name" toAttribute:@"name"];
    }
    return serializationMapping;
}


#pragma mark - Login/logout/signup methods

- (void)signUpWithDelegate:(NSObject<ECUserAuthenticationDelegate>*)delegate {
	_delegate = delegate;
	[[RKObjectManager sharedManager] postObject:self delegate:self block:^(RKObjectLoader* loader) {
        loader.resourcePath = @"/sign_up";

        loader.serializationMapping = [RKObjectMapping serializationMappingWithBlock:^(RKObjectMapping* mapping) {
            mapping.rootKeyPath = @"user";
            [mapping mapAttributes:@"email", @"password", @"name", nil];
        }];

    }];
}

- (void)loginWithEmail:(NSString*)email andPassword:(NSString*)password delegate:(NSObject<ECUserAuthenticationDelegate>*)delegate {
	_delegate = delegate;
    self.email = email;
    self.password = password;
    
    [[RKObjectManager sharedManager] postObject:self delegate:self block:^(RKObjectLoader* loader) {
        loader.resourcePath = @"/login";
        loader.serializationMapping = [RKObjectMapping serializationMappingWithBlock:^(RKObjectMapping* mapping) {
            mapping.rootKeyPath = @"user";
            [mapping mapAttributes:@"email", @"password", nil];
        }];
        
    }];
}

- (void)logout {
    [[RKObjectManager sharedManager] postObject:self delegate:self block:^(RKObjectLoader* loader) {
        loader.resourcePath = @"/logout";
        loader.serializationMapping = [RKObjectMapping serializationMappingWithBlock:^(RKObjectMapping* mapping) {
            mapping.rootKeyPath = @"user";
        }];
    }];
}

- (void)sendPasswordReset {
    [[RKObjectManager sharedManager] postObject:self delegate:self block:^(RKObjectLoader* loader) {
        loader.resourcePath = @"/users/reset_password";
        loader.serializationMIMEType = RKMIMETypeFormURLEncoded;
        loader.serializationMapping = [RKObjectMapping serializationMappingWithBlock:^(RKObjectMapping *mapping) {
            [mapping mapKeyPath:@"email" toAttribute:@"email"];
        }];
    }];
}

- (void)loginWasSuccessful {
	// Upon login, we become the current user
	[ECUser setCurrentUser:self];
    
	// Persist the UserID for recovery later
	[[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:kECUserCurrentUserIDDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	// Inform the delegate
	if ([self.delegate respondsToSelector:@selector(userDidLogin:)]) {
		[self.delegate userDidLogin:self];
	}
    
	[[NSNotificationCenter defaultCenter] postNotificationName:ECUserDidLoginNotification object:self];
}

- (BOOL)isLoggedIn {
	return self.singleAccessToken != nil;
}

#pragma mark - Payment profile methods

- (BOOL)hasPaymentProfile {
    if([ECPaymentProfile findByAttribute:@"paymentProfileID" withValue:self.userID].count < 1){
        return NO;
    }
    ECPaymentProfile *paymentProfile = [[ECPaymentProfile findByAttribute:@"paymentProfileID" withValue:self.userID] objectAtIndex:0];
    
    return !!paymentProfile;
}

- (ECPaymentProfile *)firstPaymentProfile {
   return [[ECPaymentProfile findByAttribute:@"paymentProfileID" withValue:self.userID] objectAtIndex:0];
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	// NOTE: We don't need objects because self is the target of the mapping operation
    
	if ([objectLoader wasSentToResourcePath:@"/login"]) {
		// Login was successful
		[self loginWasSuccessful];
	} else if ([objectLoader wasSentToResourcePath:@"/sign_up"]) { 
		// Sign Up was successful
		if ([self.delegate respondsToSelector:@selector(userDidSignUp:)]) {
			[self.delegate userDidSignUp:self];
		}
        
		// Complete the login as well   
		[self loginWasSuccessful];
	} else if ([objectLoader wasSentToResourcePath:@"/logout"]) {
		// Logout was successful
        
		// Clear the stored credentials
		[[NSUserDefaults standardUserDefaults] setValue:nil forKey:kECUserCurrentUserIDDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
		// Inform the delegate
		if ([self.delegate respondsToSelector:@selector(userDidLogout:)]) {
			[self.delegate userDidLogout:self];
		}
        
		[[NSNotificationCenter defaultCenter] postNotificationName:ECUserDidLogoutNotification object:nil]; 
	} else if ([objectLoader wasSentToResourcePath:@"/users/reset_password"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ECUserDidResetPasswordNotification object:nil]; 
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NSLog(@"%@", objectLoader.response.bodyAsString);
	if ([objectLoader wasSentToResourcePath:@"/login"]) {
		// Login failed
        [ECUser setCurrentUser:[ECUser object]];
		if ([self.delegate respondsToSelector:@selector(user:didFailLoginWithError:)]) {
			[self.delegate user:self didFailLoginWithError:error];
		}
	} else if ([objectLoader wasSentToResourcePath:@"/sign_up"]) {
		// Sign Up failed
		if ([self.delegate respondsToSelector:@selector(user:didFailSignUpWithError:)]) {
			[self.delegate user:self didFailSignUpWithError:error];
		}
	} else if ([objectLoader wasSentToResourcePath:@"/logout"]) {
        [ECUser setCurrentUser:[ECUser object]];
        
        // Clear the stored credentials
		[[NSUserDefaults standardUserDefaults] setValue:nil forKey:kECUserCurrentUserIDDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
		// Inform the delegate
		if ([self.delegate respondsToSelector:@selector(userDidLogout:)]) {
			[self.delegate userDidLogout:self];
		}
        
		[[NSNotificationCenter defaultCenter] postNotificationName:ECUserDidLogoutNotification object:nil]; 
    } else if ([objectLoader wasSentToResourcePath:@"/users/reset_password"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ECUserDidFailResetPasswordNotification object:nil]; 
    }
}


- (NSString*)description {
    return [NSString stringWithFormat:@"%@: %@ (%@)", [self userID], [self email], [self singleAccessToken]];
}


@end
