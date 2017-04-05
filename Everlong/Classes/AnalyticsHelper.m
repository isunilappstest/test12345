//
//  AnalyticsHelper.m  - VVMCore
//  
//  Notes:
//  To use create an analytics.plist and put it in the properties dir of the project: Ex: Backpage/BackPage/properties/analytics.plist
//  Add a string key for analyticsId and put the unique account ID in there.
//
//  In a viewController include the singleton library and call 
//  [[AnalyticsHelper sharedAnalyticsHelper] trackPageView:[NSString stringWithFormat:@"/event/view/id:%i", self.event.id];
//  
//  To track actions: 
//  -(IBAction)facebookShare:(id)sender;
//  {
//      //Share to facebook
//      [[AnalytcisHelper sharedAnalyticsHelper] trackEvent:@"facebook" action:@"event-share" label:@"objid" value:self.event.id];
//  }
//
//
//  Created by Jason Cox on 3/28/12.
//  Copyright (c) 2012 Village Voice Media. All rights reserved.
//
#import "AnalyticsHelper.h"
//#import "GAITracker.h"
#import "SynthesizeSingleton.h"
#define kAnalyticsId @"analyticsId"

@interface SettingsHelper : NSObject
+(SettingsHelper *)sharedSettingsHelper;
-(id)objectForKey:(NSString *)key;
@end

@implementation SettingsHelper
SYNTHESIZE_SINGLETON_FOR_CLASS(SettingsHelper);
-(id)objectForKey:(NSString *)key;
{
    if([key isEqualToString:@"VERSION"]){
        return @"iPhone Encore Version 1.2";
    }
    if([key isEqualToString:kAnalyticsId]){
        return @"UA-28779640-4";
    }
    NSLog(@"TRYING TO GET SETTING FOR KEY: %@", key);
    return nil;
}

@end



static const NSInteger kGANDispatchPeriodSec = 10;
@implementation AnalyticsHelper
SYNTHESIZE_SINGLETON_FOR_CLASS(AnalyticsHelper);
@synthesize tracker = _tracker;
-(id)init;
{
    self = [super init];
    if(self != nil){
        [self startTracking];
    }
    return self;
}

-(void)dealloc;
{
    //cleanup
    if(_tracker != nil){
       // [_tracker stopTracker];
        _tracker = nil;
    }
}

-(BOOL)hasTacker;
{
    return [self tracker] == nil ? NO : YES;
}

-(void)startTracking;
{
    /*
    if([[SettingsHelper sharedSettingsHelper] objectForKey:kAnalyticsId]){
        [[GAITracker sharedTracker] startTrackerWithAccountID:[[SettingsHelper sharedSettingsHelper] objectForKey:kAnalyticsId]
                                               dispatchPeriod:kGANDispatchPeriodSec delegate:nil];            
        _tracker = [GAITracker sharedTracker];
        NSString *version = [[SettingsHelper sharedSettingsHelper] objectForKey:@"VERSION"];
        if(version != nil){
            NSError *error = nil;
            [_tracker setCustomVariableAtIndex:1 name:@"iPhone" value:version withError:&error];
            if(error != nil){
                NSLog(@"Analytics app version error: %@", error.description);
            }            
        }
    }         
     */
}

-(void)endTracking;
{
    //[_tracker stopTracker];
    _tracker = nil;
}

-(void)trackEvent:(NSString *)eventName 
           action:(NSString *)actionName 
            label:(NSString *)labelName 
            value:(NSInteger)value;
{
    if([self hasTacker]){
        NSError *error = nil;
        //[_tracker trackEvent:eventName action:actionName label:labelName value:value withError:&error];
        if(error != nil){
            //Error sending track event
            NSLog(@"Analytics action tracking error: %@", error.description);
        }
    }
}

-(void)trackPageView:(NSString *)page;
{
    if([self hasTacker]){
        NSError *error = nil;
        //[_tracker trackPageview:page withError:&error];
        if(error != nil){
            //Error
            NSLog(@"Analytics page tracking error: %@", error.description);
        }else{
            NSLog(@"Analytics track triggered for page: %@", page);
        }
    }
}

@end
