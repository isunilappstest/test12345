//
//  ECEnvironment.m
//  Everlong
//
//  Created by Brian Morton on 12/12/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//
//  This implementation is copied from:
//  https://raw.github.com/RestKit/RKDiscussionBoard/master/DiscussionBoard/Code/Other/DBEnvironment.m

#import "ECEnvironment.h"

/*
 VDD: 888-418-5701
 
 ReaderCity: 866-981-6919
 LoafDeals: 877-502-1337
 */

// Base URL
#if EC_ENVIRONMENT == EC_ENVIRONMENT_DEVELOPMENT
    NSString * const ECRestKitBaseURL = @"http://api.encore.dev:3100/v4";
    NSString * const ECTenantID = @"1";
    NSString * const ECAuthID = @"dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd";
#endif

// Tenant Name
#if EC_TENANT == EC_TENANT_READER_CITY
    const PaymentType kPaymentType = PaymentTypeAuthorizeDotNet;
    BOOL const kSupportsMockingbird = YES;
    BOOL const kSupportsMultipleRegions = NO;
    NSString * const ECTenantName = @"reader_city";
    NSString * const kFacebookAppID = @"353220921357169";
    NSString * const kPropertyName = @"ReaderCity";
    NSString * const kTwitterSuffix = @"at @ReaderCity #SanDiego";

    NSString * const kRedemptionPhoneNumber = @"866-981-6919";

    #if EC_ENVIRONMENT == EC_ENVIRONMENT_PRODUCTION
        NSString * const ECRestKitBaseURL = @"https://api.readercity.com/v4";
        NSString * const ECTenantID = @"9";
        NSString * const ECAuthID = @"66bed92fbc30f85472a72ae805f5308d4224c76e7793e48a9b6d1fe359b52962";
    #endif
#elif EC_TENANT == EC_TENANT_LOAF_DEALS
    const PaymentType kPaymentType = PaymentTypeAuthorizeDotNet;
    BOOL const kSupportsMockingbird = YES;
    BOOL const kSupportsMultipleRegions = NO;
    NSString * const ECTenantName = @"loaf_deals";
    NSString * const kFacebookAppID = @"344158185598510";
    NSString * const kPropertyName = @"Loaf Deal$";
    NSString * const kTwitterSuffix = @"at @LoafDeals #Atlanta";

    NSString * const kRedemptionPhoneNumber = @"877-502-1337";

    #if EC_ENVIRONMENT == EC_ENVIRONMENT_PRODUCTION
        NSString * const ECRestKitBaseURL = @"https://api.loafdeals.com/v4";
        NSString * const ECTenantID = @"3";
        NSString * const ECAuthID = @"4d6d27275235da27f12e873750ffbf33a0d51c3df0c52bab74d2f5130fa6eb29";
    #endif
#elif EC_TENANT == EC_TENANT_VOICE_DAILY_DEALS
    const PaymentType kPaymentType = PaymentTypePCI;
    BOOL const kSupportsMockingbird = YES;
    BOOL const kSupportsMultipleRegions = YES;
    NSString * const ECTenantName = @"voice_daily_deals";
    NSString * const kFacebookAppID = @"123106064425729";
    NSString * const kPropertyName = @"Voice Daily Deals";
    NSString * const kTwitterSuffix = @"at @VOICEDailyDeals";

    NSString * const kRedemptionPhoneNumber = @"888-418-5701";

    #if EC_ENVIRONMENT == EC_ENVIRONMENT_PRODUCTION
        NSString * const ECRestKitBaseURL = @"https://www.voicedailydeals.com/v4"; //USE THIS SHIT NIGGAH
        NSString * const ECTenantID = @"10";
        NSString * const ECAuthID = @"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc";
    #endif
#elif EC_TENANT == EC_TENANT_CL_DEALS
    const PaymentType kPaymentType = PaymentTypePCI;
    BOOL const kSupportsMockingbird = YES;
    BOOL const kSupportsMultipleRegions = NO;
    NSString * const ECTenantName = @"CL_deals";
    NSString * const kFacebookAppID = @"344158185598510";
    NSString * const kPropertyName = @"CL Deals";
    NSString * const kTwitterSuffix = @"at @CL_Deals";

    NSString * const kRedemptionPhoneNumber = @"877-845-1337";

    #if EC_ENVIRONMENT == EC_ENVIRONMENT_PRODUCTION
        NSString * const ECRestKitBaseURL = @"http://cldeals.com/v4";
        NSString * const ECTenantID = @"4";
        NSString * const ECAuthID = @"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc";
    #endif
#elif EC_TENANT == EC_TENANT_READER_REAL_DEAL
    const PaymentType kPaymentType = PaymentTypeAuthorizeDotNet;
    BOOL const kSupportsMockingbird = YES;
    BOOL const kSupportsMultipleRegions = NO;
    NSString * const ECTenantName = @"reader_real_deal";
    NSString * const kFacebookAppID = @"271149442951943";
    NSString * const kPropertyName = @"Reader Real Deal";
    NSString * const kTwitterSuffix = @"at @ReaderRealDeal #Chicago";

    NSString * const kRedemptionPhoneNumber = @"888-418-5701";

    #if EC_ENVIRONMENT == EC_ENVIRONMENT_PRODUCTION
        NSString * const ECRestKitBaseURL = @"https://api.readercity.com/v4";
        NSString * const ECTenantID = @"13";
        NSString * const ECAuthID = @"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc";
    #endif
#endif