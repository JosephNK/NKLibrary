//
//  NKURLRequest.m
//  NKLibrary
//
//  Created by Joseph NamKung on 2014. 6. 23..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKURLRequest.h"
#import "NKMacro.h"
#import "NKURLRequest+Util.h"

@implementation NKURLRequest

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    LLog(@"<dealloc> NKURLRequest");
    [self tearDown];
    NK_SUPER_DEALLOC();
}

- (void)tearDown
{
    if (_URLString) {
        NK_RELEASE(_URLString); _URLString = nil;
    }
    if (_HTTPMethod) {
        NK_RELEASE(_HTTPMethod); _HTTPMethod = nil;
    }
}

#pragma mark -
#pragma mark Init

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
    }
    
    return self;
}

#pragma mark -

- (NSMutableURLRequest *)requestCreateBaseByURL:(NSString *)requestURL
{
    NSURL *url = [NSURL URLWithString:requestURL];
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = _HTTPMethod;
    mutableRequest.allowsCellularAccess = _allowsCellularAccess;
    mutableRequest.cachePolicy = _cachePolicy;
    mutableRequest.HTTPShouldHandleCookies = _HTTPShouldHandleCookies;
    mutableRequest.HTTPShouldUsePipelining = _HTTPShouldUsePipelining;
    mutableRequest.networkServiceType = _networkServiceType;
    mutableRequest.timeoutInterval = _timeoutInterval;
    
    [mutableRequest setValue:[NKURLRequest modifyAcceptLanguage] forHTTPHeaderField:@"Accept-Language"];
    [mutableRequest setValue:[NKURLRequest modifyUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    return NK_AUTORELEASE(mutableRequest);
}

@end


/**
    NKURLRequestHTTP
 */

@implementation NKURLRequestHTTP

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    LLog(@"<dealloc> NKURLRequestHTTP");
    [self tearDown];
    NK_SUPER_DEALLOC();
}

- (void)tearDown
{
    
}

#pragma mark -
#pragma mark Init

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

#pragma mark -

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters
{
//    self.URLString = URLString;
//    self.HTTPMethod = HTTPMethod;
//    self.parameters = parameters;
    
    NSMutableURLRequest *mutableRequest = [[self requestCreateBaseByURL:URLString] mutableCopy];
    
    [mutableRequest setValue:[NKURLRequest modifyContentType:@"HTTP"
                                                    encoding:self.stringEncoding] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableURLRequest *__mutableRequest = [[self modifyByRequest:mutableRequest
                                                        HTTPMethod:HTTPMethod
                                                        Parameters:parameters] mutableCopy];
    
    NK_AUTORELEASE(mutableRequest);
    
	return NK_AUTORELEASE(__mutableRequest);
}

- (NSMutableURLRequest *)modifyByRequest:(NSURLRequest *)request HTTPMethod:(NSString *)methodType Parameters:(id)parameters
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSString *HTTPMethodType = [methodType uppercaseString];
    
    NSString *query = nil;
    
    if (parameters) {
        if ([parameters isKindOfClass:[NSString class]]) {
            query = parameters;
        }
        
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *mutableKeyValues = [NSMutableArray array];
            for (NSString *key in [parameters allKeys]) {
                NSString *value = [parameters valueForKey:key];
                [mutableKeyValues addObject:[NSString stringWithFormat:@"%@=%@",
                                             [NKURLRequest URLEncodeWithUnEncodedString:key withEncoding:self.stringEncoding],
                                             [NKURLRequest URLEncodeWithUnEncodedString:value withEncoding:self.stringEncoding]]];
            }
            query = [mutableKeyValues componentsJoinedByString:@"&"];
        }
        
        if ([parameters isKindOfClass:[NSArray class]]) {
            
        }
    }
    
    if (query) {
        if ([HTTPMethodType isEqualToString:@"GET"]) {
            NSString *urlString = [[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query];
            [mutableRequest setURL:[NSURL URLWithString:urlString]];
        }
        
        if ([HTTPMethodType isEqualToString:@"POST"]) {
            [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
        }
    }
    
    return NK_AUTORELEASE(mutableRequest);
}

@end


/**
    NKURLRequestJSON
 */

@implementation NKURLRequestJSON

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    LLog(@"<dealloc> NKURLRequestJSON");
    [self tearDown];
    NK_SUPER_DEALLOC();
}

- (void)tearDown
{
    
}

#pragma mark -
#pragma mark Init

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

#pragma mark -

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters
{
//    self.URLString = URLString;
//    self.HTTPMethod = HTTPMethod;
//    self.parameters = parameters;
    
    NSMutableURLRequest *mutableRequest = [[self requestCreateBaseByURL:URLString] mutableCopy];
    
    [mutableRequest setValue:[NKURLRequest modifyContentType:@"JSON"
                                                    encoding:self.stringEncoding] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableURLRequest *__mutableRequest = [[self modifyByRequest:mutableRequest
                                                        HTTPMethod:HTTPMethod
                                                        Parameters:parameters] mutableCopy];
    
    NK_AUTORELEASE(mutableRequest);
    
	return NK_AUTORELEASE(__mutableRequest);
}

- (NSMutableURLRequest *)modifyByRequest:(NSURLRequest *)request HTTPMethod:(NSString *)methodType Parameters:(id)parameters
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSString *HTTPMethodType = [methodType uppercaseString];
    
    if (parameters) {
        if ([HTTPMethodType isEqualToString:@"POST"]) {
            [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
        }
    }
    
    return NK_AUTORELEASE(mutableRequest);
}

@end


/**
    NKURLRequestXML
 */

@implementation NKURLRequestXML

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    LLog(@"<dealloc> NKURLRequestXML");
    [self tearDown];
    NK_SUPER_DEALLOC();
}

- (void)tearDown
{
    
}

#pragma mark -
#pragma mark Init

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

#pragma mark -

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters
{
//    self.URLString = URLString;
//    self.HTTPMethod = HTTPMethod;
//    self.parameters = parameters;
    
    NSMutableURLRequest *mutableRequest = [[self requestCreateBaseByURL:URLString] mutableCopy];
    
    [mutableRequest setValue:[NKURLRequest modifyContentType:@"XML"
                                                    encoding:self.stringEncoding] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableURLRequest *__mutableRequest = [[self modifyByRequest:mutableRequest
                                                        HTTPMethod:HTTPMethod
                                                        Parameters:parameters] mutableCopy];
    
    NK_AUTORELEASE(mutableRequest);
    
	return NK_AUTORELEASE(__mutableRequest);
}

- (NSMutableURLRequest *)modifyByRequest:(NSURLRequest *)request HTTPMethod:(NSString *)methodType Parameters:(id)parameters
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSString *HTTPMethodType = [methodType uppercaseString];
    
    if (parameters) {
        if ([HTTPMethodType isEqualToString:@"POST"]) {
            [mutableRequest setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters
                                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                                  options:0 error:nil]];
        }
    }
    
    return NK_AUTORELEASE(mutableRequest);
}

@end