//
//  UILabel+Resizing.h
//  Everlong
//
//  Created by Brian Morton on 12/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Resizing)

- (void)resizeFrameConstrainedToSize:(CGSize)maximumLabelSize;

@end
