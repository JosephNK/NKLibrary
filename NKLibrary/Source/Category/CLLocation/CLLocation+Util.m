//
//  CLLocation+Util.m
//  NKLibrary
//
//  Created by Joseph NamKung on 2014. 6. 9..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Util.h"
#import "NKMacro.h"

#define kPi 3.141592653589793
#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180
#define RAD2DEG(radians) (radians * 57.2957795) // radians * 180 over pi

@implementation CLLocation (Util)

+ (double)calcCLLocationDistanceWithSourceLat:(float)ulat SourceLong:(float)ulong
                              DestinationLat:(float)tlat DestinationLong:(float)tlong {
	
	CLLocation *SourceLocation = [[CLLocation alloc] initWithLatitude:ulat longitude:ulong];
	CLLocation *DestinationLocation = [[CLLocation alloc] initWithLatitude:tlat longitude:tlong];
    
    CLLocationDistance distance = [SourceLocation distanceFromLocation:DestinationLocation]; // The distance from the Source
	
    NK_RELEASE(SourceLocation);
    NK_RELEASE(DestinationLocation);
	
	return distance;
}

+ (double)distanceWithSourceLat:(float)ulat SourceLong:(float)ulong
                 DestinationLat:(float)tlat DestinationLong:(float)tlong {
    
    // calculate the bearing in the direction of towardsLocation from this location's coordinate
	// Formula:	a = sin²(Δlat/2) + cos(lat1).cos(lat2).sin²(Δlong/2), c = 2.atan2(√a, √(1−a)), d = R.c
	// Based on the formula as described at http://www.movable-type.co.uk/scripts/latlong.html
	// original JavaScript implementation © 2002-2006 Chris Veness
    
    int R = 6371;   // mean radius = 6,371km
    
    double dLat = ((tlat) - (ulat)) * M_PI / 180;
    double dLong = ((tlong) - (ulong)) * M_PI / 180;
    double lat1 = (ulat) * M_PI / 180;
    double lat2 = (tlat) * M_PI / 180;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLong/2) * sin(dLong/2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = R * c; // The distance from the Source
	
	return d;
}

- (double)bearingInRadiansTowardsLocation:(CLLocation *)towardsLocation
{
    
	// calculate the bearing in the direction of towardsLocation from this location's coordinate
	// Formula:	θ =	atan2(sin(Δlong).cos(lat2), cos(lat1).sin(lat2) − sin(lat1).cos(lat2).cos(Δlong))
	// Based on the formula as described at http://www.movable-type.co.uk/scripts/latlong.html
	// original JavaScript implementation © 2002-2006 Chris Veness
    
	double lat1 = DEG2RAD(self.coordinate.latitude);
	double lon1 = DEG2RAD(self.coordinate.longitude);
	double lat2 = DEG2RAD(towardsLocation.coordinate.latitude);
	double lon2 = DEG2RAD(towardsLocation.coordinate.longitude);
	double dLon = lon2 - lon1;
	double y = sin(dLon) * cos(lat2);
	double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
	double bearing = atan2(y, x) + (2 * kPi);
	// atan2 works on a range of -π to 0 to π, so add on 2π and perform a modulo check
	if (bearing > (2 * kPi)) {
		bearing = bearing - (2 * kPi);
	}
    
	return bearing;
    
}

- (CLLocation *)newLocationAtDistance:(CLLocationDistance)atDistance alongBearingInRadians:(double)bearingInRadians
{
    
	// calculate an endpoint given a startpoint, bearing and distance
	// Vincenty 'Direct' formula based on the formula as described at http://www.movable-type.co.uk/scripts/latlong-vincenty-direct.html
	// original JavaScript implementation © 2002-2006 Chris Veness
    
	double lat1 = DEG2RAD(self.coordinate.latitude);
	double lon1 = DEG2RAD(self.coordinate.longitude);
    
	double a = 6378137, b = 6356752.3142, f = 1/298.257223563;  // WGS-84 ellipsiod
	double s = atDistance;
	double alpha1 = bearingInRadians;
	double sinAlpha1 = sin(alpha1);
	double cosAlpha1 = cos(alpha1);
    
	double tanU1 = (1 - f) * tan(lat1);
	double cosU1 = 1 / sqrt((1 + tanU1 * tanU1));
	double sinU1 = tanU1 * cosU1;
	double sigma1 = atan2(tanU1, cosAlpha1);
	double sinAlpha = cosU1 * sinAlpha1;
	double cosSqAlpha = 1 - sinAlpha * sinAlpha;
	double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
	double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
	double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    
	double sigma = s / (b * A);
	double sigmaP = 2 * kPi;
	
	double cos2SigmaM = 0.0;
	double sinSigma = 0.0;
	double cosSigma = 0.0;
	
	while (abs(sigma - sigmaP) > 1e-12) {
		cos2SigmaM = cos(2 * sigma1 + sigma);
		sinSigma = sin(sigma);
		cosSigma = cos(sigma);
		double deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
		sigmaP = sigma;
		sigma = s / (b * A) + deltaSigma;
	}
    
	double tmp = sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1;
	double lat2 = atan2(sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1, (1 - f) * sqrt(sinAlpha * sinAlpha + tmp * tmp));
	double lambda = atan2(sinSigma * sinAlpha1, cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1);
	double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
	double L = lambda - (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    
	double lon2 = lon1 + L;
    
	// create a new CLLocation for this point
	CLLocation *edgePoint = [[CLLocation alloc] initWithLatitude:RAD2DEG(lat2) longitude:RAD2DEG(lon2)];
	
	return edgePoint;
    
}

- (CLLocation *)newLocationAtDistance:(CLLocationDistance)atDistance towardsLocation:(CLLocation *)towardsLocation
{
    
	double bearingInRadians = [self bearingInRadiansTowardsLocation:towardsLocation];
	return [self newLocationAtDistance:atDistance alongBearingInRadians:bearingInRadians];
    
}

@end
