//
//  ProductsViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/25/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTag.h"
#import "ECRegion.h"

@interface ProductsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate>

@property (nonatomic, retain) UITableView *productsTableView;
@property (nonatomic, retain) NSArray *products;
@property (nonatomic, retain) ECTag *tag;

- (void)loadProducts;
- (void)buildTableView;
- (UIScrollView*)errorScrollView;
- (void)addErrorScrollView;
- (void)removeErrorScrollView;

@end
