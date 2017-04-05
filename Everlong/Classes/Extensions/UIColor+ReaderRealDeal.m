//
//  UIColor+ReaderRealDeal.m
//  Everlong
//
//  Created by Brian Morton on 2/15/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "UIColor+ReaderRealDeal.h"

@implementation UIColor (ReaderRealDeal)

// Color definitions

+ (UIColor *)primaryColor {
    return [UIColor colorWithRed:35.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.000];
}

+ (UIColor *)secondaryColor {
    return [UIColor colorWithRed:121.0/255.0 green:137.0/255.0 blue:142.0/255.0 alpha:1.0];
}

+ (UIColor *)tertiaryColor {
    return [UIColor colorWithRed:41.0/255.0 green:197.0/255.0 blue:245.0/255.0 alpha:1.000];
}

+ (UIColor *)highlightColor {
    return [UIColor tertiaryColor];
}

+ (UIColor *)listViewBackgroundColor {
    return [UIColor colorWithRed:1.000 green:1.000 blue:0.980 alpha:1.000];
}

+ (UIColor *)highlightedListViewBackgroundColor {
    return [UIColor colorWithWhite:0.961 alpha:1.000];
}

+ (UIColor *)detailBottomViewBackgroundColor {
    return [UIColor colorWithWhite:0.8 alpha:1.000];
}

+ (UIColor *)tabBarSelectedTintColor {
    return [UIColor colorWithRed:255.0/255.0 green:212.0/255.0 blue:58.0/255.0 alpha:1.0];
}

+ (UIColor *)retryButtonColor {
    return [UIColor primaryColor];
}

+ (UIColor *)errorPageBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)shadowedTableViewColor {
    return [UIColor primaryColor];
}


// Stylesheet - Navigation Bar ---------------------------------------------------------

+ (UIColor *)navigationBarTitleTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)navigationBarTitleTextShadowColor {
    return [UIColor colorWithRed:254.0/255.0 green:246.0/255.0 blue:191.0/255.0 alpha:1.0];
}


// Stylesheet - Featured Tab -----------------------------------------------------------

+ (UIColor *)featuredViewPriceContainerColor {
    return [UIColor primaryColor];
}

+ (UIColor *)featuredViewCompanyContainerColor {
    return [UIColor secondaryColor];
}

+ (UIColor *)featuredViewTitleContainerColor {
    return [UIColor primaryColor];
}

+ (UIColor *)featuredViewHighlightColor {
    return [UIColor highlightColor];
}


// Stylesheet - Detail View ------------------------------------------------------------

+ (UIColor *)detailViewPriceContainerColor {
    return [UIColor secondaryColor];
}

+ (UIColor *)detailViewRetailValueContainerColor {
    return [UIColor primaryColor];
}

+ (UIColor *)detailViewSeperatorColor {
    return [UIColor secondaryColor];
}

+ (UIColor *)detailViewTitleTextColor {
    return [UIColor secondaryColor];
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
    return [UIColor primaryColor];
}

@end
