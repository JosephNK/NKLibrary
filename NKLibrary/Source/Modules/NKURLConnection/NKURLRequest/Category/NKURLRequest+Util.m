//
//  NKURLRequest+Util.m
//  NKLibrary
//
//  Created by Joseph NamKung on 2014. 6. 23..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKURLRequest+Util.h"
#import "NKMacro.h"

@implementation NKURLRequest (Util)

#pragma mark -

static NSString * const kCharactersEscapedInQueryString = @":/?&=;+!@#$()',*";
static NSString * const kCharactersLeaveUnescapedInQueryString = @"[].";

+ (NSString *)URLEncodeWithUnEncodedString:(NSString *)unencodedString withEncoding:(NSStringEncoding)stringEncoding {
#if __has_feature(objc_arc)
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                        (CFStringRef)unencodedString,
                                                                                        (CFStringRef)kCharactersLeaveUnescapedInQueryString,
                                                                                        (CFStringRef)kCharactersEscapedInQueryString,
                                                                                        CFStringConvertNSStringEncodingToEncoding(stringEncoding));
#else
    NSString *s = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                      (CFStringRef)unencodedString,
                                                                      (CFStringRef)kCharactersLeaveUnescapedInQueryString,
                                                                      (CFStringRef)kCharactersEscapedInQueryString,
                                                                      CFStringConvertNSStringEncodingToEncoding(stringEncoding));
#endif
    
    return NK_AUTORELEASE(s); // Due to the 'create rule' we own the above and must autorelease it
}

#pragma mark -

+ (NSString *)modifyContentType:(NSString *)type encoding:(NSStringEncoding)stringEncoding
{
    if ([type isEqualToString:@"HTTP"]) {
        NSString *charset = NK_BRIDGE_CAST(NSString *, CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
        return [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset];
    }else if ([type isEqualToString:@"JSON"]) {
        NSString *charset = NK_BRIDGE_CAST(NSString *, CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
        return [NSString stringWithFormat:@"application/json; charset=%@", charset];
    }else if ([type isEqualToString:@"XML"]) {
        NSString *charset = NK_BRIDGE_CAST(NSString *, CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
        return [NSString stringWithFormat:@"application/x-plist; charset=%@", charset];
    }
    
    return nil;
}

+ (NSString *)modifyAcceptLanguage
{
    // Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
    NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
    [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float q = 1.0f - (idx * 0.1f);
        [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
        *stop = q <= 0.5f;
    }];
    
    return [acceptLanguagesComponents componentsJoinedByString:@", "];
}

+ (NSString *)modifyUserAgent
{
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    NSString *userAgent = nil;
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:NK_BRIDGE_CAST(NSString *, kCFBundleExecutableKey)] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:NK_BRIDGE_CAST(NSString *, kCFBundleIdentifierKey)],
                 NK_BRIDGE_CAST(id, CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey)) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:NK_BRIDGE_CAST(NSString *, kCFBundleVersionKey)], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform(NK_BRIDGE_CAST(CFMutableStringRef, mutableUserAgent), NULL, NK_BRIDGE_CAST(CFStringRef, @"Any-Latin; Latin-ASCII; [:^ASCII:] Remove"), false)) {
                userAgent = mutableUserAgent;
            }
            NK_AUTORELEASE(mutableUserAgent);
        }
    }
    
    return userAgent;
}

@end
