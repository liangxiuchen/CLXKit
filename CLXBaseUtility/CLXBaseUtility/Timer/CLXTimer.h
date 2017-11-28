//
//  CLXTimer.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/10.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *@abstract:a thread safe and no memory leak risk timer
 */
#define CLX_FIRE_NOW (0ull);

@class CLXTimer;
typedef void (^CLXTimer_Block_t)(CLXTimer *timer);

typedef NS_ENUM(NSUInteger, CLXTimerUnit)
{
    CLXTimerUnitSec = 0,//秒
    CLXTimerUnitUSec,//毫秒
    CLXTimerUnitMSec,//微秒
    CLXTimerUnitNSec,//纳秒
};

typedef NS_ENUM(NSUInteger, CLXTimerStatus)
{
    CLXTimerStatusRunning = 0,
    CLXTimerStatusStopped,
    CLXTimerStatusPaused,
};

@interface CLXTimer : NSObject

@property (nonatomic, strong) dispatch_queue_t fireQueue;//定时器回调的执行Queue
@property (nonatomic, assign) CLXTimerUnit unit;//时间单位
@property (nonatomic, assign) NSTimeInterval fireAfter;//启动时间,默认是CLX_FIRE_NOW,单位为uint类型决定
@property (nonatomic, assign) NSTimeInterval tolerance;//允许误差值,单位为uint类型决定
@property (nonatomic, assign) NSTimeInterval interval;//间隔， 单位为uint类型决定
@property (nonatomic, assign) BOOL shouldReapt;//是否重复
@property (nonatomic, readonly) CLXTimerStatus status;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)timer;//自定初始化方法

- (void)fireWithAction:(CLXTimer_Block_t)action OnCancel:(CLXTimer_Block_t)onCancel;//计时器开始
- (void)cancel;//取消
- (void)pause;//暂定
- (void)resume;//重新开始

@end
