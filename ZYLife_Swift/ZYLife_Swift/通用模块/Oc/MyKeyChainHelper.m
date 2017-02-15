//
//  MyKeyChainHelper.m
//  KeyChainDemo
//
//  Created by 尹文高 on 15-06-10.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "MyKeyChainHelper.h"
#import <Security/Security.h>

@implementation MyKeyChainHelper

// 根据key获取KeyChain
+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:  
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            key, (__bridge_transfer id)kSecAttrService,
            key, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];  
}

/**
 *  保存私密数据
 */
+ (void) saveDataString:(NSString*)dataString
                dataKey:(NSString*)dataKey{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:dataKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:dataString] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

/**
 *  删除私密数据
 */
+ (void) deleteWithDataKey:(NSString*)dataKey{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:dataKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

/**
 *  获取私密数据
 */
+ (NSString*) getDataStringWithKey:(NSString*)dataKey{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:dataKey];
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", dataKey, e);
        }
        @finally
        {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
@end
