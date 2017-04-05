//
//  CertificateRedeemViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "CertificateRedeemViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AnalyticsHelper.h"

@implementation CertificateRedeemViewController {
    SSHUDView *_hud;
}

@synthesize certificate;
@synthesize clientName;
@synthesize certificateCode;
@synthesize merchantCertificateCode;
@synthesize optionName;
@synthesize infoContainerView;
@synthesize clientNameBackgroundView;
@synthesize certificateCodeBackgroundView;
@synthesize optionNameBackgroundView;
@synthesize redeemButton;
@synthesize redeemButtonContainerView;
@synthesize merchantInstructions;

#pragma mark - Initialization methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Redeem";
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
        [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/redeem"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_order_background"]];
    self.infoContainerView.layer.cornerRadius = 5;
    
    self.clientName.text = self.certificate.client.name;
    self.certificateCode.text = self.certificate.code;
    self.merchantCertificateCode.text = [NSString stringWithFormat:@"%@#", self.certificate.code];
    self.optionName.text = self.certificate.option.name;
    
    self.clientNameBackgroundView.backgroundColor = [UIColor secondaryColor];
    self.certificateCodeBackgroundView.backgroundColor = [UIColor primaryColor];
    self.optionNameBackgroundView.backgroundColor = [UIColor secondaryColor];
    
    self.merchantInstructions.text = [NSString stringWithFormat:@"Merchant: To verify this certificate by phone, call %@ and enter:", kRedemptionPhoneNumber];
    
    [self.redeemButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_finalize_button", ECTenantName]] forState:UIControlStateNormal];
    [self.redeemButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_finalize_button_highlight", ECTenantName]] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload {
    [self setClientName:nil];
    [self setCertificateCode:nil];
    [self setOptionName:nil];
    [self setInfoContainerView:nil];
    [self setClientNameBackgroundView:nil];
    [self setCertificateCodeBackgroundView:nil];
    [self setOptionNameBackgroundView:nil];
    [self setRedeemButton:nil];
    [self setRedeemButtonContainerView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)redeemButtonPressed:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"This action is irreversible. "
                                message:@"Are you sure you want to mark this voucher as redeemed? "
                               delegate:self
                      cancelButtonTitle:@"No"
                      otherButtonTitles:@"Yes", nil] show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    } else {
        _hud = [[SSHUDView alloc] initWithTitle:@"Redeeming..."];
        _hud.hudSize = CGSizeMake(115.0f, 100.0f);
        [_hud show];
        
        [[RKObjectManager sharedManager] putObject:self.certificate delegate:self  block:^(RKObjectLoader* loader) {
            loader.resourcePath = [NSString stringWithFormat:@"/certificates/%@/redeem", self.certificate.certificateID];
        }];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    [_hud completeWithTitle:@"Redeemed!"];
	[_hud performSelector:@selector(dismiss) withObject:nil afterDelay:0.9];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [_hud dismiss];
    NSLog(@"Encountered an error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
