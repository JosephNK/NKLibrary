//
//  NKKeychain.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 18..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "NKKeychain.h"
#import "NKMacro.h"

@implementation NSString (Bundle)

+ (NSString *)bundleSeedID {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           NK_BRIDGE_CAST(id, kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching(NK_BRIDGE_CAST(CFDictionaryRef, query), (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd(NK_BRIDGE_CAST(CFDictionaryRef, query), (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [NK_BRIDGE_CAST(NSDictionary *, result) objectForKey:NK_BRIDGE_CAST(id, kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

@end

@interface NKKeychain()

@property (nonatomic, strong) KeychainItemWrapper *wrapper;

@end

@implementation NKKeychain

#pragma mark -

- (void)dealloc
{
    NK_RELEASE(_wrapper);
    NK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSAssert(NO, @"You should use 'initWithIdentifier: accessGroup:'");
    }
    return self;
}

- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup
{
    self = [super init];
    if (self) {
        NSString *group = [NSString stringWithFormat:@"%@.%@", [NSString bundleSeedID], accessGroup];
        _wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:identifier
                                                       accessGroup:group];
    }
    return self;
}

- (void)resetKeychainItem {
    [_wrapper resetKeychainItem];
}

- (void)setAccount:(NSString *)account {
    [_wrapper setObject:account forKey: NK_BRIDGE_CAST(id, kSecAttrAccount)];
}

- (void)setLabel:(NSString *)label {
    [_wrapper setObject:label forKey: NK_BRIDGE_CAST(id, kSecAttrLabel)];
}

- (void)setDescription:(NSString *)description {
    [_wrapper setObject:description forKey: NK_BRIDGE_CAST(id, kSecAttrDescription)];
}

- (void)setData:(NSData *)data {
    [_wrapper setObject:data forKey: NK_BRIDGE_CAST(id, kSecValueData)];
}

- (NSString *)getAccount {
    return [_wrapper objectForKey:NK_BRIDGE_CAST(id, kSecAttrAccount)];
}

- (NSString *)getLabel {
    return [_wrapper objectForKey:NK_BRIDGE_CAST(id, kSecAttrLabel)];
}

- (NSString *)getDescription {
    return [_wrapper objectForKey:NK_BRIDGE_CAST(id, kSecAttrDescription)];
}

- (NSData *)getData {
    return [_wrapper objectForKey:NK_BRIDGE_CAST(id, kSecValueData)];
}


@end
