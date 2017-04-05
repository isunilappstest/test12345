//
//  ProductLocationsViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/29/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ProductLocationsViewController.h"
#import "ECLocation.h"

@implementation ProductLocationsViewController

@synthesize mapView = _mapView;
@synthesize locations = _locations;


#pragma mark - Initialization methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Locations";
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    if (self.locations.count > 0) {
        // Set a starting point for the map so we don't get some crazy zoom out/in stuff
        CLLocationCoordinate2D firstCoordinate = [[self.locations objectAtIndex:0] coordinate];
        MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
        MKCoordinateRegion region = MKCoordinateRegionMake(firstCoordinate, span);
        [self.mapView setRegion:region];
    }
    
    [self.mapView addAnnotations:self.locations];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - MKMapViewDelegate methods

// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    if (mv.annotations.count == 1) {
        CLLocationCoordinate2D coordinate = [[mv.annotations objectAtIndex:0] coordinate];
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
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
    [[UIApplication sharedApplication] openURL:location.googleMapsURL];
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
