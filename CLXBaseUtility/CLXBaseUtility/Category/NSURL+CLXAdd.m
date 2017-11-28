//
//  NSURL+CLXAdd.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/1.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "NSURL+CLXAdd.h"
@import MobileCoreServices;

@implementation NSURL (CLXAdd)
@dynamic clx_imageResource;

- (BOOL)clx_isImage
{
    NSString *value = nil;
    [self getResourceValue:&value forKey:NSURLTypeIdentifierKey error:nil];
    assert(value);
    if (!value) {
        return UTTypeConformsTo((__bridge CFStringRef)value, kUTTypeImage);
    } else {
        return NO;
    }
}

@end
