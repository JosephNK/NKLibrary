//
//  NKURLConnection.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKURLConnection.h"

@interface NKURLConnection()

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

- (void)readyRequest:(NKHTTPURLRequest *)request
          connection:(NKHTTPURLConnection *)connection
       responseBlock:(void (^)(NSURLResponse *response))responseBlock
        receiveBlock:(void (^)(NSData *data))receiveBlock
        successBlock:(void (^)(NSData *data))successBlock
          errorBlock:(void (^)(NSError *error))errorBlock {
    
    NSMutableURLRequest *mutableRequest = [request requestSerialization];
    connection.request = mutableRequest;
    
    [connection responseBlock:responseBlock receiveBlock:receiveBlock successBlock:successBlock errorBlock:errorBlock];
}

#pragma mark -

@end
