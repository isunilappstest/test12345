//
//  UIImage+PerTarget.h
//  Everlong
//
//  Created by Brian Morton on 1/13/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PerTarget)

+ (UIImage*)imageForCurrentTargetNamed:(NSString*)imageName;

@end
