//
//  NKURLConnection.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKCategory.h"
#import "NKMacro.h"

typedef NS_ENUM(NSUInteger, NKURLType) {
    NKURLTypeGET,
    NKURLTypePOST
};

typedef void (^ReceiveResponseBlock)(NSURLResponse *response);
typedef void (^ReceiveDataBlock)(NSData *data);
typedef void (^CompleteBlock)(NSData *data);
typedef void (^ErrorBlock)(NSError *error);

@interface NKURLConnection : NSObject

+ (instancetype)manager;

- (void)requestWithURL:(NSString *)url
                  type:(NKURLType)type
            parameters:(NSDictionary *)parameters
                 async:(BOOL)bAsync
  receiveResponseBlock:(ReceiveResponseBlock)receiveResponseBlock
      receiveDataBlock:(ReceiveDataBlock)receiveDataBlock
         completeBlock:(CompleteBlock)completeBlock
            errorBlock:(ErrorBlock)errorBlock;

@end
