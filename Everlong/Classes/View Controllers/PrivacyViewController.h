//
//  PrivacyViewController.h
//  Everlong
//
//  Created by Jason Cox on 12/11/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic, retain) IBOutlet UIWebView *webView;
-(IBAction)close:(id)sender;
@end
