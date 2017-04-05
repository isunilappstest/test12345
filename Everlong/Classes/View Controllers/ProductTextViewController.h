//
//  ProductTermsViewController.h
//  Everlong
//
//  Created by Brian Morton on 12/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTextViewController : UIViewController

@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *terms;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
