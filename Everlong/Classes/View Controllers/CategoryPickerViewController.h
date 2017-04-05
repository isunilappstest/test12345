//
//  CategoryPickerViewController.h
//  Everlong
//
//  Created by Brian Morton on 8/18/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryPickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate> {
    IBOutlet UITableView *categoriesTableView;
    BOOL loadingViewIsVisible;
    SSLoadingView *loadingView;
}

@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, retain) SSLoadingView *loadingView;
@property (assign) BOOL loadingViewIsVisible;

- (void)loadObjectsFromDataStore;
- (void)loadData;
- (void)additionalViewWillAppearForTableView;

@end
