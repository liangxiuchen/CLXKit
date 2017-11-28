//
//  CLXURLEncodeMaker.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/2.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLXURLEncoder.h"

NS_ASSUME_NONNULL_BEGIN
@interface CLXURLEncodeMaker : NSObject

+ (nullable NSURL *)makePecentEncode:(void (^)(CLXURLEncoder *encoder))block;

@end
NS_ASSUME_NONNULL_END
