//
//  UIApplication+Util.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#include <sys/xattr.h>
#import "UIApplication+Util.h"
#import "NKMacro.h"


@implementation UIApplication (Util)

#pragma mark - 

+ (id)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

#pragma mark -

+ (void)showNetworkActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)hideNetworkActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -

+ (BOOL)checkJailBroken {
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]){
        LLog(@"JailBroken / Cydia.app");
        return YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]){
        LLog(@"JailBroken / apt");
        return YES;
    }
    
    return NO;
}

#define kInfoSize 500

+ (BOOL)checkPiracy {
    NSString *aString = [NSString stringWithFormat:@"%@%@%@",@"Sig",@"nerI",@"dentity"];
    BOOL checked = false;
    if([[[NSBundle mainBundle] infoDictionary] objectForKey:aString] == nil || [[[NSBundle mainBundle] infoDictionary] objectForKey:aString] != nil) {
        checked = true;
    }
    if(!checked)
    {
        LLog(@"Piracy / SignerIdentity");
        return YES;
    }
    
#if !TARGET_IPHONE_SIMULATOR
    int root = getgid();
    if (root <= 10) {
        return YES;
    }
#endif
    
    //Place your NSLog Plist Size into the above Define statment
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* path = [NSString stringWithFormat:@"%@/Info.plist", bundlePath ];
    NSDictionary *fileInfo = [[NSBundle mainBundle] infoDictionary];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
    if (fileAttributes != nil) {
        NSNumber *fileSize;
        if(fileSize == [fileAttributes objectForKey:NSFileSize]){
            LLog(@"File Size:  %qi\n", [fileSize unsignedLongLongValue]);
            //Best to see the File Size and change it accordingly first
            NSString *cSID = [NSString stringWithFormat:@"%@%@%@%@%@",@"Si",@"gne",@"rIde",@"ntity",@""];
            BOOL checkedforPir = false;
            if([fileInfo objectForKey:cSID] == nil || [fileInfo objectForKey:cSID] != nil) {
                if([fileSize unsignedLongLongValue] == kInfoSize) {
                    checkedforPir = true;
                }
            }
            if(!checkedforPir){
                return YES;
            }
        }
    }

    return NO;
}




@end
