//
//  UIColor+ReaderCity.m
//  Everlong
//
//  Created by Brian Morton on 12/29/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "UIColor+ReaderCity.h"

@implementation UIColor (ReaderCity)


// Color definitions

+ (UIColor *)primaryColor {
    return [UIColor colorWithRed:77.0/255.0 green:78.0/255.0 blue:83.0/255.0 alpha:1.0];
}

+ (UIColor *)secondaryColor {
    return [UIColor colorWithRed:45.0/255.0 green:155.0/255.0 blue:145.0/255.0 alpha:1.000];
}

+ (UIColor *)tertiaryColor {
    return [UIColor colorWithRed:23.0/255.0 green:37.0/255.0 blue:45.0/255.0 alpha:1.000];
}

+ (UIColor *)highlightColor {
    return [UIColor colorWithRed:158.0/255.0 green:216.0/255.0 blue:213.0/255.0 alpha:1.000];
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
    return [UIColor highlightColor];
}

+ (UIColor *)retryButtonColor {
    return [UIColor primaryColor];
}

+ (UIColor *)errorPageBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)shadowedTableViewColor {
    return [UIColor tertiaryColor];
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
    return [UIColor tertiaryColor];
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
    return [UIColor tertiaryColor];
}

+ (UIColor *)certificateDetailViewExpirationContainerColor {
    return [UIColor tertiaryColor];
}


// Stylesheet - Certificate List View --------------------------------------------------

+ (UIColor *)certificateListViewHeaderBackgroundColor {
    return [UIColor tertiaryColor];
}


@end
