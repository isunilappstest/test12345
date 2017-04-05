//
//  ProductTermsViewController.m
//  Everlong
//
//  Created by Brian Morton on 12/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import "ProductTextViewController.h"

@implementation ProductTextViewController

@synthesize body = _body;
@synthesize terms = _terms;
@synthesize textView = _termsTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Nothing!
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.backgroundColor = [UIColor listViewBackgroundColor];
    if (self.body) {
        self.title = @"Read More";
        self.textView.text = self.body;
    } else if (self.terms) {
        self.title = @"Fine Print";
        self.textView.text = self.terms;
    }
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
