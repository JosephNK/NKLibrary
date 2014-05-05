//
//  NKURLConnection.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKURLConnection.h"

@interface NKURLConnection()

@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) ResponseBlock responseBlock;
@property (nonatomic, copy) ReceiveBlock receiveBlock;
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSNumber *currentSize;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation NKURLConnection

#pragma mark -

- (void)dealloc
{
    LLog(@"<dealloc> NKURLConnection");
    NK_RELEASE(_request);
    NK_RELEASE(_connection);
    NK_SUPER_DEALLOC();
}

#pragma mark -

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

- (instancetype)init {
    if ((self = [super init])) {
        self.request = [NKHTTPURLRequest manager];
        self.connection = [NKHTTPURLConnection manager];
    }
    
    return self;
}

#pragma mark -

- (void)completeRequest:(NKHTTPURLRequest *)request
             connection:(NKHTTPURLConnection *)connection
          responseBlock:(ResponseBlock)responseBlock
           receiveBlock:(ReceiveBlock)receiveBlock
          completeBlock:(CompleteBlock)completeBlock
             errorBlock:(ErrorBlock)errorBlock {
    
    NSURLRequest *req = [self createRequestInfo:request];
    connection.request = req;
    
    [connection responseBlock:responseBlock receiveBlock:receiveBlock completeBlock:completeBlock errorBlock:errorBlock];
}

#pragma mark -

- (NSURLRequest *)createRequestInfo:(NKHTTPURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request requestWithMethodType:request.HTTPMethod
                                                            withDataType:request.dataType
                                                          withRequestURL:request.requestURL
                                                          withParameters:request.parameters];
    return mutableRequest;
}

@end
