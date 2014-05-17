//
//  NKKeychain.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 18..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Xcode 5
 1. Project -> Targets -> Capabilities -> Keychain Sharing -> ON
 2. Keychain Groups : (e.g.,) com.nkw0608.KeyChainFamily
 
 <Bundle Seed ID> . <Bundle  Identifier>
 example if I have two applications as follows:
    ABC1234DEF.com.useyourloaf.amazingApp1
    ABC1234DEF.com.useyourloaf.amazingApp2
 
 I could define a common keychain access group as follows:
    ABC1234DEF.amazingAppFamily
 refer : http://useyourloaf.com/blog/2010/04/03/keychain-group-access.html
 */

@interface NSString (Bundle)

@end

@interface NKKeychain : NSObject

- (id)init
__attribute__((deprecated("You should use 'initWithIdentifier: accessGroup:' ")));

/**
 e.g., [[KeychainItemWrapper alloc] initWithIdentifier:@"Account" accessGroup:@"com.nkw0608.KeyChainFamily"]
 */
- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup;

/**
 
 */
- (void)resetKeychainItem;

/**
 
 */
- (void)setAccount:(NSString *)account;
- (void)setLabel:(NSString *)label;
- (void)setDescription:(NSString *)description;
- (void)setData:(NSData *)data;

/**
 
 */
- (NSString *)getAccount;
- (NSString *)getLabel;
- (NSString *)getDescription;
- (NSData *)getData;

@end
