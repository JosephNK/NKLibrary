//
//  UIApplication+Util.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Util)

+ (id)appDelegate;

+ (void)showNetworkActivityIndicator;
+ (void)hideNetworkActivityIndicator;

@end
