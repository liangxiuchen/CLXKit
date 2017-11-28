//
//  CLXEncryptor.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/7.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CLXEncryptorPadding)
{
    CLXEncryptorPKCS7Padding = 0x0001,
    CLXEncryptorECBMode = 0x0002,
};

@interface CLXEncryptor : NSObject

+ (NSData *)ase128EncryptWithData:(NSData *)plainData Key:(NSData **)key padding:(CLXEncryptorPadding)paddingMode;

+ (NSData *)ase128DecryptWith:(NSData *)cipher Key:(NSData *)key padding:(CLXEncryptorPadding)padding;

@end
