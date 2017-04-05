//
//  PrivacyViewController.m
//  Everlong
//
//  Created by Jason Cox on 12/11/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import "PrivacyViewController.h"
#import "AnalyticsHelper.h"
@interface PrivacyViewController ()

@end

@implementation PrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/privacy/", ECRestKitBaseURL]];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    NSLog(@"Loading URL: %@", url);
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
    
    [super viewDidLoad];
    [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:@"/privacy"];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender;
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
