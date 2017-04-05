//
//  AnalyticsHelper.h
//  VVMCore
//
//  Created by Jason Cox on 3/28/12.
//  Copyright (c) 2012 Village Voice Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GAITracker;
@interface AnalyticsHelper : NSObject{
    GAITracker *_tracker;
}

@property(nonatomic, readonly) GAITracker *tracker;
+(AnalyticsHelper *)sharedAnalyticsHelper;

-(void)trackEvent:(NSString *)eventName 
           action:(NSString *)actionName 
            label:(NSString *)labelName 
            value:(NSInteger)value;

-(void)trackPageView:(NSString *)page;
-(void)startTracking;
-(void)endTracking;

@end
