//
//  CLXTimer.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/10.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXTimer.h"
#import <mach/mach.h>
#import <pthread/pthread.h>

@interface CLXTimer ()

@property (nonatomic, weak) dispatch_source_t timer;
@property (nonatomic, assign) CLXTimerStatus status;

@end

@implementation CLXTimer
{
    pthread_mutex_t _mutext;
}

+ (instancetype)timer
{
    return [[CLXTimer alloc] _init];
}

- (instancetype)_init
{
    self = [super init];
    if (self) {
        //默认设置
        {
            _fireQueue = dispatch_get_main_queue();
            _fireAfter = 0;
            _interval = 0;
            _tolerance = 0;
            _shouldReapt = NO;
            _status = CLXTimerStatusStopped;
            _unit = CLXTimerUnitSec;
        }
        //互斥锁初始化
        {
            pthread_mutexattr_t mutexattr;
            pthread_mutexattr_init(&mutexattr);
            pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
            pthread_mutex_init(&_mutext, &mutexattr);
            pthread_mutexattr_destroy(&mutexattr);
        }
    }
    return self;
}

- (void)fireWithAction:(CLXTimer_Block_t)action OnCancel:(CLXTimer_Block_t)onCancel
{
    pthread_mutex_lock(&_mutext);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _fireQueue);
    dispatch_time_t unit = NSEC_PER_SEC;
    switch (_unit) {
        case CLXTimerUnitSec:
            unit = NSEC_PER_SEC;
            break;
        case CLXTimerUnitUSec:
            unit = NSEC_PER_USEC;
            break;
        case CLXTimerUnitMSec:
            unit = NSEC_PER_MSEC;
            break;
        case CLXTimerUnitNSec:
            unit = 1;
        default:
            unit = NSEC_PER_SEC;
            break;
    }
    dispatch_source_set_timer(timer, dispatch_time(mach_absolute_time(),_fireAfter * unit), _interval * unit, _tolerance * unit);
    dispatch_source_set_event_handler(timer, ^{
        if (action) action(self);//source block->action block and self(CLXTimer),break reference circle
        if (!_shouldReapt) [self cancel];//不需要重复执行,移除timer source
    });
    dispatch_source_set_cancel_handler(timer, ^{
        if (onCancel) onCancel(self);//source block->cancel block and self(CLXTimer)
    });
    dispatch_resume(timer);
    self.status = CLXTimerStatusRunning;
    self.timer = timer;
    pthread_mutex_unlock(&_mutext);
}

- (void)cancel
{
    pthread_mutex_lock(&_mutext);
    if (self.timer != nil) {
        dispatch_source_cancel(self.timer);
        self.status = CLXTimerStatusStopped;
    } else {}
    pthread_mutex_unlock(&_mutext);
}

- (void)pause
{
    if (self.shouldReapt == NO) return;
    pthread_mutex_lock(&_mutext);
    if (self.timer != nil) {
        dispatch_suspend(self.timer);
        self.status = CLXTimerStatusPaused;
    } else {}
    pthread_mutex_unlock(&_mutext);
}

- (void)resume
{
    if (self.shouldReapt == NO) return;
    pthread_mutex_lock(&_mutext);
    if (self.timer != nil) {
        dispatch_resume(self.timer);
        self.status = CLXTimerStatusRunning;
    } else {}
    pthread_mutex_unlock(&_mutext);
}

@end
