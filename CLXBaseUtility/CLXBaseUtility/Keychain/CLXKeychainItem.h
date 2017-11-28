//
//  CLXKeychainItem.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, CLXSecAccessControlFlag)
{
    CLXSecAccessControlNone                     = 0,
    CLXSecAccessControlUserPresence             = 1u << 0,
    CLXSecAccessControlTouchIDAny             NS_ENUM_AVAILABLE_IOS(9_0) = 1u << 1,
    CLXSecAccessControlTouchIDCurrentSet      NS_ENUM_AVAILABLE_IOS(9_0) = 1u << 3,
    CLXSecAccessControlDevicePasscode         NS_ENUM_AVAILABLE_IOS(9_0) = 1u << 4,
    CLXSecAccessControlOr                     NS_ENUM_AVAILABLE_IOS(9_0) = 1u << 14,
    CLXSecAccessControlAnd                    NS_ENUM_AVAILABLE_IOS(9_0) = 1u << 15,
    CLXSecAccessControlPrivateKeyUsage        NS_ENUM_AVAILABLE_IOS(9_0) = 1u << 30,
    CLXSecAccessControlApplicationPassword    NS_ENUM_AVAILABLE_IOS(9_0) = 1u << 31,
};

typedef NS_ENUM(NSUInteger, CLXSecAccessibleType)
{
    CLXSecAccessibleNone = 0,
    CLXSecAccessibleWhenUnlocked,
    CLXSecAccessibleAfterFirstUnlock,
    CLXSecAccessibleAlways,
    CLXSecAccessibleWhenPasscodeSetThisDeviceOnly NS_AVAILABLE_IOS(8_0),
    CLXSecAccessibleWhenUnlockedThisDeviceOnly,
    CLXSecAccessibleAfterFirstUnlockThisDeviceOnly,
    CLXSecAccessibleAlwaysThisDeviceOnly,
} NS_AVAILABLE_IOS(4_0);

typedef NS_ENUM(NSUInteger, CLXSecSynchronizableType)
{
    CLXSecSynchronizableNone = 0,
    CLXSecSynchronizableAny,
    CLXSecSynchronizableYES,
    CLXSecSynchronizableNO
} NS_AVAILABLE_IOS(7_0);

@interface CLXKeychainItem : NSObject<NSCopying>

//protected value
@property (nullable, nonatomic, strong) NSData *secData;
//>>-----sec keychainItem attributes
@property (nullable, nonatomic, copy) NSString *secServiceName;//kSecAttrService
@property (nullable, nonatomic, copy) NSString *secAccount;//kSecAttrAccount
@property (nullable, nonatomic, copy) NSString *secAccessGroup;//kSecAttrAccessGroup
@property (nullable, nonatomic, copy) NSString *secDescription;//kSecAttrDescription
@property (nullable, nonatomic, copy) NSString *secComment;//kSecAttrComment
@property (nullable, nonatomic, strong) NSNumber *secCreator;//kSecAttrCreator
@property (nullable, nonatomic, copy) NSString *secLabel;//kSecAttrLabel

@property (nonatomic) CLXSecAccessibleType secAccessible;//kSecAttrAccessible
@property (nonatomic, assign) CLXSecAccessControlFlag secAccessControlFlag NS_AVAILABLE_IOS(9_0);//kSecAttrAccessControl
@property (nonatomic) CLXSecSynchronizableType secSynchronizable NS_AVAILABLE_IOS(7_0);//kSecAttrSynchronizable

@property (nullable, nonatomic, readonly) NSDate *secCreationDate;//kSecAttrCreationDate
@property (nullable, nonatomic, readonly) NSDate *secModificationDate;
//>>-------end
- (instancetype)initWithResult:(NSDictionary *)result;
- (NSDictionary *)dicForAdd;
- (NSDictionary *)dicForUpdate;
- (NSDictionary *)dicForDelete;

@end

NS_ASSUME_NONNULL_END
