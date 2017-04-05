//
//  ProductDetailViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECPlacement.h"
#import "ECProduct.h"

@class HJManagedImageV;
@class ECOption;

@interface ProductDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *accessoryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessoryDetailLabel;
@property (nonatomic, retain) ECPlacement *placement;
@property (nonatomic, retain) ECProduct *product;
@property (nonatomic, retain) HJManagedImageV *mainImageView;
@property (nonatomic, retain) UITableView *detailSelectorTableView;
@property (retain, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property(nonatomic, retain) IBOutlet UIImageView *shadeView;

@property (nonatomic, retain) IBOutlet UIView *dealTimeContainer;

- (void)addImageToScrollView:(NSString*)imagePath;
- (void)addPriceWithContainer:(NSString*)priceInDollars andMultiplePricePoints:(BOOL)hasMultiplePricePoints;
- (void)addRetailValueWithContainer:(NSString*)retailValueInDollars;
- (void)addSeperatorView;
- (void)addClientName:(NSString*)clientName;
- (void)addTitle:(NSString*)title;
- (void)addHighlights:(NSString*)highlights;
- (void)addDetailSelectorTableView;

- (void)setTimeRemaining:(NSString*)timeRemaining;
- (void)setNumberAvailable:(NSString*)numberAvailable;

- (CGFloat)updateScrollViewHeightBy:(CGFloat)pointsToAdd;
- (IBAction)buyNowButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (void)additionalViewWillAppearForTableView;

- (void)shareByFacebook;
- (void)shareByTwitter;

- (void)pushOptionSelectionViewControllerWithOptions:(NSArray*)options attributesOrNil:(NSArray *)attributes;
- (void)pushCheckoutViewControllerWithOption:(ECOption*)option attributesOrNil:(NSArray *)attributes;

- (BOOL)hasBodyContent;
- (NSString*)bodyContent;
- (NSString*)terms;

@end
