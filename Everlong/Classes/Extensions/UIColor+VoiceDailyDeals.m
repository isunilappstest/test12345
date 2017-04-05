//
//  UIColor+VoiceDailyDeals.m
//  Everlong
//
//  Created by Brian Morton on 1/5/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "UIColor+VoiceDailyDeals.h"

@implementation UIColor (VoiceDailyDeals)

+ (UIColor *)primaryColor {
    return [UIColor colorWithRed:52.0/255.0 green:54.0/255.0 blue:137.0/255.0 alpha:1.000];
}

+ (UIColor *)secondaryColor {
    return [UIColor colorWithRed:157.0/255.0 green:196.0/255.0 blue:77.0/255.0 alpha:1.000];
}

+ (UIColor *)tertiaryColor {
    return [UIColor colorWithRed:51.0/255.0 green:103.0/255.0 blue:153.0/255.0 alpha:1.000];
}

+ (UIColor *)highlightColor {
    return [self secondaryColor];
}

+ (UIColor *)listViewBackgroundColor {
    return [UIColor colorWithRed:1.000 green:1.000 blue:0.980 alpha:1.000];
}

+ (UIColor *)highlightedListViewBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)detailBottomViewBackgroundColor {
    return [UIColor colorWithWhite:0.961 alpha:1.000];
}

+ (UIColor *)tabBarSelectedTintColor {
    return [UIColor colorWithRed:165.0/255.0 green:175.0/255.0 blue:215.0/255.0 alpha:1.0];
}

+ (UIColor *)retryButtonColor {
    return [UIColor tertiaryColor];
}

+ (UIColor *)errorPageBackgroundColor {
    return [UIColor colorWithRed:5.0/255.0 green:6.0/255.0 blue:93.0/255.0 alpha:1.0];
}

+ (UIColor *)shadowedTableViewColor {
    return [UIColor colorWithWhite:0.263 alpha:1.000];
}


// Stylesheet - Navigation Bar ---------------------------------------------------------

+ (UIColor *)navigationBarTitleTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBarTitleTextShadowColor {
    return [UIColor blackColor];
}


// Stylesheet - Featured Tab -----------------------------------------------------------

+ (UIColor *)featuredViewPriceContainerColor {
    return [UIColor primaryColor];
}

+ (UIColor *)featuredViewCompanyContainerColor {
    return [UIColor primaryColor];
}

+ (UIColor *)featuredViewTitleContainerColor {
    return [UIColor secondaryColor];
}

+ (UIColor *)featuredViewHighlightColor {
    return [UIColor highlightColor];
}


// Stylesheet - Detail View ------------------------------------------------------------

+ (UIColor *)detailViewPriceContainerColor {
    return [UIColor tertiaryColor];
}

+ (UIColor *)detailViewRetailValueContainerColor {
    return [UIColor primaryColor];
}

+ (UIColor *)detailViewSeperatorColor {
    return [UIColor tertiaryColor];
}

+ (UIColor *)detailViewTitleTextColor {
    return [UIColor tertiaryColor];
}


// Stylesheet - Certificate Detail View ------------------------------------------------

+ (UIColor *)certificateDetailViewCompanyContainerColor {
    return [UIColor primaryColor];
}

+ (UIColor *)certificateDetailViewTitleContainerColor {
    return [UIColor secondaryColor];
}

+ (UIColor *)certificateDetailViewExpirationContainerColor {
    return [UIColor secondaryColor];
}


// Stylesheet - Certificate List View --------------------------------------------------

+ (UIColor *)certificateListViewHeaderBackgroundColor {
    return [UIColor tertiaryColor];
}

@end
