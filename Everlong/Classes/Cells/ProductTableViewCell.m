//
//  ProductTableViewCell.m
//  Everlong
//
//  Created by Brian Morton on 12/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setHighlighted:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (animated == YES) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
    }
    
    if (highlighted == YES) {
        self.priceBackgroundView.backgroundColor = [UIColor highlightColor];
        self.accessoryBackgroundView.backgroundColor = [UIColor highlightColor];
        self.coloredBackgroundView.backgroundColor = [UIColor highlightedListViewBackgroundColor];
    } else {
        self.priceBackgroundView.backgroundColor = [UIColor primaryColor];
        self.accessoryBackgroundView.backgroundColor = [UIColor secondaryColor];
        self.coloredBackgroundView.backgroundColor = [UIColor listViewBackgroundColor];
    }
    
    if (animated == YES) {
        [UIView commitAnimations];
    }
}


#pragma mark - View accessors

- (UILabel *)clientLabel {
    return (UILabel *)[self viewWithTag:1];
}

- (UILabel *)titleLabel {
    return (UILabel *)[self viewWithTag:2];
}

- (void)resizeTitleLabel {
    CGRect currentFrame = [self.titleLabel frame];
    CGSize maximumSize = CGSizeMake(currentFrame.size.width, currentFrame.size.height);
    CGSize stringSize = [self.titleLabel.text sizeWithFont:[self.titleLabel font] 
                                         constrainedToSize:maximumSize
                                             lineBreakMode:[self.titleLabel lineBreakMode]];
    
    currentFrame.size.height = stringSize.height;
    [self.titleLabel setFrame:currentFrame];
}

- (UILabel *)priceLabel {
    return (UILabel *)[self viewWithTag:3];
}

- (UIView *)priceBackgroundView {
    return (UIView *)[self viewWithTag:13];
}

- (UILabel *)expirationLabel {
    return (UILabel *)[self viewWithTag:3];
}

- (UIView *)expirationBackgroundView {
    return (UIView *)[self viewWithTag:13];
}

- (UIView *)accessoryBackgroundView {
    return (UIView *)[self viewWithTag:20];
}

- (UIView *)coloredBackgroundView {
    return (UIView *)[self viewWithTag:99];
}

@end
