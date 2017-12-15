//
//  CLXTouchDelayGestureRecognizer.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/12/15.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 这个手势啥也不干，会在0.15秒后识别失败。其作用就是延迟View 接收touch event*/
@interface CLXTouchDelayGestureRecognizer : UIGestureRecognizer

@end
