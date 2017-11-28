//
//  CLXKeychainItem.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXKeychainItem.h"

static CLXSecAccessibleType clxSecAccessibleType(NSString *secAttrAccessible)
{
    if ([secAttrAccessible isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlocked]) {
        return CLXSecAccessibleWhenUnlocked;
    }
    if ([secAttrAccessible isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlock]) {
        return CLXSecAccessibleAfterFirstUnlock;
    }
    if ([secAttrAccessible isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlways]) {
        return CLXSecAccessibleAlways;
    }
    if ([secAttrAccessible isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly]) {
        return CLXSecAccessibleWhenPasscodeSetThisDeviceOnly;
    }
    if ([secAttrAccessible isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlockedThisDeviceOnly]) {
        return CLXSecAccessibleWhenUnlockedThisDeviceOnly;
    }
    if ([secAttrAccessible isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly]) {
        return CLXSecAccessibleAfterFirstUnlockThisDeviceOnly;
    }
    if ([secAttrAccessible isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlwaysThisDeviceOnly]) {
        return CLXSecAccessibleAlwaysThisDeviceOnly;
    }
    return CLXSecAccessibleNone;
}

static NSString *secAttrAccessible(CLXSecAccessibleType type)
{
    switch (type) {
        case CLXSecAccessibleWhenUnlocked:
            return (__bridge NSString *)kSecAttrAccessibleWhenUnlocked;
            break;
        case CLXSecAccessibleAfterFirstUnlock:
            return (__bridge NSString *)kSecAttrAccessibleAfterFirstUnlock;
            break;
        case CLXSecAccessibleAlways:
            return (__bridge NSString *)kSecAttrAccessibleAlways;
            break;
        case CLXSecAccessibleWhenPasscodeSetThisDeviceOnly:
            return (__bridge NSString *)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly;
            break;
        case CLXSecAccessibleWhenUnlockedThisDeviceOnly:
            return (__bridge NSString *)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
            break;
        case CLXSecAccessibleAfterFirstUnlockThisDeviceOnly:
            return (__bridge NSString *)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
            break;
        case CLXSecAccessibleAlwaysThisDeviceOnly:
            return (__bridge NSString *)kSecAttrAccessibleAlwaysThisDeviceOnly;
            break;
        default:
            return nil;
            break;
    }
}

static CLXSecSynchronizableType clxSecSynchronizableType(NSNumber *secSync)
{
    if (nil == secSync) {
        return CLXSecSynchronizableNone;
    }
    if (secSync && ![secSync isKindOfClass:[NSNumber class]]) {
        return CLXSecSynchronizableAny;
    }
    if (secSync.boolValue) {
        return CLXSecSynchronizableYES;
    } else {
        return CLXSecSynchronizableNO;
    }
}

static id secSynchronizable(CLXSecSynchronizableType type)
{
    switch (type) {
        case CLXSecSynchronizableNO:
            return (__bridge id)kCFBooleanFalse;
            break;
        case CLXSecSynchronizableYES:
            return (__bridge id)kCFBooleanTrue;
            break;
        case CLXSecSynchronizableAny:
            return (__bridge id)kSecAttrSynchronizableAny;
            break;
        default:
            return (__bridge id)kSecAttrSynchronizableAny;
            break;
    }
}

static SecAccessControlCreateFlags secAccessControlCreateFlags(CLXSecAccessControlFlag flag)
{
    switch (flag) {
        case CLXSecAccessControlUserPresence:
            return kSecAccessControlUserPresence;
            break;
        case CLXSecAccessControlTouchIDAny:
            return kSecAccessControlTouchIDAny;
            break;
        case CLXSecAccessControlTouchIDCurrentSet:
            return kSecAccessControlTouchIDCurrentSet;
            break;
        case CLXSecAccessControlDevicePasscode:
            return kSecAccessControlDevicePasscode;
            break;
        case CLXSecAccessControlOr :
            return kSecAccessControlOr;
            break;
        case CLXSecAccessControlAnd:
            return kSecAccessControlAnd;
            break;
        case CLXSecAccessControlPrivateKeyUsage:
            return kSecAccessControlPrivateKeyUsage;
            break;
        case CLXSecAccessControlApplicationPassword:
            return kSecAccessControlApplicationPassword;
            break;
        default:
            return kSecAccessControlUserPresence;
            break;
    }
}

static id secAccessControl(CLXSecAccessControlFlag flag, CLXSecAccessibleType type)
{
    CFErrorRef error = NULL;
    SecAccessControlRef control = SecAccessControlCreateWithFlags(kCFAllocatorDefault, (__bridge CFTypeRef)secAttrAccessible(type), secAccessControlCreateFlags(flag), &error);
    if (error) {
        return nil;
    } else {
        return (__bridge id)control;
    }
}

@implementation CLXKeychainItem

- (instancetype)init
{
    self = [self initWithResult:@{}];
    return self;
}

- (instancetype)initWithResult:(NSDictionary *)result
{
    self = [super init];
    if (self) {
        _secData = result[(__bridge id)kSecValueData];
        _secServiceName = result[(__bridge id)kSecAttrService];
        _secAccount = result[(__bridge id)kSecAttrAccount];
        _secAccessGroup = result[(__bridge id)kSecAttrAccessGroup];
        _secDescription = result[(__bridge id)kSecAttrDescription];
        _secComment = result[(__bridge id)kSecAttrComment];
        _secCreator = result[(__bridge id)kSecAttrCreator];
        _secLabel = result[(__bridge id)kSecAttrLabel];
        _secCreationDate = result[(__bridge id)kSecAttrCreationDate];
        _secModificationDate = result[(__bridge id)kSecAttrModificationDate];
        _secAccessible = clxSecAccessibleType(result[(__bridge id)kSecAttrAccessible]);
        _secSynchronizable = clxSecSynchronizableType(result[(__bridge id)kSecAttrSynchronizable]);
        _secAccessControlFlag = CLXSecAccessControlNone;
    }
    return self;
}

- (NSDictionary *)dicForAdd
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    if (self.secData) {
        dic[(__bridge id)kSecValueData] = self.secData;
    }
    if (self.secServiceName) {
        dic[(__bridge id)kSecAttrService] = self.secServiceName;
    }
    if (self.secAccount) {
        dic[(__bridge id)kSecAttrAccount] = self.secAccount;
    }
#if TARGET_OS_IOS
    if (self.secAccessGroup) {
        dic[(__bridge id)kSecAttrAccessGroup] = self.secAccessGroup;
    }
#endif
    if (self.secDescription) {
        dic[(__bridge id)kSecAttrDescription] = self.secDescription;
    }
    if (self.secComment) {
        dic[(__bridge id)kSecAttrComment] = self.secComment;
    }
    if (self.secCreator) {
        dic[(__bridge id)kSecAttrCreator] = self.secCreator;
    }
    if (self.secLabel) {
        dic[(__bridge id)kSecAttrLabel] = self.secLabel;
    }
    if (self.secAccessible != CLXSecAccessibleNone) {
        dic[(__bridge id)kSecAttrAccessible] = secAttrAccessible(self.secAccessible);
    }
    if (self.secSynchronizable != CLXSecSynchronizableNone) {
        dic[(__bridge id)kSecAttrSynchronizable] = secSynchronizable(self.secSynchronizable);
    }
    if (self.secAccessControlFlag != CLXSecAccessControlNone &&
        self.secAccessible != CLXSecAccessibleNone
        ) {
        dic[(__bridge id)kSecAttrAccessControl] = secAccessControl(self.secAccessControlFlag, self.secAccessible);
    }
    return dic;
}

- (NSDictionary *)dicForUpdate
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.secData) {
        dic[(__bridge id)kSecValueData] = self.secData;
    }
    if (self.secServiceName) {
        dic[(__bridge id)kSecAttrService] = self.secServiceName;
    }
    if (self.secAccount) {
        dic[(__bridge id)kSecAttrAccount] = self.secAccount;
    }
#if TARGET_OS_IOS
    if (self.secAccessGroup) {
        dic[(__bridge id)kSecAttrAccessGroup] = self.secAccessGroup;
    }
#endif
    if (self.secDescription) {
        dic[(__bridge id)kSecAttrDescription] = self.secDescription;
    }
    if (self.secComment) {
        dic[(__bridge id)kSecAttrComment] = self.secComment;
    }
    if (self.secCreator) {
        dic[(__bridge id)kSecAttrCreator] = self.secCreator;
    }
    if (self.secLabel) {
        dic[(__bridge id)kSecAttrLabel] = self.secLabel;
    }
    if (self.secAccessible != CLXSecAccessibleNone) {
        dic[(__bridge id)kSecAttrAccessible] = secAttrAccessible(self.secAccessible);
    }
    if (self.secSynchronizable != CLXSecSynchronizableNone) {
        dic[(__bridge id)kSecAttrSynchronizable] = secSynchronizable(self.secSynchronizable);
    }
    if (self.secAccessControlFlag != CLXSecAccessControlNone &&
        self.secAccessible != CLXSecAccessibleNone
        ) {
        dic[(__bridge id)kSecAttrAccessControl] = secAccessControl(self.secAccessControlFlag, self.secAccessible);
    }
    return dic;
}

- (NSDictionary *)dicForUpdateQuery
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    if (self.secServiceName) {
        dic[(__bridge id)kSecAttrService] = self.secServiceName;
    }
    if (self.secAccount) {
        dic[(__bridge id)kSecAttrAccount] = self.secAccount;
    }
#if TARGET_OS_IOS
    if (self.secAccessGroup) {
        dic[(__bridge id)kSecAttrAccessGroup] = self.secAccessGroup;
    }
#endif
    return dic;
}

- (NSDictionary *)dicForDelete
{
    return [self dicForUpdateQuery];
}

- (NSDictionary *)dicForDescription
{
    return @{
             @"secData" : self.secData ?: [NSNull null],
             @"secServiceName" : self.secServiceName ?: [NSNull null],
             @"secAccount" : self.secAccount ?: [NSNull null],
             @"secAccessGroup" : self.secAccessGroup ?: [NSNull null],
             @"secDescription" : self.secDescription ?: [NSNull null],
             @"secComment" : self.secComment ?: [NSNull null],
             @"secCreator" : self.secCreator ?: [NSNull null],
             @"secLabel" : self.secLabel ?: [NSNull null],
             @"secAccessible" : @(self.secAccessible),
             @"secAccessControlFlag" : @(self.secAccessControlFlag),
             @"secSynchronizable" : @(self.secSynchronizable),
             @"secCreationDate" : self.secCreationDate ?: [NSNull null],
             @"secModificationDate" : self.secModificationDate ?: [NSNull null]
         };
}

- (id)copyWithZone:(NSZone *)zone
{
    CLXKeychainItem *duplicated = [[CLXKeychainItem alloc] initWithResult:self.dicForAdd];
    return duplicated;
}

- (NSString *)description
{
    return [[self dicForDescription] description];
}

@end
