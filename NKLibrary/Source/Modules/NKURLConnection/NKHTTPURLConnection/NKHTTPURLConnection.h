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
typedef void (^CompleteBlock)(NSData *data);
typedef void (^ErrorBlock)(NSError *error);

@interface NKHTTPURLConnection : NSObject
<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, assign) NSURLRequest *request;

/**
 Default : YES
 */
@property (nonatomic, readwrite) BOOL async;

+ (instancetype)manager;

- (void)responseBlock:(ResponseBlock)responseBlock
         receiveBlock:(ReceiveBlock)receiveBlock
        completeBlock:(CompleteBlock)completeBlock
           errorBlock:(ErrorBlock)errorBlock;

@end
