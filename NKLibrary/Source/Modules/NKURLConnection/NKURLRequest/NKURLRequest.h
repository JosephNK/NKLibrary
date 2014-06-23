//
//  NKURLRequest.h
//  NKLibrary
//
//  Created by Joseph NamKung on 2014. 6. 23..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKURLRequest : NSObject

/**
 */
@property (nonatomic, strong) NSString *URLString;

/**
 */
@property (nonatomic, assign) id parameters;

/**
 Default : GET
 */
@property (nonatomic, strong) NSString *HTTPMethod;

/**
 Default : NSUTF8StringEncoding
 */
@property (nonatomic, assign) NSStringEncoding stringEncoding;

/**
 Default : YES
 */
@property (nonatomic, assign) BOOL allowsCellularAccess;

/**
 Default : NSURLRequestUseProtocolCachePolicy
 */
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

/**
 Default : YES
 */
@property (nonatomic, assign) BOOL HTTPShouldHandleCookies;

/**
 Default : NO
 */
@property (nonatomic, assign) BOOL HTTPShouldUsePipelining;

/**
 Default : NSURLNetworkServiceTypeDefault
 */
@property (nonatomic, assign) NSURLRequestNetworkServiceType networkServiceType;

/**
 Default : 60 sec
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

+ (instancetype)manager;

@end


@interface NKURLRequestHTTP : NKURLRequest

+ (instancetype)manager;

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters;

@end


@interface NKURLRequestJSON : NKURLRequest

+ (instancetype)manager;

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters;

@end


@interface NKURLRequestXML : NKURLRequest

+ (instancetype)manager;

- (NSMutableURLRequest *)requestCreateByURL:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod Parameters:(id)parameters;

@end