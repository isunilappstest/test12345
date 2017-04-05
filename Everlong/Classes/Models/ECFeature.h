//
//  ECFeature.h
//  Everlong
//
//  Created by Brian Morton on 12/12/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECFeature : NSObject

@property (nonatomic, retain) NSNumber *featureID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *highlights;
@property (nonatomic, retain) NSDictionary *primaryImage;

- (NSString*)titleWithoutLineBreaks;
+ (RKObjectMapping*)objectMapping;

@end
