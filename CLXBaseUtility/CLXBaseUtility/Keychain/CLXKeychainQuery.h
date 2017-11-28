//
//  CLXKeychainQuery.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/10/25.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CLXSecKeychainItemType)
{
    CLXSecKeychainItemNone = 0,
    CLXSecKeychainItemGenericPasswd,//kSecClassGenericPassword
    CLXSecKeychainItemInternetPasswd,//kSecClassInternetPassword
    CLXSecKeychainItemCertificate,//kSecClassCertificate
    CLXSecKeychainItemKey,//kSecClassKey
    CLXSecKeychainItemIdentity//kSecClassIdentity
};
extern const NSUInteger kCLXSecMatchLimitOne;
extern const NSUInteger kCLXSecMatchLimitAll;

@interface CLXKeychainQuery : NSObject

@property (nonatomic, assign) CLXSecKeychainItemType itemClassForQuery;//kSecClass
@property (nonnull, nonatomic, copy) NSString *serviceNameForQuery;//kSecAttrService
@property (nonnull, nonatomic, copy) NSString *accountForQuery;//kSecAttrAccount
@property (nullable, nonatomic, copy) NSString *accessGroupForQuery;//kSecAttrAccessGroup
@property (nonatomic, assign) BOOL shouldReturnData;//kSecReturnData
@property (nonatomic, assign) BOOL shouldReturnAttribute;//kSecReturnAttributes
@property (nonatomic, assign) NSUInteger matchLimits;//kSecMatchLimit

- (instancetype)initWithQueryDictionary:(NSDictionary *)dic;
- (NSDictionary *)dicForQuery;
- (NSDictionary *)dicForUpdateQuery;

@end
NS_ASSUME_NONNULL_END
