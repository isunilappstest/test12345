//
//  UIColor+CLDeals.m
//  Everlong
//
//  Created by Todd Sternisha on 8/27/13.
//  Copyright (c) 2013 The San Diego Reader. All rights reserved.
//

#import "UIColor+LoafDeals.h"

@implementation UIColor (CLDeals)

+ (UIColor *)primaryColor {
    return [UIColor colorWithRed:55.0/255.0 green:103/255.0 blue:41/255.0 alpha:1.000];
}

+ (UIColor *)secondaryColor {
    return [UIColor colorWithRed:82.0/255.0 green:166/255.0 blue:65/255.0 alpha:1.000];
}

+ (UIColor *)tertiaryColor {
    return [UIColor colorWithRed:23.0/255.0 green:37.0/255.0 blue:45.0/255.0 alpha:1.000];
}

+ (UIColor *)highlightColor {
    return [UIColor blackColor];
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
    return [UIColor colorWithRed:255.0/255.0 green:220.0/255.0 blue:1.0/255.0 alpha:1.0];
}

+ (UIColor *)retryButtonColor {
    return [UIColor primaryColor];
}

+ (UIColor *)errorPageBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)shadowedTableViewColor {
    return [UIColor colorWithRed:0.125 green:0.204 blue:0.200 alpha:1.000];
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
