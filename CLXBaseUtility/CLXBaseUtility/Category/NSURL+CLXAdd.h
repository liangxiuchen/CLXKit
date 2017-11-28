//
//  NSURL+CLXAdd.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/1.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CLXAdd)

@property (nonatomic, readonly, getter = clx_isImage) BOOL clx_imageResource;

@end
