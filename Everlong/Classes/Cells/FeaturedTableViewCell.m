//
//  FeaturedTableViewCell.m
//  Everlong
//
//  Created by Brian Morton on 12/26/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "FeaturedTableViewCell.h"
#import "HJManagedImageV.h"

@implementation FeaturedTableViewCell


#pragma mark - Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareForReuse {
    self.managedImageView.image = nil;
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
        self.clientBackgroundView.backgroundColor = [UIColor featuredViewHighlightColor];
        self.titleBackgroundView.backgroundColor = [UIColor featuredViewHighlightColor];
        self.priceBackgroundView.backgroundColor = [UIColor featuredViewHighlightColor];
    } else {
        self.clientBackgroundView.backgroundColor = [UIColor featuredViewCompanyContainerColor];
        self.titleBackgroundView.backgroundColor = [UIColor featuredViewTitleContainerColor];
        self.priceBackgroundView.backgroundColor = [UIColor featuredViewPriceContainerColor];
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

- (UILabel *)priceLabel {
    return (UILabel *)[self viewWithTag:3];
}

- (UIView *)clientBackgroundView {
    return (UIView *)[self viewWithTag:11];
}

- (UIView *)titleBackgroundView {
    return (UIView *)[self viewWithTag:12];
}

- (UIView *)priceBackgroundView {
    return (UIView *)[self viewWithTag:13];
}

- (UIView *)accessoryBackgroundView {
    return (UIView *)[self viewWithTag:20];
}

- (HJManagedImageV *)managedImageView {
    return (HJManagedImageV *)[self viewWithTag:4];
}


@end
