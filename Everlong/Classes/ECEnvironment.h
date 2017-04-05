//
//  ECEnvironment.h
//  Everlong
//
//  Created by Brian Morton on 12/12/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//
//  This implementation is copied from:
//  https://raw.github.com/RestKit/RKDiscussionBoard/master/DiscussionBoard/Code/Other/DBEnvironment.h

/**
 * The Base URL constant. This Base URL is used to initialize RestKit via RKClient
 * or RKObjectManager (which in turn initializes an instance of RKClient). The Base
 * URL is used to build full URL's by appending a resource path onto the end.
 *
 * By abstracting your Base URL into an externally defined constant and utilizing
 * conditional compilation, you can very quickly switch between server environments
 * and produce builds targetted at different backend systems.
 */

typedef enum{
    PaymentTypePCI,
    PaymentTypeAuthorizeDotNet,
}PaymentType;

extern PaymentType const kPaymentType;
extern NSString * const kRedemptionPhoneNumber;

extern NSString * const ECRestKitBaseURL;
extern NSString * const ECTenantName;
extern NSString * const ECTenantID;
extern NSString * const ECAuthID;
extern NSString * const kFacebookAppID;

extern BOOL const kSupportsMockingbird;
extern BOOL const kSupportsMultipleRegions;

extern NSString * const kPropertyName;
extern NSString * const kTwitterSuffix;

static NSString* const kECAccessTokenHTTPHeaderField = @"X-Encore-User-Token";
static NSString* const kECTenantIDHTTPHeaderField = @"X-Encore-Tenant-ID";
static NSString* const kECAuthIDHTTPHeaderField = @"X-Encore-Auth";

// Environments for selecting the API to use
#define EC_ENVIRONMENT_DEVELOPMENT 0
#define EC_ENVIRONMENT_STAGING 1
#define EC_ENVIRONMENT_PRODUCTION 2

// Tenants for setting the X-For-Tenant header and defining images to use
#define EC_TENANT_READER_CITY 0
#define EC_TENANT_LOAF_DEALS 1
#define EC_TENANT_VOICE_DAILY_DEALS 2
#define EC_TENANT_READER_REAL_DEAL 3
#define EC_TENANT_CL_DEALS 4

// Use Production by default
#ifndef EC_ENVIRONMENT
    #define EC_ENVIRONMENT EC_ENVIRONMENT_PRODUCTION
#endif

// Use Reader City by Default
#ifndef EC_TENANT
    #define EC_TENANT EC_TENANT_READER_CITY
#endif


// Define tenant specific imports
#if EC_TENANT == EC_TENANT_READER_CITY
    #import "UIColor+ReaderCity.h"
#elif EC_TENANT == EC_TENANT_LOAF_DEALS
    #import "UIColor+LoafDeals.h"
#elif EC_TENANT == EC_TENANT_VOICE_DAILY_DEALS
    #import "UIColor+VoiceDailyDeals.h"
#elif EC_TENANT == EC_TENANT_READER_REAL_DEAL
    #import "UIColor+ReaderRealDeal.h"
#elif EC_TENANT == EC_TENANT_CL_DEALS
    #import "UIColor+CLDeals.h"
#endif