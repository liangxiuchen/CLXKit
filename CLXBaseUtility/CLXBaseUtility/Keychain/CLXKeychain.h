//
//  CLXKeychain.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLXKeychainItem.h"
#import "CLXKeychainQuery.h"

@interface CLXKeychain : NSObject

- (NSArray<CLXKeychainItem *> *)keychainItemsForQuery:(CLXKeychainQuery *)queryForAll error:(NSError **)error;

- (CLXKeychainItem *)keychainItemForQuery:(CLXKeychainQuery *)queryForOne error:(NSError **)error;

- (void)addKeychainItem:(CLXKeychainItem *)AddItem error:(NSError **)error;

- (void)deleteKeyChainItem:(CLXKeychainItem *)AddItem error:(NSError **)error;

- (void)updateKeyChainItem:(CLXKeychainItem *)AddItem InQuery:(CLXKeychainQuery *)queryForUpdate error:(NSError **)error;

@end
