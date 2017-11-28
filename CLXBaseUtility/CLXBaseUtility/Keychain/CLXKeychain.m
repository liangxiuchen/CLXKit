//
//  CLXKeychain.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXKeychain.h"
@import Security;

@implementation CLXKeychain

- (CLXKeychainItem *)keychainItemForQuery:(CLXKeychainQuery *)queryForOne error:(NSError *__autoreleasing *)error
{
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)queryForOne.dicForQuery, &result);
    if (status != errSecSuccess) {
        *error = [NSError errorWithDomain:@"CLXKeychain-SecBase.h-CF_ENUM(OSStatus" code:status userInfo:nil];
        return nil;
    }
    if (CFGetTypeID(result) == CFDictionaryGetTypeID()) {
        NSDictionary *resultDic = (__bridge_transfer NSDictionary *)result;
        return [[CLXKeychainItem alloc] initWithResult:resultDic];
    } else {
        *error = [NSError errorWithDomain:@"CLXKeychain query success but result is not consistent" code:status userInfo:nil];
        return nil;
    }
}

- (NSArray<CLXKeychainItem *> *)keychainItemsForQuery:(CLXKeychainQuery *)queryForAll error:(NSError *__autoreleasing *)error
{
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)queryForAll.dicForQuery, &result);
    if (status != errSecSuccess) {
        *error = [NSError errorWithDomain:@"CLXKeychain-SecBase.h-CF_ENUM(OSStatus" code:status userInfo:nil];
        return nil;
    }
    if (CFGetTypeID(result) == CFDictionaryGetTypeID()) {
        NSDictionary *resultDic = (__bridge_transfer NSDictionary *)result;
        CLXKeychainItem *item = [[CLXKeychainItem alloc] initWithResult:resultDic];
        if (item) return @[item];
    } else if (CFGetTypeID(result) == CFArrayGetTypeID()) {
        NSArray *results = (__bridge_transfer NSArray *)result;
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *dic in results) {
            CLXKeychainItem *item = [[CLXKeychainItem alloc] initWithResult:dic];
            if (item) [items addObject:item];
        }
        return items;
    } else {
        *error = [NSError errorWithDomain:@"CLXKeychain query success but result is not consistent" code:status userInfo:nil];
    }
     return nil;
}

- (void)addKeychainItem:(CLXKeychainItem *)AddItem error:(NSError *__autoreleasing *)error
{
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)AddItem.dicForAdd, NULL);
    if (status != errSecSuccess) {
        *error = [NSError errorWithDomain:@"CLXKeychain-SecBase.h-CF_ENUM(OSStatus" code:status userInfo:nil];
    }
    return;
}

- (void)deleteKeyChainItem:(CLXKeychainItem *)AddItem error:(NSError *__autoreleasing *)error
{
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)AddItem.dicForDelete);
    if (status != errSecSuccess) {
        *error = [NSError errorWithDomain:@"CLXKeychain-SecBase.h-CF_ENUM(OSStatus)" code:status userInfo:nil];
    }
    return;
}

- (void)updateKeyChainItem:(CLXKeychainItem *)AddItem InQuery:(CLXKeychainQuery *)queryForUpdate error:(NSError *__autoreleasing *)error
{
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)queryForUpdate.dicForUpdateQuery, (__bridge CFDictionaryRef)AddItem.dicForUpdate);
    if (status != errSecSuccess) {
        *error = [NSError errorWithDomain:@"CLXKeychain-SecBase.h-CF_ENUM(OSStatus" code:status userInfo:nil];
    }
    return;
}

@end
