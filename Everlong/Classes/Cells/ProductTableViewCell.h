//
//  ProductTableViewCell.h
//  Everlong
//
//  Created by Brian Morton on 12/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

- (UILabel *)clientLabel;
- (UILabel *)titleLabel;
- (void)resizeTitleLabel;
- (UILabel *)priceLabel;
- (UILabel *)expirationLabel;

- (UIView *)priceBackgroundView;
- (UIView *)accessoryBackgroundView;
- (UIView *)coloredBackgroundView;
- (UIView *)expirationBackgroundView;

@end
