//
//  NSObject+CLXKVO.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/28.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#warning 注意：这个不是工具类，只是个人学习手动KVO的探索实践
@interface NSObject (CLXKVO)

- (void)clx_addObserverBy:(NSString *)keyPath;

@end
