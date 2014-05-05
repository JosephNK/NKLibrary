//
//  NKHTTPURLRequest.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 6..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKHTTPURLRequest.h"

@implementation NKHTTPURLRequest

#pragma mark -

- (void)dealloc
{
    LLog(@"<dealloc> NKHTTPURLRequest");
    NK_RELEASE(_requestURL);
    NK_SUPER_DEALLOC();
}

#pragma mark -

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

- (instancetype)init {
    if ((self = [super init])) {
        _HTTPMethod = @"GET";
        _stringEncoding = NSUTF8StringEncoding;
        _allowsCellularAccess = YES;
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _HTTPShouldHandleCookies = YES;
        _HTTPShouldUsePipelining = NO;
        _networkServiceType = NSURLNetworkServiceTypeDefault;
        _timeoutInterval = 60;
        _dataType = NKURLDataTypeTEXT;
        _HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
    }
    
    return self;
}

#pragma mark -

- (NSMutableURLRequest *)requestWithMethodType:(NSString *)methodType
                                  withDataType:(NKURLDataType)dataType
                                withRequestURL:(NSString *)requestURL
                                withParameters:(id)parameters
{
    _HTTPMethod = [methodType uppercaseString];
    _dataType = dataType;
    _requestURL = requestURL;
    _parameters = parameters;
    
    NSURL *url = [NSURL URLWithString:_requestURL];
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = _HTTPMethod;
    mutableRequest.allowsCellularAccess = _allowsCellularAccess;
    mutableRequest.cachePolicy = _cachePolicy;
    mutableRequest.HTTPShouldHandleCookies = _HTTPShouldHandleCookies;
    mutableRequest.HTTPShouldUsePipelining = _HTTPShouldUsePipelining;
    mutableRequest.networkServiceType = _networkServiceType;
    mutableRequest.timeoutInterval = _timeoutInterval;
    
    if (_dataType == NKURLDataTypeTEXT || [_HTTPMethodsEncodingParametersInURI containsObject:_HTTPMethod]) {
        mutableRequest = [[self requestModifiedRequest:mutableRequest withMethodType:_HTTPMethod withParameters:_parameters] mutableCopy];
    }else {
        mutableRequest = [[self requestModifiedRequest:mutableRequest withDataType:_dataType withParameters:_parameters] mutableCopy];
    }
    
	return mutableRequest;
}

#pragma mark -

- (NSURLRequest *)requestModifiedRequest:(NSURLRequest *)request
                          withMethodType:(NSString *)methodType
                          withParameters:(id)parameters
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            NSString *charset = NK_BRIDGE_CAST(NSString *, CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(_stringEncoding)));
            [mutableRequest setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        }
        
        NSString *query = nil;
        
        if ([parameters isKindOfClass:[NSString class]]) {
            query = parameters;
        }
        
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *mutableKeyValues = [NSMutableArray array];
            for (NSString *key in [parameters allKeys]) {
                NSString *value = [parameters valueForKey:key];
                [mutableKeyValues addObject:[NSString stringWithFormat:@"%@=%@", URLEncode(key, _stringEncoding), URLEncode(value, _stringEncoding)]];
            }
            query = [mutableKeyValues componentsJoinedByString:@"&"];
        }
        
        if ([methodType isEqualToString:@"GET"]) {
            NSString *urlString = [[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query];
            [mutableRequest setURL:[NSURL URLWithString:urlString]];
        }
        
        if ([methodType isEqualToString:@"POST"]) {
            [mutableRequest setHTTPBody:[query dataUsingEncoding: _stringEncoding]];
        }
    }
    
    return mutableRequest;
}

- (NSURLRequest *)requestModifiedRequest:(NSURLRequest *)request
                            withDataType:(NKURLDataType)dataType
                          withParameters:(id)parameters
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    switch (dataType) {
        case NKURLDataTypeJSON:
            if (parameters) {
                if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                    NSString *charset = NK_BRIDGE_CAST(NSString *, CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(_stringEncoding)));
                    [mutableRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                }
                [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
            }
            if (![mutableRequest valueForHTTPHeaderField:@"Accept"]) {
                [mutableRequest setValue:@"application/json;" forHTTPHeaderField:@"Accept"];
            }
            break;
        case NKURLDataTypeReceiveJSON:
            if (parameters) {
                if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                    NSString *charset = NK_BRIDGE_CAST(NSString *, CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(_stringEncoding)));
                    [mutableRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                }
                [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
            }
            break;
        case NKURLDataTypeResponseJSON:
            if (![mutableRequest valueForHTTPHeaderField:@"Accept"]) {
                [mutableRequest setValue:@"application/json;" forHTTPHeaderField:@"Accept"];
            }
            break;
        default:
            break;
    }
    
    return mutableRequest;
}


#pragma mark -

static NSString * const kCharactersEscapedInQueryString = @":/?&=;+!@#$()',*";
static NSString * const kCharactersLeaveUnescapedInQueryString = @"[].";

static NSString * URLEncode(NSString *unencodedString, NSStringEncoding stringEncoding) {
    NSString *s = NK_BRIDGE_CAST(NSString *, CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                     (CFStringRef)unencodedString,
                                                                                     (CFStringRef)kCharactersLeaveUnescapedInQueryString,
                                                                                     (CFStringRef)kCharactersEscapedInQueryString,
                                                                                     CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
    return NK_AUTORELEASE(s); // Due to the 'create rule' we own the above and must autorelease it
}

@end
