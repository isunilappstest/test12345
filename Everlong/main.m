//
//  main.m
//  Everlong
//
//  Created by Brian Morton on 8/9/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        int retVal = 0;
        @try{
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([ELAppDelegate class]));
        }
        @catch (NSException *exception){
            NSLog(@"Exception:");
            NSLog(@"Exception Name: %@", [exception name]);
            NSLog(@"Exception Reason: %@", [exception reason]);
            NSLog(@"Exception UserInfo: %@", [exception userInfo]);
            NSLog(@"Exception Backtrace: \n%@", [exception callStackSymbols]);
            exit(EXIT_FAILURE);
        }
        return retVal;
    }
}
