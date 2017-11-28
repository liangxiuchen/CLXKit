//
//  CLXSymmetricCryptor.m
//  CLXDigest
//
//  Created by chen liangxiu on 2017/10/21.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXSymmetricCryptor.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation CLXSymmetricCryptor {
    CCCryptorRef cryptor;
}

- (void)dealloc
{
    CCCryptorRelease(cryptor);
    cryptor = NULL;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
};

@end
