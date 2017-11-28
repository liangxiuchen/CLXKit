//
//  CLXWeakProxy.h
//  CLXDigest
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface CLXWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

+ (instancetype)weakProxyWithTarget:(nonnull id)target;
- (instancetype)initWithWeakTarget:(nonnull id)target;

@end
NS_ASSUME_NONNULL_END
