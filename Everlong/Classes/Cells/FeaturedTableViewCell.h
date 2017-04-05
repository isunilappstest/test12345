//
//  FeaturedTableViewCell.h
//  Everlong
//
//  Created by Brian Morton on 12/26/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@interface FeaturedTableViewCell : UITableViewCell

- (UILabel *)clientLabel;
- (UILabel *)titleLabel;
- (UILabel *)priceLabel;

- (UIView *)clientBackgroundView;
- (UIView *)titleBackgroundView;
- (UIView *)priceBackgroundView;
- (UIView *)accessoryBackgroundView;

- (HJManagedImageV *)managedImageView;

@end
