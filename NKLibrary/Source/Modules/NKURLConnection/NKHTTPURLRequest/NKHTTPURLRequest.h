//
//  NKHTTPURLRequest.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 6..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NKDataType) {
    // HTTPHeaderField("Content-Type")  Set "application/x-www-form-urlencoded";
    // HTTPHeaderField("Accept")        Set "";
    NKDataTypeTEXT,
    
    // HTTPHeaderField("Content-Type")  Set "application/json;";
    // HTTPHeaderField("Accept")        Set "application/json;";
    NKDataTypeJSON,
    
    // HTTPHeaderField("Content-Type")  Set "application/json;";
    // HTTPHeaderField("Accept")        Set "*/*";
    NKDataTypeReceiveJSON,
    
    // HTTPHeaderField("Content-Type")  Set "";
    // HTTPHeaderField("Accept")        Set "application/json;";
    NKDataTypeResponseJSON,
};

typedef NS_ENUM(NSUInteger, NKEncryptType) {
    NKEncryptTypeNon,
    NKEncryptTypeAES256,
    NKEncryptTypeDES,
    NKEncryptTypeCAST
};



@interface NKHTTPURLRequest : NSObject

@property (nonatomic, strong) NSString *requestURL;

/**
 Default : GET
  */
@property (nonatomic, assign) NSString *HTTPMethod;

/**
 Default : NSUTF8StringEncoding
 */
@property (nonatomic, assign) NSStringEncoding stringEncoding;

/**
 Default : YES
 */
@property (nonatomic, assign) BOOL allowsCellularAccess;

/**
 Default : NSURLRequestUseProtocolCachePolicy
 */
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

/**
 Default : YES
 */
@property (nonatomic, assign) BOOL HTTPShouldHandleCookies;

/**
 Default : NO
 */
@property (nonatomic, assign) BOOL HTTPShouldUsePipelining;

/**
 Default : NSURLNetworkServiceTypeDefault
 */
@property (nonatomic, assign) NSURLRequestNetworkServiceType networkServiceType;

/**
 Default : 60 sec
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 HTTP Method Definitions; @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html
 
 Default : `GET`, `HEAD`, and `DELETE`.
 */
@property (nonatomic, strong) NSSet *HTTPMethodsEncodingParametersInURI;

/**
 NKURLDataType Definitions; @see enum NKURLDataType
 
 Default : NKURLDataTypeTEXT
 */
@property (nonatomic, assign) NKDataType dataType;

/**
 NKEncryptType Definitions; @see enum NKEncryptType
 
 Default : NKEncryptTypeNon
 */
@property (nonatomic, assign) NKEncryptType encryptType;

/**
 
  */
@property (nonatomic, assign) id parameters;

+ (instancetype)manager;

- (void)setVariableMethodType:(NSString *)methodType
                     DataType:(NKDataType)dataType
                   RequestURL:(NSString *)requestURL
                   Parameters:(id)parameters;

- (NSMutableURLRequest *)requestSerialization;

//- (NSMutableURLRequest *)requestWithMethodType:(NSString *)methodType
//                                  withDataType:(NKDataType)dataType
//                                withRequestURL:(NSString *)requestURL
//                                withParameters:(id)parameters;

@end
