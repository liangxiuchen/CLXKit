//
//  NSDictionary+CLXAdd.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/14.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (CLXAdd)

- (NSDictionary *)clx_caseInsensitiveDictionary;

@end
NS_ASSUME_NONNULL_END
