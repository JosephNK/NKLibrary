//
//  NKURLConnection.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKURLRequest.h"
#import "NKURLConnectionOperation.h"

@interface NKURLConnection : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

+ (instancetype)manager;

- (void)requestHttpURL:(NSString *)urlString
                method:(NSString *)method
            parameters:(id)parameters
               success:(NKOperationSuccessHandler)successHandler
                 error:(NKOperationErrorHandler)errorHandler;

- (void)requestJsonURL:(NSString *)urlString
                method:(NSString *)method
            parameters:(id)parameters
               success:(NKOperationSuccessHandler)successHandler
                 error:(NKOperationErrorHandler)errorHandler;

- (void)requestXMLURL:(NSString *)urlString
               method:(NSString *)method
           parameters:(id)parameters
              success:(NKOperationSuccessHandler)successHandler
                error:(NKOperationErrorHandler)errorHandler;

@end
