//
//  UILabel+Resizing.m
//  Everlong
//
//  Created by Brian Morton on 12/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "UILabel+Resizing.h"

@implementation UILabel (Resizing)

- (void)resizeFrameConstrainedToSize:(CGSize)maximumLabelSize {
    self.lineBreakMode = UILineBreakModeWordWrap;
    self.numberOfLines = 0;
    CGSize expectedLabelSize = [self.text sizeWithFont:self.font 
                                      constrainedToSize:maximumLabelSize 
                                          lineBreakMode:self.lineBreakMode]; 
    CGRect newLabelFrame = self.frame;
    newLabelFrame.size.height = expectedLabelSize.height;
    self.frame = newLabelFrame;
}

@end
