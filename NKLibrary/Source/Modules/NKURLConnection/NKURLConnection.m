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
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, readwrite) BOOL bIsAsync;
@property (nonatomic, copy) ReceiveResponseBlock receiveResponseBlock;
@property (nonatomic, copy) ReceiveDataBlock receiveDataBlock;
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSNumber *currentSize;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation NKURLConnection

- (void)dealloc
{
    NSLog(@"<dealloc> NKURLConnection");
    NK_SUPER_DEALLOC();
}

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

- (instancetype)init {
    if ((self = [super init])) {
        
    }
    
    return self;
}

- (void)requestWithURL:(NSString *)url
                  type:(NKURLType)type
            parameters:(NSDictionary *)parameters
                 async:(BOOL)bAsync
  receiveResponseBlock:(ReceiveResponseBlock)receiveResponseBlock
      receiveDataBlock:(ReceiveDataBlock)receiveDataBlock
         completeBlock:(CompleteBlock)completeBlock
            errorBlock:(ErrorBlock)errorBlock {
    
    _requestUrl = url;
    
    _receiveResponseBlock = NK_BLOCK_COPY(receiveResponseBlock);
    _receiveDataBlock = NK_BLOCK_COPY(receiveDataBlock);
    _completeBlock = NK_BLOCK_COPY(completeBlock);
    _errorBlock = NK_BLOCK_COPY(errorBlock);
    
    [self nonType:type];
    [self nonAsync:bAsync];
}

#pragma mark -

- (void)nonType:(NKURLType)type {
    switch (type) {
        case NKURLTypeGET:
            
            break;
        case NKURLTypePOST:
            
            break;
        default:
            break;
    }
}

- (void)nonAsync:(BOOL)bAsync {
    [UIApplication showNetworkActivityIndicator];
    
    if (bAsync) {
        [self performSelector:@selector(nonASyncConnection) withObject:nil afterDelay:0.0f];
    }else {
        [self performSelector:@selector(nonSyncConnection) withObject:nil afterDelay:0.5f];
    }
}

#pragma mark -

- (void)nonASyncConnection {
    _data = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:_requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];
    _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)nonSyncConnection {
    NK_AUTORELEASE_POOL_START();
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:_requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    [UIApplication hideNetworkActivityIndicator];
    if (error == nil) {
        _receiveResponseBlock(response);
        _receiveDataBlock(data);
        _completeBlock(data);
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
    
    //NSLog(@"Header \n %@", [[(NSHTTPURLResponse*)response allHeaderFields] description]);
    //_contentType = [[(NSHTTPURLResponse*)response allHeaderFields] objectForKey:@"Content-Type"];
    //_totalSize = [[NSNumber alloc] initWithUnsignedLongLong:[response expectedContentLength]];
	//NSLog(@"Total-length: %@ bytes", totalSize_);
    
    _receiveResponseBlock(response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    //_currentSize = [NSNumber numberWithUnsignedInteger:[_data length]];
	//NSLog(@"Current-length: %@ bytes", currentSize);
    
    _receiveDataBlock(_data);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication hideNetworkActivityIndicator];
    
    _completeBlock(_data);
    
    [self tearDown];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication hideNetworkActivityIndicator];
    
    _errorBlock(error);
    
    [self tearDown];
    
}

#pragma mark -

- (void)tearDown
{
    NSLog(@"<tearDown> NKURLConnection");
    
    NK_RELEASE(_data); _data = nil;
    NK_RELEASE(_conn); _conn = nil;
    NK_BLOCK_RELEASE(_receiveResponseBlock); _receiveResponseBlock = nil;
    NK_BLOCK_RELEASE(_receiveDataBlock); _receiveDataBlock = nil;
    NK_BLOCK_RELEASE(_completeBlock); _completeBlock = nil;
    NK_BLOCK_RELEASE(_errorBlock); _errorBlock = nil;
}

@end
