//
//  CLXTouchDelayGestureRecognizer.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/12/15.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXTouchDelayGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CLXTouchDelayGestureRecognizer
{
    NSTimer *_timer;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.delaysTouchesBegan = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(fail) userInfo:nil repeats:NO];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self fail];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self fail];
}

- (void)fail
{
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset
{
    [_timer invalidate];
    _timer = nil;
}

@end
