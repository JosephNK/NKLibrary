//
//  NKURLConnectionOperation.m
//  NKLibrary
//
//  Created by Joseph NamKung on 2014. 6. 22..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKURLConnectionOperation.h"
#import "NKMacro.h"

@interface NKURLConnectionOperation()
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, readwrite, strong) NSError *error;
@property (nonatomic, readwrite, assign) BOOL finished;
@property (nonatomic, readwrite, assign) BOOL executing;
@property (nonatomic, readwrite, assign) BOOL cancelled;
@property (nonatomic, readwrite, strong) NSRecursiveLock *lock;
@property (nonatomic, copy) NKOperationSuccessHandler successHandler;
@property (nonatomic, copy) NKOperationErrorHandler errorHandler;
@end

@implementation NKURLConnectionOperation

//+ (void)networkEntry:(id)__unused object {
//    @autoreleasepool {
//        [[NSThread currentThread] setName:@"NKURLConnectionOperation"];
//        
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
//        [runLoop run];
//        NSLog(@"exit worker thread");
//    }
//}

+ (void) __attribute__((noreturn)) networkEntry:(id)__unused object
{
    do {
        @autoreleasepool
        {
            //[[NSRunLoop currentRunLoop] run];
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
            [runLoop run];
            NSLog(@"exit worker thread runloop");
        }
    } while (YES);
}

+ (NSThread *)networkThread {
    static NSThread *_networkThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkEntry:) object:nil];
        [_networkThread start];
    });
    
    return _networkThread;
}

#pragma mark -

- (void)dealloc
{
    LLog(@"<dealloc> NKURLConnectionOperation");
    [self tearDown];
    NK_SUPER_DEALLOC();
}

- (void)tearDown
{
    if (_successHandler) {
        NK_BLOCK_RELEASE(_successHandler); _successHandler = nil;
    }
    if (_errorHandler) {
        NK_BLOCK_RELEASE(_errorHandler); _errorHandler = nil;
    }
    if (_responseData) {
        NK_RELEASE(_responseData); _responseData = nil;
    }
    if (_connection) {
        NK_RELEASE(_connection); _connection = nil;
    }
    if (_request) {
        NK_RELEASE(_request); _request = nil;
    }
    if (_lock) {
        NK_RELEASE(_lock); _lock = nil;
    }
}

#pragma mark -

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

+ (instancetype)managerWithRequest:(NSURLRequest *)request {
    return NK_AUTORELEASE([[self alloc] initWithRequest:request]);
}

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        _lock = [[NSRecursiveLock alloc] init];
        _request = [request copy];
    }
    return self;
}

#pragma mark -

+ (id)request:(NSURLRequest *)request
      success:(void (^)(NKURLConnectionOperation *operation, id responseData))success
      failure:(void (^)(NKURLConnectionOperation *operation, NSError *error))failure
{
    NSLog(@"request:success:failure in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    NKURLConnectionOperation *operation = [NKURLConnectionOperation manager];
    operation.request = request;
    //[operation setCompletionBlockWithSuccess:success failure:failure];
    operation.successHandler = NK_BLOCK_COPY(success);
    operation.errorHandler = NK_BLOCK_COPY(failure);
    
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];

    return operation;
}

- (id)success:(void (^)(NKURLConnectionOperation *operation, id responseData))success
      failure:(void (^)(NKURLConnectionOperation *operation, NSError *error))failure
{
    NSAssert(_request, @"<NSAssert> request is nil");
    NSLog(@"success:failure in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    //[self setCompletionBlockWithSuccess:success failure:failure];
    _successHandler = NK_BLOCK_COPY(success);
    _errorHandler = NK_BLOCK_COPY(failure);
    
    [self setQueuePriority:NSOperationQueuePriorityVeryHigh];
    
    return nil;
}

- (void)setCompletionBlockWithSuccess:(void (^)(NKURLConnectionOperation *operation, id responseData))success
                              failure:(void (^)(NKURLConnectionOperation *operation, NSError *error))failure
{
    [self.lock lock];
    
#if !__has_feature(objc_arc)
    __block typeof(self) weakSelf = self;
#else
    __weak typeof(self) weakSelf = self;
#endif
    
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    NSLog(@"<completionBlock> : %d, %p", [strongSelf retainCount], strongSelf);
    
    self.completionBlock = ^ {
        if (strongSelf.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(strongSelf, strongSelf.error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(strongSelf, strongSelf.responseData);
                });
            }
        }
        [super setCompletionBlock:nil];
    };
    
   [self.lock unlock];
}

#pragma mark -

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return self.executing;
}

- (BOOL)isFinished {
    return self.finished;
}

- (BOOL)isCancelled {
    return self.cancelled;
}

- (void)cancel
{
    NSLog(@"cancel in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    [self.lock lock];
    
    [self willChangeValueForKey:@"isCancelled"];
    self.cancelled = YES;
    [self didChangeValueForKey:@"isCancelled"];
    
    if (![self isFinished] && ![self isCancelled]) {
        //[super cancel];
        if ([self isExecuting]) {
            [self performSelector:@selector(operationDidCancel)
                         onThread:[[self class] networkThread]
                       withObject:nil
                    waitUntilDone:NO
                            modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
        }else {
            [self performSelector:@selector(operationDidCancel)
                         onThread:[[self class] networkThread]
                       withObject:nil
                    waitUntilDone:NO
                            modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
        }
    }
    
    [self.lock unlock];
}

- (void)start
{
    NSLog(@"start in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    [self.lock lock];
    
    if ([self isCancelled]) {        
        [self performSelector:@selector(operationDidCancel)
                     onThread:[[self class] networkThread]
                   withObject:nil
                waitUntilDone:NO
                        modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
    } else if ([self isReady]) {
        
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        self.executing = YES;
        self.finished = NO;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
        
        [self performSelector:@selector(operationDidStart)
                     onThread:[[self class] networkThread]
                   withObject:nil
                waitUntilDone:NO
                        modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
    }
    
    [self.lock unlock];
}

#pragma mark -

- (void)operationDidCancel {
    NSLog(@"operationDidCancel in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    [self.lock lock];
    
    NSDictionary *userInfo = nil;
    if ([self.request URL]) {
        userInfo = [NSDictionary dictionaryWithObject:[self.request URL] forKey:NSURLErrorFailingURLErrorKey];
    }
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
    
    if (![self isFinished]) {
        if (self.connection) {
            [self.connection cancel];
            [self performSelector:@selector(connection:didFailWithError:) withObject:self.connection withObject:error];
        } else {
            self.error = error;
            
            [self callBackMainThreadError];
            
            [self operationDidFinish];
        }
    }
    
    [self.lock unlock];
}

- (void)operationDidStart {
    NSLog(@"operationDidStart in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    [self.lock lock];
    
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_connection start];
    
    [self.lock unlock];
}

- (void)operationDidFinish
{
    NSLog(@"operationDidFinish in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    [self.lock lock];
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    self.executing = NO;
    self.finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    [self.lock unlock];
}

#pragma mark -

- (void)callBackMainThreadSuccess {
    if (_successHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _successHandler(self, self.responseData);
        });
    }
}

- (void)callBackMainThreadError {
    if (_errorHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _errorHandler(self, self.error);
        });
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[cachedResponse response];
    _cacheHeaders = [httpResponse allHeaderFields];
    
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    _allHeaderFields = [(NSHTTPURLResponse*)response allHeaderFields];
    _allCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:_allHeaderFields forURL:[response URL]];
    _totalSize = [response expectedContentLength];  // bytes
    _statusCode = [(NSHTTPURLResponse*)response statusCode];
    
    long long length = [response expectedContentLength];
    if (length == NSURLResponseUnknownLength) {
        length = 0;
    }
    _responseData = [[NSMutableData alloc] initWithCapacity:(NSUInteger)length];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    
    _currentSize = [_responseData length];  // bytes
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    [self callBackMainThreadSuccess];
    
    [self operationDidFinish];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    
    self.error = error;
    
    [self callBackMainThreadError];
    
    [self operationDidFinish];
}

@end
