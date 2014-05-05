//
//  NKHTTPURLConnection.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 6..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKHTTPURLConnection.h"

@interface NKHTTPURLConnection()

@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) ResponseBlock responseBlock;
@property (nonatomic, copy) ReceiveBlock receiveBlock;
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSNumber *currentSize;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation NKHTTPURLConnection

#pragma mark -

- (void)dealloc
{
    LLog(@"<dealloc> NKHTTPURLConnection");
    NK_RELEASE(_request);
    NK_SUPER_DEALLOC();
}

- (void)tearDown
{
    LLog(@"<tearDown> NKHTTPURLConnection");
    
    NK_RELEASE(_data); _data = nil;
    NK_RELEASE(_conn); _conn = nil;
    NK_BLOCK_RELEASE(_responseBlock); _responseBlock = nil;
    NK_BLOCK_RELEASE(_receiveBlock); _receiveBlock = nil;
    NK_BLOCK_RELEASE(_successBlock); _successBlock = nil;
    NK_BLOCK_RELEASE(_errorBlock); _errorBlock = nil;
}

#pragma mark -

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

- (instancetype)init {
    if ((self = [super init])) {
        _async = YES;
    }
    
    return self;
}

#pragma mark -

- (void)responseBlock:(ResponseBlock)responseBlock
         receiveBlock:(ReceiveBlock)receiveBlock
        successBlock:(SuccessBlock)successBlock
           errorBlock:(ErrorBlock)errorBlock {
    
    _responseBlock = NK_BLOCK_COPY(responseBlock);
    _receiveBlock = NK_BLOCK_COPY(receiveBlock);
    _successBlock = NK_BLOCK_COPY(successBlock);
    _errorBlock = NK_BLOCK_COPY(errorBlock);
    
    NSAssert(_request, @"<NSAssert> request is nil");
    
    [self switchAsyncSync:_async request:_request];
}

#pragma mark -

- (void)switchAsyncSync:(BOOL)async request:(NSURLRequest *)request {
    [UIApplication showNetworkActivityIndicator];
    
    if (async) {
        [self performSelector:@selector(connectionAsynchronous:) withObject:request afterDelay:0.0f];
        //[self connectionAsynchronous:request];
    }else {
        [self performSelector:@selector(connectionSynchronous:) withObject:request afterDelay:0.5f];
        //[self connectionSynchronous:request];
    }
}

#pragma mark -

- (void)connectionAsynchronous:(NSURLRequest *)request {
    _data = [[NSMutableData alloc] init];
    _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connectionSynchronous:(NSURLRequest *)request {
    NK_AUTORELEASE_POOL_START();
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    [UIApplication hideNetworkActivityIndicator];
    if (error == nil) {
        _responseBlock(response);
        _receiveBlock(data);
        _successBlock(data);
    }else {
        _errorBlock(error);
    }
    [self tearDown];
    NK_AUTORELEASE_POOL_END();
}


#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data setLength:0];
    
    //LLog(@"Header \n %@", [[(NSHTTPURLResponse*)response allHeaderFields] description]);
    //_contentType = [[(NSHTTPURLResponse*)response allHeaderFields] objectForKey:@"Content-Type"];
    //_totalSize = [[NSNumber alloc] initWithUnsignedLongLong:[response expectedContentLength]];
	//LLog(@"Total-length: %@ bytes", totalSize_);
    
    _responseBlock(response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    //_currentSize = [NSNumber numberWithUnsignedInteger:[_data length]];
	//LLog(@"Current-length: %@ bytes", currentSize);
    
    _receiveBlock(_data);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication hideNetworkActivityIndicator];
    
    _successBlock(_data);
    
    [self tearDown];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication hideNetworkActivityIndicator];
    
    _errorBlock(error);
    
    [self tearDown];
    
}


@end
