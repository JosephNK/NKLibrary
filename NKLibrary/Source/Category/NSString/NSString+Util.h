//
//  NSString+Util.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

/**
 
 */
+ (NSString *)bundleSeedID;


/**
 
 **/
+ (NSString *)getConvertEmpty:(NSString *)str;


/**
 @param DateFormat yyyy.MM.dd, yyyy-MM-dd, ..
 */
+ (NSString *)getTodayWithDateFormat:(NSString *)dateformat;


/**
 @param DateFormat @"yyyy-MM-dd'T'HH:mm:ss.000000'Z'", @"yyyy-MM-dd'T'HH:mm:ss'Z'"
 */
+ (NSString *)getTodayGMTWithDateFormat:(NSString *)dateformat;


/**
 Returns today's date and the last date of the interval
 */
+ (NSString *)getIntervalFromDateToDate:(NSDate*)today fromDate:(NSDate *)oldday;


/**
 Returns the day of the week from day
 */
+ (NSString *)getWeekFromDay:(NSDate *)day;

@end
