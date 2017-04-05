//
//  UIColor+VoiceDailyDeals.h
//  Everlong
//
//  Created by Brian Morton on 1/5/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VoiceDailyDeals)

+ (UIColor *)primaryColor;
+ (UIColor *)secondaryColor;
+ (UIColor *)tertiaryColor;
+ (UIColor *)highlightColor;
+ (UIColor *)listViewBackgroundColor;
+ (UIColor *)highlightedListViewBackgroundColor;
+ (UIColor *)tabBarSelectedTintColor;
+ (UIColor *)retryButtonColor;
+ (UIColor *)errorPageBackgroundColor;
+ (UIColor *)shadowedTableViewColor;

+ (UIColor *)navigationBarTitleTextColor;
+ (UIColor *)navigationBarTitleTextShadowColor;

+ (UIColor *)featuredViewPriceContainerColor;
+ (UIColor *)featuredViewCompanyContainerColor;
+ (UIColor *)featuredViewTitleContainerColor;
+ (UIColor *)featuredViewHighlightColor;

+ (UIColor *)detailViewPriceContainerColor;
+ (UIColor *)detailViewRetailValueContainerColor;
+ (UIColor *)detailViewSeperatorColor;
+ (UIColor *)detailViewTitleTextColor;

+ (UIColor *)certificateDetailViewCompanyContainerColor;
+ (UIColor *)certificateDetailViewTitleContainerColor;
+ (UIColor *)certificateDetailViewExpirationContainerColor;

+ (UIColor *)certificateListViewHeaderBackgroundColor;

@end
