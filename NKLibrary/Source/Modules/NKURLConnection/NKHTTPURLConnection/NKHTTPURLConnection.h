//
//  NKHTTPURLConnection.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 6..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKCategory.h"
#import "NKMacro.h"

typedef void (^ResponseBlock)(NSURLResponse *response);
typedef void (^ReceiveBlock)(NSData *data);
typedef void (^SuccessBlock)(NSData *data);
typedef void (^ErrorBlock)(NSError *error);

@interface NKHTTPURLConnection : NSObject
<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

/**
 
 */
@property (nonatomic, assign) NSURLRequest *request;

/**
 Default : YES
 */
@property (nonatomic, assign) BOOL async;

/**
 Default : YES
 */
@property (nonatomic, assign) BOOL showNetworkIndicator;

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

- (void)responseBlock:(ResponseBlock)responseBlock
         receiveBlock:(ReceiveBlock)receiveBlock
        successBlock:(SuccessBlock)successBlock
           errorBlock:(ErrorBlock)errorBlock;

@end
