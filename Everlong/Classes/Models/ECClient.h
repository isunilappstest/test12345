//
//  ECClient.h
//  Everlong
//
//  Created by Brian Morton on 12/12/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECClient : NSObject

@property (nonatomic, retain) NSNumber *clientID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *website;

+ (RKObjectMapping*)objectMapping;

@end
