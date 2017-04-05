//
//  CertificateDetailViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/26/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECCertificate.h"

@interface CertificateDetailViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) ECCertificate *certificate;
@property (nonatomic, retain) NSArray *locations;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UIView *clientNameBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *certificateCodeLabel;
@property (weak, nonatomic) IBOutlet UITableView *detailSelectorTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *codeContainerView;
@property (weak, nonatomic) IBOutlet UIView *expirationContainerView;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;

- (void)setupMapView;
- (void)setupTableView;
- (void)toggleState;
- (void)additionalViewWillAppearForTableView;
- (IBAction)redeemButtonPressed:(id)sender;

@end
