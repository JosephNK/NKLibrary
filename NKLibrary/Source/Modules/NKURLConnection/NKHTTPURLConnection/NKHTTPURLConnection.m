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
        [self defaultVariable];
    }
    
    return self;
}

#pragma mark -

- (void)defaultVariable {
    _async = YES;
    _showNetworkIndicator = YES;
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
    
    [self doSwitchAsyncSync:_async];
}

#pragma mark -

- (void)doSwitchAsyncSync:(BOOL)async {
    if (_showNetworkIndicator) {
        [UIApplication showNetworkActivityIndicator];
    }
    
    if (async) {
        [self connectionAsynchronous:_request];
    }else {
        [self performSelector:@selector(connectionSynchronous:) withObject:_request afterDelay:0.5f];
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
    
    if (_showNetworkIndicator) {
        [UIApplication hideNetworkActivityIndicator];
    }
    if (error == nil) {
        _allHeaderFields = [[(NSHTTPURLResponse*)response allHeaderFields] description];
        _totalSize = [response expectedContentLength];  // bytes
        _statusCode = [(NSHTTPURLResponse*)response statusCode];
        _currentSize = [data length];  // bytes
        
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
    
    _allHeaderFields = [[(NSHTTPURLResponse*)response allHeaderFields] description];
    _totalSize = [response expectedContentLength];  // bytes
    _statusCode = [(NSHTTPURLResponse*)response statusCode];
    
    _responseBlock(response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    _currentSize = [_data length];  // bytes
    
    _receiveBlock(_data);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_showNetworkIndicator) {
        [UIApplication hideNetworkActivityIndicator];
    }
    
    _successBlock(_data);
    
    [self tearDown];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_showNetworkIndicator) {
        [UIApplication hideNetworkActivityIndicator];
    }
    
    _errorBlock(error);
    
    [self tearDown];
    
}


@end
