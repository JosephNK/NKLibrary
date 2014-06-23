//
//  NKURLRequest+Util.h
//  NKLibrary
//
//  Created by Joseph NamKung on 2014. 6. 23..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKURLRequest.h"

@interface NKURLRequest (Util)

+ (NSString *)URLEncodeWithUnEncodedString:(NSString *)unencodedString withEncoding:(NSStringEncoding)stringEncoding;

+ (NSString *)modifyContentType:(NSString *)type encoding:(NSStringEncoding)stringEncoding;
+ (NSString *)modifyAcceptLanguage;
+ (NSString *)modifyUserAgent;

@end
