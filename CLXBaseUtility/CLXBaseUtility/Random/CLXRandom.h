//
//  CLXRandom.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLXRandom : NSObject

+ (NSData *)secRandomDataWithLength:(NSUInteger)bytes;
+ (uint32_t)arc4;
+ (uint32_t)arc4WithUpperBound:(uint32_t)ceil;

@end
