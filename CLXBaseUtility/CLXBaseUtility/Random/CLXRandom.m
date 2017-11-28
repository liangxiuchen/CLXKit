//
//  CLXRandom.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXRandom.h"
#import <Security/SecRandom.h>

@implementation CLXRandom

+ (NSData *)secRandomDataWithLength:(NSUInteger)bytes
{
    void *random = malloc(bytes);
    int result = SecRandomCopyBytes(kSecRandomDefault, bytes, random);
    if (result == 0) {
        return [NSData dataWithBytes:random length:bytes];
    } else {
        return nil;
    }
}

+ (uint32_t)arc4
{
    return arc4random();
}

+ (uint32_t)arc4WithUpperBound:(uint32_t)ceil
{
    return arc4random_uniform(ceil);
}

@end
