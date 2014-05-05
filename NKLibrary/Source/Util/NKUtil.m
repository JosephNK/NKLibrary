//
//  NKUtil.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKUtil.h"
#include <sys/xattr.h>

@implementation NKUtil

#pragma mark - 

+ (void)iCloudDoNotBackup {
    // iCloud do not BackUp
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL *pathURL= [NSURL fileURLWithPath:documentsDirectory];
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0f){
        [self addSkipBackupAttributeToItemAtURL:pathURL];
    }else{
        NSLog(@"CANNOT - CUZ VERSION IS UNDER 5.0.1");
    }
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

#pragma mark - 

+ (void)appUpdateChecker {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL versionUpgraded = FALSE;
    BOOL newInstall = FALSE;
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *preVersion = [prefs stringForKey:@"appVersion"];
    
    
    if ([prefs stringForKey:@"appVersion"] == nil) {
        // new install
        newInstall = YES;
        // ...
        
    } else {
        // upgreade
        if ([preVersion isEqualToString:currentVersion]) {
            // same version install
            versionUpgraded = NO;
            // ...
            
        }else {
            // other version install
            versionUpgraded = YES;
            // ...
            
        }
    }
    
    if (versionUpgraded || newInstall) {
        [prefs setObject:currentVersion forKey:@"appVersion"];
        [prefs setObject:preVersion forKey:@"prevAppVersion"];
        [prefs synchronize];
    }
}

@end
