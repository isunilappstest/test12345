//
//  ECError.h
//  Everlong
//
//  Created by Jason Cox on 10/15/12.
//  Copyright (c) 2012 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECError : NSObject
@property(nonatomic, retain) NSString *errorMessage;
+ (RKObjectMapping*)objectMapping;
@end
