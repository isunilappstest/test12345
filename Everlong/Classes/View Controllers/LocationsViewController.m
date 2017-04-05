//
//  LocationsViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/29/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationController.h"
#import "ECLocation.h"
#import "ProductsViewController.h"
#import "ProductDetailViewController.h"
#import "AnalyticsHelper.h"

@implementation LocationsViewController {
    SSHUDView *_hud;
}

@synthesize mapView = _mapView;
@synthesize locations = _locations;

#pragma mark - Initialization methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Nearby";
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/map-nearby"];        
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    UITapGestureRecognizer *threeFingersTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadAllLocations)];
    [threeFingersTwoTaps setNumberOfTapsRequired:2];
    [threeFingersTwoTaps setNumberOfTouchesRequired:3];
    [self.mapView addGestureRecognizer:threeFingersTwoTaps];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNearbyLocations];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)loadAllLocations {
    _hud = [[SSHUDView alloc] initWithTitle:@"All your base are belong to us..."];
    _hud.hudSize = CGSizeMake(300.0f, 100.0f);
    [_hud show];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/locations/near.json" delegate:self];
}

- (void)loadNearbyLocations {
    if (self.locations.count == 0) {
        _hud = [[SSHUDView alloc] initWithTitle:@"Locating deals..."];
        _hud.hudSize = CGSizeMake(150.0f, 100.0f);
        [_hud show];
    }
    
    LocationController *locationController = [LocationController sharedInstance];
    CLLocationCoordinate2D currentCoordinate = locationController.location.coordinate;
    NSDictionary *queryString = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:currentCoordinate.latitude], @"latitude",
                                 [NSNumber numberWithFloat:currentCoordinate.longitude], @"longitude", nil];
    NSString *resourcePath = [@"/locations/near.json" appendQueryParams:queryString];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if (objects.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"No deals found"
                                    message:@"Sorry, we couldn't locate any deals within 10 miles."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    if (![objects isEqualToArray:self.locations]) {
        _locations = objects;
        [self reloadMapAnnotations];
    }
    [_hud dismissAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [_hud dismiss];
	[[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


#pragma mark - Map helper methods

- (void)reloadMapAnnotations {
    [self removeAllAnnotations];
    [self.mapView addAnnotations:self.locations];
}

- (void)removeAllAnnotations {
    NSArray *annotationsToRemove = [self.mapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"!(self isKindOfClass: %@)", [MKUserLocation class]]];
    
    [self.mapView removeAnnotations:annotationsToRemove];
}


#pragma mark - MKMapViewDelegate methods

// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    if (mv.annotations.count == 1) {
        CLLocationCoordinate2D coordinate = [[mv.annotations objectAtIndex:0] coordinate];
        MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
        [mv setRegion:region animated:YES];
    } else if (mv.annotations.count > 1) {
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in mv.annotations) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
    
        [mv setVisibleMapRect:zoomRect animated:YES];
    }
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    }
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LocationAnnotation"];
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    ECLocation *location = (ECLocation*)view.annotation;
    if (location.products.count == 1) {
        ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] init];
        productDetailViewController.product = [location.products anyObject];
        productDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productDetailViewController animated:YES];
    } else {
        ProductsViewController *productsViewController = [[ProductsViewController alloc] init];
        productsViewController.products = [location.products allObjects];
        [self.navigationController pushViewController:productsViewController animated:YES];
    }
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
