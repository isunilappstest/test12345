//
//  ProductDetailViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <Twitter/Twitter.h>
#import "ProductTextViewController.h"
#import "ProductLocationsViewController.h"
#import "CheckoutViewController.h"
#import "OptionSelectionViewController.h"
#import "HJManagedImageV.h"
#import "ELAppDelegate.h"
#import "HJObjManager.h"
#import "AnalyticsHelper.h"

@implementation ProductDetailViewController {
    HJObjManager *_objectManager;
    NSArray *_locations;
    NSString *_sharingTitle;
    NSString *_sharingLink;
    NSString *_sharingImage;
}

@synthesize scrollView = _scrollView;
@synthesize accessoryTitleLabel = _accessoryTitleLabel;
@synthesize accessoryDetailLabel = _accessoryDetailLabel;
@synthesize product = _product;
@synthesize placement = _placement;
@synthesize mainImageView = _mainImageView;
@synthesize detailSelectorTableView = _detailSelectorTableView;
@synthesize buyButton = _buyButton;
@synthesize shareButton = _shareButton;
@synthesize dealTimeContainer = _dealTimeContainer;
@synthesize shadeView = _shadeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Details";
        
        // Get the application delegate and the object cache
        ELAppDelegate *appDelegate = (ELAppDelegate *)[[UIApplication sharedApplication] delegate];
        _objectManager = [appDelegate objectManager];
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/detail-placement"];                
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [self additionalViewWillAppearForTableView];
    [self.scrollView flashScrollIndicators];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    self.scrollView.frame = self.view.frame;

    

    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 0);
 
    self.buyButton.frame = CGRectMake(self.buyButton.frame.origin.x, [UIScreen mainScreen].bounds.size.height-self.buyButton.frame.size.height-64, self.buyButton.frame.size.width, self.buyButton.frame.size.height);
    self.dealTimeContainer.frame = CGRectMake(self.dealTimeContainer.frame.origin.x, [UIScreen mainScreen].bounds.size.height-self.dealTimeContainer.frame.size.height-64, self.dealTimeContainer.frame.size.width, self.dealTimeContainer.frame.size.height);
    self.shadeView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.shadeView.frame.size.height-self.dealTimeContainer.frame.size.height-64, self.shadeView.frame.size.width, self.shadeView.frame.size.height);
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height-30);

    [self.buyButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_buy_now_button", ECTenantName]] forState:UIControlStateNormal];
    [self.buyButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_buy_now_button_highlight", ECTenantName]] forState:UIControlStateHighlighted];
    
    [self.shareButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_share_button", ECTenantName]] forState:UIControlStateNormal];
    
    self.accessoryTitleLabel.textColor = [UIColor primaryColor];
    self.accessoryDetailLabel.textColor = [UIColor primaryColor];
    
    if (self.placement != nil) {
        _locations = [self.placement.product.locations allObjects];
        _sharingTitle = self.placement.feature.title;
        _sharingLink = self.placement.fullURL;
        _sharingImage = [self.placement.feature.primaryImage objectForKey:@"medium"];
        [self addImageToScrollView:[self.placement.feature.primaryImage objectForKey:@"medium"]];
        [self addPriceWithContainer:self.placement.lowestPriceInDollars andMultiplePricePoints:self.placement.hasMultiplePricePoints];
        [self addRetailValueWithContainer:self.placement.lowestRetailValueInDollars];
        [self addSeperatorView];
        [self addClientName:[self.placement.product.client.name uppercaseString]];
        [self addTitle:self.placement.feature.title];
        [self addHighlights:self.placement.feature.highlights];
        [self setTimeRemaining:self.placement.timeRemaining];
        [self addDetailSelectorTableView];
    } else {
        _locations = [self.product.locations allObjects];
        _sharingTitle = [NSString stringWithFormat:@"%@ from %@", self.product.name, self.product.client.name];
        _sharingLink = self.product.fullURL;
        _sharingImage = [self.product.primaryImage objectForKey:@"medium"];
        [self addImageToScrollView:[self.product.primaryImage objectForKey:@"medium"]];
        [self addPriceWithContainer:self.product.lowestPriceInDollars andMultiplePricePoints:self.product.hasMultiplePricePoints];
        [self addRetailValueWithContainer:self.product.lowestRetailValueInDollars];
        [self addSeperatorView];
        [self addClientName:[self.product.client.name uppercaseString]];
        [self addTitle:self.product.name];
        [self addHighlights:self.product.highlights];
        [self setNumberAvailable:[self.product.numberAvailable stringValue]];
        [self addDetailSelectorTableView];
    }
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setAccessoryTitleLabel:nil];
    [self setAccessoryDetailLabel:nil];
    [self setBuyButton:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View building helper methods

- (void)addImageToScrollView:(NSString*)imagePath {
    // Deal placeholder image
    UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deal_image_bg"]];
    [placeholderImageView setFrame:CGRectMake(0, 0, 320, 180)];
    [self.scrollView addSubview:placeholderImageView];
    
    // Deal image
    _mainImageView = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
    [self.mainImageView setUrl:[NSURL URLWithString:imagePath]];
    [_objectManager manage:self.mainImageView];
    
    [self.scrollView addSubview:self.mainImageView];
    [self updateScrollViewHeightBy:180.0f];
}

- (void)addPriceWithContainer:(NSString*)priceInDollars andMultiplePricePoints:(BOOL)hasMultiplePricePoints {
    CGRect containerFrame = CGRectMake(0, 130, 100, 50);
    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    containerView.backgroundColor = [UIColor detailViewPriceContainerColor];

    CGRect upperLabelFrame = CGRectMake(12, 4, 76, 13);
    UILabel *upperPriceLabel = [[UILabel alloc] initWithFrame:upperLabelFrame];
    upperPriceLabel.font = [UIFont systemFontOfSize:11.0];
    upperPriceLabel.textColor = [UIColor whiteColor];
    upperPriceLabel.backgroundColor = [UIColor detailViewPriceContainerColor];
    upperPriceLabel.textAlignment = UITextAlignmentCenter;
    upperPriceLabel.text = (hasMultiplePricePoints ? @"Starting at" : @"Only");
    upperPriceLabel.shadowColor = [UIColor primaryColor];
    upperPriceLabel.shadowOffset = CGSizeMake(0, -1);
    [containerView addSubview:upperPriceLabel];
    
    CGRect labelFrame = CGRectMake(12, 18, 76, 28);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:labelFrame];
    priceLabel.font = [UIFont boldSystemFontOfSize:32.0];
    priceLabel.minimumFontSize = 20.0;
    priceLabel.adjustsFontSizeToFitWidth = YES;
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.backgroundColor = [UIColor detailViewPriceContainerColor];
    priceLabel.textAlignment = UITextAlignmentCenter;
    priceLabel.text = priceInDollars;
    priceLabel.shadowColor = [UIColor primaryColor];
    priceLabel.shadowOffset = CGSizeMake(0, -1);
    [containerView addSubview:priceLabel];
    
    [self.scrollView addSubview:containerView];
}

- (void)addRetailValueWithContainer:(NSString*)retailValueInDollars {
    CGRect containerFrame = CGRectMake(100, 158, 100, 27);
    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    containerView.backgroundColor = [UIColor detailViewRetailValueContainerColor];
    
    CGRect labelFrame = CGRectMake(10, 3, 80, 15);
    UILabel *retailValueLabel = [[UILabel alloc] initWithFrame:labelFrame];
    retailValueLabel.font = [UIFont systemFontOfSize:12.0];
    retailValueLabel.minimumFontSize = 10.0;
    retailValueLabel.adjustsFontSizeToFitWidth = YES;
    retailValueLabel.textColor = [UIColor whiteColor];
    retailValueLabel.backgroundColor = [UIColor detailViewRetailValueContainerColor];
    retailValueLabel.textAlignment = UITextAlignmentCenter;
    retailValueLabel.text = [NSString stringWithFormat:@"regularly %@", retailValueInDollars];
    retailValueLabel.shadowColor = [UIColor colorWithWhite:30.0/255.0 alpha:1.0];
    retailValueLabel.shadowOffset = CGSizeMake(0, -1);
    [containerView addSubview:retailValueLabel];
    
    [self.scrollView addSubview:containerView];
}

- (void)addSeperatorView {
    CGRect containerFrame = CGRectMake(0, 180, 320, 5);
    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    containerView.backgroundColor = [UIColor detailViewSeperatorColor];
    [self.scrollView addSubview:containerView];
    [self updateScrollViewHeightBy:5.0f];
}

- (void)addClientName:(NSString*)clientName {
    CGFloat labelTopPadding = 10;
    CGFloat labelBottomPadding = 0;
    CGFloat labelLeftRightPadding = 12.0;
    
    CGRect containerFrame = CGRectMake(0, self.scrollView.contentSize.height, 320, 0);
    CGRect labelFrame = CGRectMake(labelLeftRightPadding, labelTopPadding, (320 - (labelLeftRightPadding * 2)), 0);
    
    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    containerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont boldSystemFontOfSize:22.0f];
    label.textColor = [UIColor primaryColor];
    [containerView addSubview:label];
    
    label.text = clientName;
    [label resizeFrameConstrainedToSize:CGSizeMake(296, 999999)];
    
    CGRect newContainerFrame = containerView.frame;
    newContainerFrame.size.height = label.frame.size.height + (labelTopPadding + labelBottomPadding);
    containerView.frame = newContainerFrame;
    
    [self.scrollView addSubview:containerView];
    [self updateScrollViewHeightBy:newContainerFrame.size.height];
}


- (void)addTitle:(NSString*)title {
    CGFloat labelTopPadding = 0;
    CGFloat labelBottomPadding = 0;
    CGFloat labelLeftRightPadding = 12.0;
    
    CGRect containerFrame = CGRectMake(0, self.scrollView.contentSize.height, 320, 0);
    CGRect labelFrame = CGRectMake(labelLeftRightPadding, labelTopPadding, (320 - (labelLeftRightPadding * 2)), 0);
    
    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    containerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.textColor = [UIColor detailViewTitleTextColor];
    [containerView addSubview:label];
    
    label.text = title;
    [label resizeFrameConstrainedToSize:CGSizeMake(296, 999999)];
    
    CGRect newContainerFrame = containerView.frame;
    newContainerFrame.size.height = label.frame.size.height + (labelTopPadding + labelBottomPadding);
    containerView.frame = newContainerFrame;
    
    [self.scrollView addSubview:containerView];
    [self updateScrollViewHeightBy:newContainerFrame.size.height];
}

- (void)addHighlights:(NSString*)featureBody {
    CGFloat labelTopBottomPadding = 10.0;
    CGFloat labelLeftRightPadding = 12.0;
    
    CGRect containerFrame = CGRectMake(0, self.scrollView.contentSize.height, 320, 0);
    CGRect labelFrame = CGRectMake(labelLeftRightPadding, labelTopBottomPadding, (320 - (labelLeftRightPadding * 2)), 0);
    
    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    containerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont systemFontOfSize:14.0f];
    [containerView addSubview:label];
    
    label.text = featureBody;
    [label resizeFrameConstrainedToSize:CGSizeMake(296, 999999)];
    
    CGRect newContainerFrame = containerView.frame;
    newContainerFrame.size.height = label.frame.size.height + (labelTopBottomPadding * 2);
    containerView.frame = newContainerFrame;
    
    [self.scrollView addSubview:containerView];
    [self updateScrollViewHeightBy:newContainerFrame.size.height];
}

- (void)addDetailSelectorTableView {
    CGFloat tableViewHeight = 160;
    CGRect tableViewFrame = CGRectMake(0, self.scrollView.contentSize.height, 320, tableViewHeight);
    _detailSelectorTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.detailSelectorTableView.delegate = self;
    self.detailSelectorTableView.dataSource = self;
    self.detailSelectorTableView.scrollEnabled = NO;
    
    
    SSLineView *headerLine = [[SSLineView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    headerLine.lineColor = [UIColor colorWithWhite:0.878 alpha:1.000];
    self.detailSelectorTableView.tableHeaderView = headerLine;
    
    [self.scrollView addSubview:self.detailSelectorTableView];
    [self updateScrollViewHeightBy:tableViewHeight];
}

- (void)setTimeRemaining:(NSString *)timeRemaining {
    self.accessoryTitleLabel.text = timeRemaining;
    self.accessoryDetailLabel.text = @"remaining";
}

- (void)setNumberAvailable:(NSString *)numberAvailable {
    self.accessoryTitleLabel.text = (numberAvailable ? numberAvailable : @"unlimited");
    self.accessoryDetailLabel.text = @"available";
}


#pragma mark - Construction helper methods

- (CGFloat)updateScrollViewHeightBy:(CGFloat)pointsToAdd {
    CGSize newContentSize = self.scrollView.contentSize;
    newContentSize.height = newContentSize.height + pointsToAdd;
    self.scrollView.contentSize = newContentSize;
    return newContentSize.height;
}


#pragma mark - UITableView delegate and datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self hasBodyContent]) {
        return 3;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"ProductDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Locations";
            break;
        case 1:
            cell.textLabel.text = @"Fine Print";
            break;
        case 2:
            cell.textLabel.text = @"Read More";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ProductLocationsViewController *viewController = [[ProductLocationsViewController alloc] init];
        viewController.locations = _locations;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 1) {
        ProductTextViewController *termsController = [[ProductTextViewController alloc] init];
        termsController.terms = self.terms;
        [self.navigationController pushViewController:termsController animated:YES];
    } else if (indexPath.row == 2) {
        ProductTextViewController *bodyController = [[ProductTextViewController alloc] init];
        bodyController.body = self.bodyContent;
        [self.navigationController pushViewController:bodyController animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)additionalViewWillAppearForTableView {
    // Unselect the selected row if any
    NSIndexPath *selection = [self.detailSelectorTableView indexPathForSelectedRow];
    if (selection) {
        [self.detailSelectorTableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //	The scrollbars won't flash unless the tableview is long enough.
    [self.detailSelectorTableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.detailSelectorTableView setEditing:editing animated:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.detailSelectorTableView flashScrollIndicators];
}


#pragma mark - Helper methods

- (BOOL)hasBodyContent {
    return (self.placement.feature.body || self.product.bodyDescription);
}

- (NSString*)bodyContent {
    if (self.placement.feature.body) {
        return self.placement.feature.body;
    } else if (self.product.bodyDescription) {
        return self.product.bodyDescription;
    } else {
        return @"";
    }
}

- (NSString*)terms {
    if (self.placement.product.terms) {
        return self.placement.product.terms;
    } else if (self.product.terms) {
        return self.product.terms;
    } else {
        return @"";
    }
}


#pragma mark - Sharing methods

- (IBAction)shareButtonPressed:(id)sender {
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:@"Share Deal"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel" 
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Facebook", 
                                                                     @"Twitter",  nil];
    [shareSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [shareSheet showInView:self.view];
}

- (void)shareByFacebook {
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _sharingTitle, @"name",
                                   [NSString stringWithFormat:@"presented by %@", kPropertyName], @"caption",
                                   @"Check out this sweet deal and download the mobile app to find deals on the go for yourself!", @"description",
                                   _sharingLink, @"link",
                                   _sharingImage, @"picture",
                                   nil];
    
    ELAppDelegate *delegate = (ELAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.facebook dialog:@"feed" andParams:params andDelegate:nil];
}

- (void)shareByTwitter {
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweetVC = [[TWTweetComposeViewController alloc] init];
        [tweetVC setInitialText:[NSString stringWithFormat:@"%@ %@", _sharingTitle, kTwitterSuffix]];
        [tweetVC addURL:[NSURL URLWithString:_sharingLink]];
        [self.navigationController presentModalViewController:tweetVC animated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Sorry, we can't send your tweet until you go to Settings and configure Twitter."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


#pragma mark - UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self shareByFacebook];
            break;
        case 1:
            [self shareByTwitter];
            break;
    }
}


#pragma mark - Purchasing methods

- (IBAction)buyNowButtonPressed:(id)sender {
    ECProduct *currentProduct = nil;
    
    if (self.placement != nil) {
        currentProduct = self.placement.product;
    } else {
        currentProduct = self.product;
    }
    
    if (currentProduct.options.count > 1) {
        [self pushOptionSelectionViewControllerWithOptions:currentProduct.options attributesOrNil:currentProduct.attributes];
    } else {
        [self pushCheckoutViewControllerWithOption:[currentProduct.options objectAtIndex:0] attributesOrNil:currentProduct.attributes];
    }
}

- (void)pushOptionSelectionViewControllerWithOptions:(NSArray*)options attributesOrNil:(NSArray *)attributes;
{
    OptionSelectionViewController *optionSelectionViewController = [[OptionSelectionViewController alloc] init];
    optionSelectionViewController.options = options;
    optionSelectionViewController.attributes = attributes;
    [self.navigationController pushViewController:optionSelectionViewController animated:YES];
}

- (void)pushCheckoutViewControllerWithOption:(ECOption*)option attributesOrNil:(NSArray *)attributes;
{
    CheckoutViewController *checkoutViewController = [[CheckoutViewController alloc] initWithStyle:UITableViewStyleGrouped];
    checkoutViewController.option = option;
    checkoutViewController.attributes = attributes;
    [self.navigationController pushViewController:checkoutViewController animated:YES];
}

@end
