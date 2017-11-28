//
//  CLXMediator.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLXMediatorCaller;
typedef CLXMediatorCaller * (^ParametersFill_t)(void *param);
@interface CLXMediatorCaller : NSObject

- (ParametersFill_t)parameter;
- (NSValue *)call;

@end

@interface CLXMediator : NSObject

+ (CLXMediatorCaller *)makeCallerWithTarget:(NSString *)targetName selector:(SEL)sel;

@end
