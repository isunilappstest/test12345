//
//  BMShadowedTableView.h
//  Everlong
//
//  Created by Brian Morton on 12/30/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//
//  This code originates from the example at:
//    http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html
//
//  Thanks Matt Gallagher!
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BMShadowedTableView : UITableView {
	CAGradientLayer *originShadow;
	CAGradientLayer *topShadow;
	CAGradientLayer *bottomShadow;
}

@end
