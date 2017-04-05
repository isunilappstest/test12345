//
//  UIImage+PerTarget.m
//  Everlong
//
//  Created by Brian Morton on 1/13/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "UIImage+PerTarget.h"

@implementation UIImage (PerTarget)

+ (UIImage*)imageForCurrentTargetNamed:(NSString*)imageName {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", ECTenantName, imageName]];
}

@end
