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

- (void)dealloc
{
    LLog(@"<dealloc> NKURLRequest");
    NK_RELEASE(_URLString); _URLString = nil;
    NK_SUPER_DEALLOC();
}

#pragma mark -

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

- (instancetype)init {
    if ((self = [super init])) {
        [self defaultSetup];
    }
    
    return self;
}

#pragma mark -

- (void)defaultSetup {
    _HTTPMethod = @"GET";
    _stringEncoding = NSUTF8StringEncoding;
    _allowsCellularAccess = YES;
    _cachePolicy = NSURLRequestUseProtocolCachePolicy;
    _HTTPShouldHandleCookies = YES;
    _HTTPShouldUsePipelining = NO;
    _networkServiceType = NSURLNetworkServiceTypeDefault;
    _timeoutInterval = 60;
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
    
    return NK_AUTORELEASE(mutableRequest);
}

#pragma mark -

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters
{
    self.URLString = URLString;
    self.HTTPMethod = HTTPMethod;
    self.parameters = parameters;
    
    NSMutableURLRequest *mutableRequest = [[self requestCreateBaseByURL:URLString] mutableCopy];
    
    [mutableRequest setValue:[NKURLRequest modifyContentType:@"HTTP"
                                                    encoding:self.stringEncoding] forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setValue:[NKURLRequest modifyAcceptLanguage] forHTTPHeaderField:@"Accept-Language"];
    [mutableRequest setValue:[NKURLRequest modifyUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    NSString *query = [NKURLRequest modifyParameters:parameters encoding:self.stringEncoding];
    NSMutableURLRequest *__mutableRequest = [[self modifyByRequest:mutableRequest HTTPMethod:HTTPMethod Parameters:query] mutableCopy];
    
    NK_AUTORELEASE(mutableRequest);
    
	return NK_AUTORELEASE(__mutableRequest);
}

- (NSMutableURLRequest *)modifyByRequest:(NSURLRequest *)request HTTPMethod:(NSString *)methodType Parameters:(NSString *)parameters
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSString *HTTPMethodType = [methodType uppercaseString];
    
    if (parameters) {
        if ([HTTPMethodType isEqualToString:@"GET"]) {
            NSString *urlString = [[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", parameters];
            [mutableRequest setURL:[NSURL URLWithString:urlString]];
        }
        
        if ([HTTPMethodType isEqualToString:@"POST"]) {
            [mutableRequest setHTTPBody:[parameters dataUsingEncoding: _stringEncoding]];
        }
    }
    
    return NK_AUTORELEASE(mutableRequest);
}

@end

@implementation NKURLRequestJSON

#pragma mark -

- (void)dealloc
{
    LLog(@"<dealloc> NKURLRequestJSON");
    NK_SUPER_DEALLOC();
}

#pragma mark -

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters {
    self.URLString = URLString;
    self.HTTPMethod = HTTPMethod;
    self.parameters = parameters;
    
    NSMutableURLRequest *mutableRequest = [[self requestCreateBaseByURL:URLString] mutableCopy];
    
    [mutableRequest setValue:[NKURLRequest modifyContentType:@"JSON"
                                                    encoding:self.stringEncoding] forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setValue:[NKURLRequest modifyAcceptLanguage] forHTTPHeaderField:@"Accept-Language"];
    [mutableRequest setValue:[NKURLRequest modifyUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    NSMutableURLRequest *__mutableRequest = [[self modifyByRequest:mutableRequest HTTPMethod:HTTPMethod Parameters:parameters] mutableCopy];
    
    NK_AUTORELEASE(mutableRequest);
    
	return NK_AUTORELEASE(__mutableRequest);
}

- (NSMutableURLRequest *)modifyByRequest:(NSURLRequest *)request HTTPMethod:(NSString *)methodType Parameters:(NSString *)parameters
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

@implementation NKURLRequestXML

#pragma mark -

- (void)dealloc
{
    LLog(@"<dealloc> NKURLRequestXML");
    NK_SUPER_DEALLOC();
}

#pragma mark -

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters {
    self.URLString = URLString;
    self.HTTPMethod = HTTPMethod;
    self.parameters = parameters;
    
    NSMutableURLRequest *mutableRequest = [[self requestCreateBaseByURL:URLString] mutableCopy];
    
    [mutableRequest setValue:[NKURLRequest modifyContentType:@"XML" encoding:self.stringEncoding] forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setValue:[NKURLRequest modifyAcceptLanguage] forHTTPHeaderField:@"Accept-Language"];
    [mutableRequest setValue:[NKURLRequest modifyUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    NSMutableURLRequest *__mutableRequest = [[self modifyByRequest:mutableRequest HTTPMethod:HTTPMethod Parameters:parameters] mutableCopy];
    
    NK_AUTORELEASE(mutableRequest);
    
	return NK_AUTORELEASE(__mutableRequest);
}

- (NSMutableURLRequest *)modifyByRequest:(NSURLRequest *)request HTTPMethod:(NSString *)methodType Parameters:(NSString *)parameters
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