//
//  LocationsViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/29/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsViewController : UIViewController <RKObjectLoaderDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSArray *locations;

- (void)loadAllLocations;
- (void)loadNearbyLocations;
- (void)reloadMapAnnotations;
- (void)removeAllAnnotations;
@end
