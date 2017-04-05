//
//  PlacementsViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/23/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"
#import "BMShadowedTableView.h"
#import "HJObjManager.h"
#import "ECRegion.h"

@interface PlacementsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate, LocationControllerDelegate>

@property (nonatomic, retain) BMShadowedTableView *placementsTableView;
@property (nonatomic, retain) NSArray *placements;

- (void)findNearestRegion;
- (void)updateRegionFromNotification;
- (void)locateOrLoadPlacements;
- (void)loadPlacements;
- (void)loadPlacementsForCurrentRegion;
- (void)buildTableView;
- (UIView*)headerForTableView;
- (UIScrollView*)errorScrollView;
- (void)addErrorScrollView;
- (void)removeErrorScrollView;
- (void)additionalViewWillAppearForTableView;
- (void)cancelLocationUpdateAndPresentModal;
- (void)presentRegionSelectorViewController;

@end
