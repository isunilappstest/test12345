//
//  ECTag.h
//  Everlong
//
//  Created by Brian Morton on 12/13/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECTag : NSManagedObject

@property (nonatomic, retain) NSNumber *tagID;
@property (nonatomic, retain) NSString *name;

+ (RKManagedObjectMapping*)objectMapping;

@end
