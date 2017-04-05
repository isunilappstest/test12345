//
//  ProductsViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/25/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductDetailViewController.h"
#import "ProductTableViewCell.h"
#import "ECProduct.h"
#import "AnalyticsHelper.h"

@implementation ProductsViewController {
    SSHUDView *_hud;
    UIScrollView *_errorScrollView;
}

@synthesize productsTableView = _productsTableView;
@synthesize products = _products;
@synthesize tag = _tag;


#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Products"];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/list-category"];        
    [self buildTableView];
    if (self.tag) {
        self.title = [self.tag.name capitalizedString];
        [self loadProducts];
    } else {
        self.title = @"Deals";
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)buildTableView {
    _productsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    self.productsTableView.dataSource = self;
    self.productsTableView.delegate = self;
    self.productsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_background", ECTenantName]]];
    
    [self.productsTableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];

    [self.view addSubview:self.productsTableView];
}


#pragma mark - UITableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    
    ECProduct *product = [self.products objectAtIndex:[indexPath row]];
    
    cell.clientLabel.text = [product.client.name uppercaseString];
    cell.titleLabel.text = product.name;
    [cell resizeTitleLabel];
    cell.priceLabel.text = product.lowestPriceInDollars;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] init];
    ECProduct *currentProduct = [self.products objectAtIndex:[indexPath row]];
    productDetailViewController.product = currentProduct;
    productDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)loadProducts {
    [self removeErrorScrollView];
    _hud = [[SSHUDView alloc] initWithTitle:@"Finding deals..."];
    _hud.hudSize = CGSizeMake(120.0f, 120.0f);
	[_hud show];
    if ([ECRegion currentRegion]) {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/regions/%@/tags/%@/products/?page=1&per_page=5000", [[ECRegion currentRegion] regionID], self.tag.tagID] delegate:self];
    } else {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/tags/%@/products/?page=1&per_page=5000", self.tag.tagID] delegate:self];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if (objects.count == 0) {
        [self addErrorScrollView];
    } else {
        _products = objects;
        [self removeErrorScrollView];
    }
    [self.productsTableView reloadData];
    [_hud dismissAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [self addErrorScrollView];
    [_hud dismiss];
	[[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


#pragma mark - Error helper methods

- (void)addErrorScrollView {
    self.productsTableView.backgroundColor = [UIColor errorPageBackgroundColor];
    [self.errorScrollView removeFromSuperview];
    [self.view addSubview:self.errorScrollView];
}

- (void)removeErrorScrollView {
    self.productsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_background", ECTenantName]]];
    [self.errorScrollView removeFromSuperview];
}

- (UIScrollView*)errorScrollView {
    if (_errorScrollView == nil) {
        _errorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_no_data_found", ECTenantName]]];
        errorImageView.contentMode = UIViewContentModeTop;
        errorImageView.frame = CGRectMake(0, -170, self.view.frame.size.width, self.view.frame.size.height);
        [_errorScrollView addSubview:errorImageView];
        
        UIButton *reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 310, 100, 35)];
        reloadButton.backgroundColor = [UIColor retryButtonColor];
        [reloadButton setTitle:@"Retry" forState:UIControlStateNormal];
        reloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        reloadButton.titleLabel.textColor = [UIColor whiteColor];
        reloadButton.showsTouchWhenHighlighted = YES;
        [reloadButton addTarget:self action:@selector(loadProducts) forControlEvents:UIControlEventTouchUpInside];
        [_errorScrollView addSubview:reloadButton];
        
        _errorScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    
    return _errorScrollView;
}


#pragma mark - Methods to bridge the gap between using UIViewController instead of UITableViewController

- (void)viewWillAppear:(BOOL)animated {
    // Unselect the selected row if any
    NSIndexPath *selection = [self.productsTableView indexPathForSelectedRow];
    if (selection) {
        [self.productsTableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    [super viewWillAppear:animated];
    self.view.frame = CGRectMake(0,0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-113);
    self.productsTableView.frame = self.view.frame;
}

- (void)viewDidAppear:(BOOL)animated {
    //	The scrollbars won't flash unless the tableview is long enough.
    [self.productsTableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.productsTableView setEditing:editing animated:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.productsTableView flashScrollIndicators];
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
