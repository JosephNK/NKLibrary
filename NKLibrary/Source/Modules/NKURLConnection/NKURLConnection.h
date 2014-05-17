//
//  NKURLConnection.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKHTTPURLRequest.h"
#import "NKHTTPURLConnection.h"

@interface NKURLConnection : NSObject
<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) NKHTTPURLRequest *request;
@property (nonatomic, strong) NKHTTPURLConnection *connection;

+ (instancetype)manager;

- (void)readyRequest:(NKHTTPURLRequest *)request
          connection:(NKHTTPURLConnection *)connection
       responseBlock:(void (^)(NSURLResponse *response))responseBlock
        receiveBlock:(void (^)(NSData *data))receiveBlock
        successBlock:(void (^)(NSData *data))successBlock
          errorBlock:(void (^)(NSError *error))errorBlock;

@end
