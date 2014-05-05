//
//  NKURLConnection.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKCategory.h"
#import "NKMacro.h"

#import "NKHTTPURLRequest.h"
#import "NKHTTPURLConnection.h"

typedef void (^ResponseBlock)(NSURLResponse *response);
typedef void (^ReceiveBlock)(NSData *data);
typedef void (^CompleteBlock)(NSData *data);
typedef void (^ErrorBlock)(NSError *error);

@interface NKURLConnection : NSObject
<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) NKHTTPURLRequest *request;
@property (nonatomic, strong) NKHTTPURLConnection *connection;

+ (instancetype)manager;

- (void)completeRequest:(NKHTTPURLRequest *)request
             connection:(NKHTTPURLConnection *)connection
          responseBlock:(ResponseBlock)responseBlock
           receiveBlock:(ReceiveBlock)receiveBlock
          completeBlock:(CompleteBlock)completeBlock
             errorBlock:(ErrorBlock)errorBlock;

@end
