//
//  CertificateDetailViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/26/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "CertificateDetailViewController.h"
#import "CertificateRedeemViewController.h"
#import "ECLocation.h"
#import "ProductLocationsViewController.h"
#import "ProductTextViewController.h"
#import "AnalyticsHelper.h"
@implementation CertificateDetailViewController

@synthesize certificate = _certificate;
@synthesize locations = _locations;
@synthesize clientNameLabel = _clientNameLabel;
@synthesize clientNameBackgroundView = _clientNameBackgroundView;
@synthesize titleLabel = _titleLabel;
@synthesize titleBackgroundView = _titleBackgroundView;
@synthesize certificateCodeLabel = _certificateCodeLabel;
@synthesize detailSelectorTableView = _detailSelectorTableView;
@synthesize mapView = _mapView;
@synthesize stateLabel = _stateLabel;
@synthesize expirationLabel = _expirationLabel;
@synthesize expirationBackgroundView = _expirationBackgroundView;
@synthesize codeContainerView = _codeContainerView;
@synthesize redeemButton = _redeemButton;
@synthesize expirationContainerView = _expirationContainerView;

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Certificate"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_cert_nav_title", ECTenantName]]];
        [self.navigationItem setTitleView:imageView];
         
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;

    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/detail-certificates"];
    _locations = [self.certificate.locations allObjects];
    self.title = self.certificate.code;
    
    [self setupMapView];
    [self setupTableView];
    
    self.clientNameLabel.text = [self.certificate.client.name uppercaseString];
    self.titleLabel.text = self.certificate.option.name;
    self.certificateCodeLabel.text = self.certificate.code;
    
    self.clientNameBackgroundView.backgroundColor = [UIColor certificateDetailViewCompanyContainerColor];
    self.titleBackgroundView.backgroundColor = [UIColor certificateDetailViewTitleContainerColor];
    self.expirationBackgroundView.backgroundColor = [UIColor certificateDetailViewExpirationContainerColor];
    self.codeContainerView.backgroundColor = [UIColor certificateDetailViewExpirationContainerColor];
    
    [self.redeemButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_buy_now_button", ECTenantName]] forState:UIControlStateNormal];
    [self.redeemButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_buy_now_button_highlight", ECTenantName]] forState:UIControlStateHighlighted];
    self.redeemButton.frame = CGRectMake(self.redeemButton.frame.origin.x, [UIScreen mainScreen].bounds.size.height-self.redeemButton.frame.size.height-64, self.redeemButton.frame.size.width, self.redeemButton.frame.size.height);
    self.codeContainerView.frame = CGRectMake(self.codeContainerView.frame.origin.x, [UIScreen mainScreen].bounds.size.height-self.codeContainerView.frame.size.height-64, self.codeContainerView.frame.size.width, self.codeContainerView.frame.size.height);
    
    self.expirationContainerView.frame = CGRectMake(self.expirationLabel.frame.origin.x, [UIScreen mainScreen].bounds.size.height-self.expirationLabel.frame.size.height-self.codeContainerView.frame.size.height-64, self.expirationLabel.frame.size.width, self.expirationLabel.frame.size.height);

    self.expirationLabel.text = [NSString stringWithFormat:@"expires %@", self.certificate.expiresOnFormatted];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self additionalViewWillAppearForTableView];
    [self toggleState];

}


#pragma mark - View helper methods

- (void)toggleState {
    if (self.certificate.isValid) {
        self.stateLabel.text = @"VALID";
        self.stateLabel.textColor = [UIColor colorWithRed:0.000 green:0.502 blue:0.000 alpha:1.000];
    } else if (self.certificate.isRedeemed) {
        self.stateLabel.text = @"REDEEMED";
        self.stateLabel.textColor = [UIColor colorWithRed:0.502 green:0.000 blue:0.000 alpha:1.000];
    } else if (self.certificate.isPending) {
        self.stateLabel.text = @"PENDING";
        self.stateLabel.textColor = [UIColor colorWithRed:0.502 green:0.000 blue:0.000 alpha:1.000];
    } else if (self.certificate.isCancelled) {
        self.stateLabel.text = @"CANCELLED";
        self.stateLabel.textColor = [UIColor colorWithRed:0.502 green:0.000 blue:0.000 alpha:1.000];
    }
}

- (void)setupMapView {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    NSLog(@"%@", self.locations);
    
    // Set a starting point for the map so we don't get some crazy zoom out/in stuff
    if (self.locations.count > 0) {
        CLLocationCoordinate2D firstCoordinate = [[self.locations objectAtIndex:0] coordinate];
        MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
        MKCoordinateRegion region = MKCoordinateRegionMake(firstCoordinate, span);
        [self.mapView setRegion:region];
        
        [self.mapView addAnnotations:self.locations];
    }
}

- (void)setupTableView {
    self.detailSelectorTableView.delegate = self;
    self.detailSelectorTableView.dataSource = self;
    self.detailSelectorTableView.scrollEnabled = NO;
    self.detailSelectorTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    SSLineView *headerLine = [[SSLineView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    headerLine.lineColor = [UIColor colorWithWhite:0.878 alpha:1.000];
//    self.detailSelectorTableView.tableHeaderView = headerLine;
}

- (IBAction)redeemButtonPressed:(id)sender {
    if (!self.certificate.isValid) {
        [[[UIAlertView alloc] initWithTitle:@"Certificate not valid"
                                    message:@"This certificate is not valid for redemption."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    CertificateRedeemViewController *redeemViewController = [[CertificateRedeemViewController alloc] init];
    redeemViewController.certificate = self.certificate;
    [self.navigationController pushViewController:redeemViewController animated:YES];
}

- (void)viewDidUnload {
    [self setClientNameLabel:nil];
    [self setTitleLabel:nil];
    [self setCertificateCodeLabel:nil];
    [self setDetailSelectorTableView:nil];
    [self setMapView:nil];
    [self setStateLabel:nil];
    [self setExpirationLabel:nil];
    [self setClientNameBackgroundView:nil];
    [self setTitleBackgroundView:nil];
    [self setExpirationBackgroundView:nil];
    [self setCodeContainerView:nil];
    [self setRedeemButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
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
    annotationView.animatesDrop = NO;
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    ECLocation *location = (ECLocation*)view.annotation;
    [[UIApplication sharedApplication] openURL:location.googleMapsURL];
}


#pragma mark - UITableView delegate and datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ProductLocationsViewController *viewController = [[ProductLocationsViewController alloc] init];
        NSLog(@"%@", _locations);
        viewController.locations = _locations;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 1) {
        ProductTextViewController *termsController = [[ProductTextViewController alloc] init];
        NSLog(@"%@", self.certificate.terms);
        termsController.terms = self.certificate.terms;
        [self.navigationController pushViewController:termsController animated:YES];
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


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
