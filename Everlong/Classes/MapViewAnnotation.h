//
//  MapViewAnnotation.h
//  Everlong
//
//  Created by Brian Morton on 10/11/11.
//  Copyright (c) 2011 The San Diego Reader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapViewAnnotation : NSObject <MKAnnotation> {
    NSString *title;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)aTitle coordinate:(CLLocationCoordinate2D)aCoordinate;

@end
