//
//  UIApplication+Util.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "UIApplication+Util.h"

@implementation UIApplication (Util)

+ (id)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}


+ (void)showNetworkActivityIndicator {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)hideNetworkActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
