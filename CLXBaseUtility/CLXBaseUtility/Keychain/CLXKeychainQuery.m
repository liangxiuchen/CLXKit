//
//  CLXKeychainQuery.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/10/25.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXKeychainQuery.h"

const NSUInteger kCLXSecMatchLimitOne = 1;
const NSUInteger kCLXSecMatchLimitAll = NSUIntegerMax;

__unused static id secKeychainItemClass(CLXSecKeychainItemType type)
{
    switch (type) {
        case CLXSecKeychainItemGenericPasswd:
            return (__bridge id)kSecClassGenericPassword;
            break;
        case CLXSecKeychainItemInternetPasswd:
            return (__bridge id)kSecClassInternetPassword;
            break;
        case CLXSecKeychainItemCertificate:
            return (__bridge id)kSecClassCertificate;
            break;
        case CLXSecKeychainItemKey:
            return (__bridge id)kSecClassKey;
            break;
        case CLXSecKeychainItemIdentity:
            return (__bridge id)kSecClassIdentity;
            break;
        default:
            return (__bridge id)kSecClassGenericPassword;
            break;
    }
}

static CLXSecKeychainItemType secKeychainItemType(NSString *class)
{
    if ([class isEqualToString:(__bridge id)kSecClassGenericPassword]) {
        return CLXSecKeychainItemGenericPasswd;
    }
    if ([class isEqualToString:(__bridge id)kSecClassInternetPassword]) {
        return CLXSecKeychainItemInternetPasswd;
    }
    if ([class isEqualToString:(__bridge id)kSecClassCertificate]) {
        return CLXSecKeychainItemCertificate;
    }
    if ([class isEqualToString:(__bridge id)kSecClassKey]) {
        return CLXSecKeychainItemKey;
    }
    if ([class isEqualToString:(__bridge id)kSecClassIdentity]) {
        return CLXSecKeychainItemIdentity;
    }
    return CLXSecKeychainItemNone;
}

@implementation CLXKeychainQuery

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemClassForQuery = CLXSecKeychainItemGenericPasswd;
        _shouldReturnData = YES;
        _shouldReturnAttribute = YES;
        _matchLimits = kCLXSecMatchLimitOne;
    }
    return self;
}

- (instancetype)initWithQueryDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self && dic.count > 0) {
        self.itemClassForQuery = secKeychainItemType(dic[(__bridge id)kSecClass]);
        self.serviceNameForQuery = dic[(__bridge id)kSecAttrService];
        self.accountForQuery = dic[(__bridge id)kSecAttrAccount];
        self.accessGroupForQuery = dic[(__bridge id)kSecAttrAccessGroup];
        self.shouldReturnData = CFBooleanGetValue((__bridge CFBooleanRef)dic[(__bridge id)kSecReturnData]);
        self.shouldReturnAttribute = CFBooleanGetValue((__bridge CFBooleanRef)dic[(__bridge id)kSecReturnAttributes]);
        id limit = dic[(__bridge id)kSecMatchLimit];
        if (CFGetTypeID((CFTypeRef)limit) == CFStringGetTypeID()) {
            NSString *limitStr = (NSString *)limit;
            if ([limitStr isEqualToString:(__bridge NSString *)kSecMatchLimitAll]) {
                self.matchLimits = kCLXSecMatchLimitAll;
            } else {
                self.matchLimits = kCLXSecMatchLimitOne;
            }
        } else {
            NSNumber *limitNum = (NSNumber *)limit;
            self.matchLimits = limitNum.unsignedIntegerValue;
        }
    }
    return self;
}

- (NSDictionary *)dicForQuery
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.itemClassForQuery) {
        dic[(__bridge id)kSecClass] = secKeychainItemClass(self.itemClassForQuery);
    }
    if (self.serviceNameForQuery) {
        dic[(__bridge id)kSecAttrService] = self.serviceNameForQuery;
    }
    if (self.accountForQuery) {
        dic[(__bridge id)kSecAttrAccount] = self.accountForQuery;
    }
    if (self.accessGroupForQuery) {
        dic[(__bridge id)kSecAttrAccessGroup] = self.accessGroupForQuery;
    }
    dic[(__bridge id)kSecReturnData] = self.shouldReturnData ? (__bridge id)kCFBooleanTrue : (__bridge id)kCFBooleanFalse;
    dic[(__bridge id)kSecReturnAttributes] = self.shouldReturnAttribute ? (__bridge id)kCFBooleanTrue : (__bridge id)kCFBooleanFalse;
    if (self.matchLimits == kCLXSecMatchLimitOne) {
        dic[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    } else if (self.matchLimits == kCLXSecMatchLimitAll) {
        dic[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    } else {
        dic[(__bridge id)kSecMatchLimit] = @(self.matchLimits);
    }
    return dic;
}

- (NSDictionary *)dicForUpdateQuery
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.itemClassForQuery) {
        dic[(__bridge id)kSecClass] = secKeychainItemClass(self.itemClassForQuery);
    }
    if (self.serviceNameForQuery) {
        dic[(__bridge id)kSecAttrService] = self.serviceNameForQuery;
    }
    if (self.accountForQuery) {
        dic[(__bridge id)kSecAttrAccount] = self.accountForQuery;
    }
    if (self.accessGroupForQuery) {
        dic[(__bridge id)kSecAttrAccessGroup] = self.accessGroupForQuery;
    }
    return dic;
}

@end
