//
//  NSString+Network.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 8..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Network)

+ (NSString *)getIPAddress;
+ (NSString *)getMacAddress;

+ (NSString *)getCountryCode;
+ (NSString *)getCarrierName;
+ (NSString *)getMobileCountryCode;

@end
