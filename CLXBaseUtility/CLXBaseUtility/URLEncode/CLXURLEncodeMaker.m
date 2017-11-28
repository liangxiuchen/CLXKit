//
//  CLXURLEncodeMaker.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/2.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXURLEncodeMaker.h"

@implementation CLXURLEncodeMaker

+ (NSURL *)makePecentEncode:(void (^)(CLXURLEncoder *))block
{
    CLXURLEncoder *encoder = [CLXURLEncoder new];
    block(encoder);
    return [NSURL URLWithString:encoder.encodedUrlStr];
}

@end
