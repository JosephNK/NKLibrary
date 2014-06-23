//
//  CLLocation+Util.h
//  NKLibrary
//
//  Created by Joseph NamKung on 2014. 6. 9..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Util)

/**
 The Distance From The Source Lat with Long
 */
+ (double)calcCLLocationDistanceWithSourceLat:(float)ulat SourceLong:(float)ulong
                              DestinationLat:(float)tlat DestinationLong:(float)tlong;

/**
 The Distance From The Source Lat with Long (Math)
 */
+ (double)distanceWithSourceLat:(float)ulat SourceLong:(float)ulong
                 DestinationLat:(float)tlat DestinationLong:(float)tlong;

- (double)bearingInRadiansTowardsLocation:(CLLocation *)towardsLocation;
- (CLLocation *)newLocationAtDistance:(CLLocationDistance)atDistance alongBearingInRadians:(double)bearingInRadians;
- (CLLocation *)newLocationAtDistance:(CLLocationDistance)atDistance towardsLocation:(CLLocation *)towardsLocation;


@end
