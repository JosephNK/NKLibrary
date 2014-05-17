//
//  NSString+Util.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NSString+Util.h"
#import "NKMacro.h"

@implementation NSString (Util)

#pragma mark -

+ (NSString *)bundleSeedID {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           NK_BRIDGE_CAST(id, kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching(NK_BRIDGE_CAST(CFDictionaryRef, query), (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd(NK_BRIDGE_CAST(CFDictionaryRef, query), (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [NK_BRIDGE_CAST(NSDictionary *, result) objectForKey:NK_BRIDGE_CAST(id, kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

#pragma mark -

+ (float)calcCLLocationDistanceWithSourceLat:(float)ulat SourceLong:(float)ulong
                              DestinationLat:(float)tlat DestinationLong:(float)tlong {
	
	CLLocation *SourceLocation = [[CLLocation alloc] initWithLatitude:ulat longitude:ulong];
	CLLocation *DestinationLocation = [[CLLocation alloc] initWithLatitude:tlat longitude:tlong];

    CLLocationDistance distance = [SourceLocation distanceFromLocation:DestinationLocation];
	
    NK_RELEASE(SourceLocation);
    NK_RELEASE(DestinationLocation);
	
	float fDistance = (float)distance;  // The distance from the Source
	
	return fDistance;
}

+ (float)calcMathDistanceWithSourceLat:(float)ulat SourceLong:(float)ulong
                           DestinationLat:(float)tlat DestinationLong:(float)tlong {
    
    /*
     URL : http://www.movable-type.co.uk/scripts/latlong.html
     
     Haversine formula:
     a = sin²(Δlat/2) + cos(lat1).cos(lat2).sin²(Δlong/2)
     c = 2.atan2(√a, √(1−a))
     d = R.c
     
     where R is earth’s radius (mean radius = 6,371km);
     note that angles need to be in radians to pass to trig functions!
     
     JavaScript:
     var R = 6371; // km
     var dLat = (lat2-lat1).toRad();
     var dLon = (lon2-lon1).toRad();
     var lat1 = lat1.toRad();
     var lat2 = lat2.toRad();
     
     var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
     Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2);
     var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
     var d = R * c;
     
     */
    
    int R = 6371;   // mean radius = 6,371km
    
    double dLat = ((tlat) - (ulat)) * M_PI / 180;
    double dLong = ((tlong) - (ulong)) * M_PI / 180;
    double lat1 = (ulat) * M_PI / 180;
    double lat2 = (tlat) * M_PI / 180;
    
    double a = sin(dLat/2) * sin(dLat/2) +
    sin(dLong/2) * sin(dLong/2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = R * c;
    
    float fDistance = (float)d; // The distance from the Source
	
	return fDistance;
}

#pragma mark -

+ (NSString *)getConvertEmpty:(NSString *)str {
    if (str == nil || [str isEqualToString:@"null"] || [str isEqualToString:@"(null)"]) {
        return @"";
    }
    return str;
}

#pragma mark -

+ (NSString *)getTodayWithDateFormat:(NSString *)dateformat {
	NSDate *today = [NSDate date];
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:dateformat];
	NSString *dateString = [format stringFromDate:today];
	NK_RELEASE(format);
	
	return dateString;
}

+ (NSString *)getTodayGMTWithDateFormat:(NSString *)dateformat {
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:dateformat];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
	
    NSDate *localDate = [dateFormatter dateFromString:dateString];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:localDate];
    //	timeZoneOffset += 360;
    NSDate *gmtDate = [localDate dateByAddingTimeInterval:-timeZoneOffset]; // NOTE the "-" sign!
    NSString *gmtdateString = [dateFormatter stringFromDate:gmtDate];
    NK_RELEASE(dateFormatter);
    
    return gmtdateString;
}

+ (NSString *)getIntervalFromDateToDate:(NSDate*)today fromDate:(NSDate *)oldday {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags = NSDayCalendarUnit ;
	NSDateComponents *components = [gregorian components:unitFlags fromDate:oldday
												  toDate:today options:0];
    NK_RELEASE(gregorian);
    
	int day = [components day];
	
	return [NSString stringWithFormat:@"%d", day];
}

+ (NSString *)getWeekFromDay:(NSDate *)day {
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comp = [cal components:NSMonthCalendarUnit|NSDayCalendarUnit
							  |NSWeekdayCalendarUnit fromDate:day];
	switch ([comp weekday]) { // 1 = Sunday, 2 = Monday, etc.
		case 1:
			return @"Sunday";
			break;
		case 2:
			return @"Monday";
			break;
		case 3:
			return @"Tuesday";
			break;
		case 4:
			return @"Wednesday";
			break;
		case 5:
			return @"Thursday";
			break;
		case 6:
			return @"Friday";
			break;
		case 7:
			return @"Saturday";
			break;
		default:
			break;
	}
	return @"";
}

@end
