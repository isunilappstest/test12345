//
//  CertificateRedeemViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECCertificate.h"

@interface CertificateRedeemViewController : UIViewController <RKObjectLoaderDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) ECCertificate *certificate;
@property (weak, nonatomic) IBOutlet UILabel *clientName;
@property (weak, nonatomic) IBOutlet UILabel *certificateCode;
@property (weak, nonatomic) IBOutlet UILabel *merchantCertificateCode;
@property (weak, nonatomic) IBOutlet UILabel *optionName;
@property (weak, nonatomic) IBOutlet UIView *infoContainerView;
@property (weak, nonatomic) IBOutlet UIView *clientNameBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *certificateCodeBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *optionNameBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;
@property(weak, nonatomic) IBOutlet UILabel *merchantInstructions;
@property (weak, nonatomic) IBOutlet UIImageView *redeemButtonContainerView;

- (IBAction)redeemButtonPressed:(id)sender;

@end
