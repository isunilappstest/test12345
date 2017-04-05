//
//  MKMapView+ZoomLevel.h
//  Everlong
//
//  Created by Brian Morton on 9/28/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end