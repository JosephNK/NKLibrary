//
//  NSString+Util.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

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
