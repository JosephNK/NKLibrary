//
//  NKURLConnection.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKURLConnection.h"
#import "NKMacro.h"

@interface NKURLConnection()
@end

@implementation NKURLConnection

#pragma mark -

- (void)dealloc
{
    LLog(@"<dealloc> NKURLConnection");
    NK_SUPER_DEALLOC();
}

#pragma mark -

+ (instancetype)manager {
    return NK_AUTORELEASE([[self alloc] init]);
    //return [[self alloc] init];
}

- (instancetype)init {
    if ((self = [super init])) {
//        self.requestHttp = [NKHTTPURLRequest manager];
//        self.requestJson = [NKJSONURLRequest manager];
//        self.requestXml = [NKXMLURLRequest manager];
//        self.connection = [NKHTTPURLConnection manager];
        
        _operationQueue = NK_AUTORELEASE([[NSOperationQueue alloc] init]);
        [_operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return self;
}

#pragma mark -

- (void)requestHttpURL:(NSString *)urlString
                method:(NSString *)method
            parameters:(id)parameters
               success:(NKOperationSuccessHandler)successHandler
                 error:(NKOperationErrorHandler)errorHandler
{
    NSURLRequest *request = [[NKURLRequest manager] requestCreateByURL:urlString
                                                            HTTPMethod:method
                                                            Parameters:parameters];
    
    [self logRequest:request];
    
    NKURLConnectionOperation *operation = [NKURLConnectionOperation managerWithRequest:request];
    [operation success:successHandler failure:errorHandler];
    
    [self.operationQueue addOperation:operation];
}

- (void)requestJsonURL:(NSString *)urlString
                method:(NSString *)method
            parameters:(id)parameters
               success:(NKOperationSuccessHandler)successHandler
                 error:(NKOperationErrorHandler)errorHandler
{
    NSURLRequest *request = [[NKURLRequestJSON manager] requestCreateByURL:urlString
                                                                HTTPMethod:method
                                                                Parameters:parameters];
    
    [self logRequest:request];
    
    NKURLConnectionOperation *operation = [NKURLConnectionOperation managerWithRequest:request];
    [operation success:successHandler failure:errorHandler];
    
    [self.operationQueue addOperation:operation];
}

- (void)requestXMLURL:(NSString *)urlString
               method:(NSString *)method
           parameters:(id)parameters
              success:(NKOperationSuccessHandler)successHandler
                error:(NKOperationErrorHandler)errorHandler
{
    NSURLRequest *request = [[NKURLRequestXML manager] requestCreateByURL:urlString
                                                                HTTPMethod:method
                                                                Parameters:parameters];
    
    [self logRequest:request];
    
    NKURLConnectionOperation *operation = [NKURLConnectionOperation managerWithRequest:request];
    [operation success:successHandler failure:errorHandler];
    
    [self.operationQueue addOperation:operation];
}

#pragma mark -

- (void)logRequest:(NSURLRequest *)request {
    LLog(@"Request URL: %@", [[request URL] absoluteString]);
    LLog(@"Request Header: %@", [request allHTTPHeaderFields]);
    LLog(@"Request Body: %@", NK_AUTORELEASE([[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]));
}

@end
