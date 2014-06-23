//
//  NKURLConnectionOperation.h
//  NKLibrary
//
//  Created by Joseph NamKung on 2014. 6. 22..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKNetworkThread : NSObject

+ (void) __attribute__((noreturn)) networkEntry:(id)__unused object;
+ (NSThread *)networkThread;

@end


@class NKURLConnectionOperation;

typedef void (^NKOperationSuccessHandler)(NKURLConnectionOperation *operation, id responseData);
typedef void (^NKOperationErrorHandler)(NKURLConnectionOperation *operation, NSError *error);

@interface NKURLConnectionOperation : NSOperation
<NSURLConnectionDataDelegate, NSURLConnectionDelegate>


@property (nonatomic, strong) NSURLRequest *request;

/**
 
 */
@property (nonatomic, assign) BOOL enableNetworkIndicator;

/**
 
 */
@property (nonatomic, readonly, getter = getCacheHeaders) NSDictionary *cacheHeaders;

/**
 
 */
@property (nonatomic, readonly, getter = getAllCookies) NSArray *allCookies;

/**
 
 */
@property (nonatomic, readonly, getter = getAllHeaderFields) NSDictionary *allHeaderFields;

/**
 
 */
@property (nonatomic, readonly, getter = getStatusCode) NSInteger statusCode;

/**
 
 */
@property (nonatomic, readonly, getter = getTotalSize) long long totalSize;

/**
 
 */
@property (nonatomic, readonly, getter = getCurrentSize) NSUInteger currentSize;


+ (instancetype)manager;
+ (instancetype)managerWithRequest:(NSURLRequest *)request;

+ (id)request:(NSURLRequest *)request
      success:(void (^)(NKURLConnectionOperation *operation, id responseData))success
      failure:(void (^)(NKURLConnectionOperation *operation, NSError *error))failure;

- (id)success:(void (^)(NKURLConnectionOperation *operation, id responseData))success
      failure:(void (^)(NKURLConnectionOperation *operation, NSError *error))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(NKURLConnectionOperation *operation, id responseData))success
                              failure:(void (^)(NKURLConnectionOperation *operation, NSError *error))failure;

@end
