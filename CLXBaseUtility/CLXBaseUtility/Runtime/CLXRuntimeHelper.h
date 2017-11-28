//
//  CLXRuntimeHelper.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/10.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#ifndef CLXRuntimeHelper_h
#define CLXRuntimeHelper_h

#include <stdio.h>
#include <assert.h>
#include <objc/runtime.h>

BOOL CLXSubclassOverridesSelector(Class aSub, Class aSuper,SEL instance_sel);

BOOL CLXSubclassOverridesClassSelector(Class aSub, Class aSuper, SEL class_sel);

IMP CLXReplaceMethodWithBlcok(Class aClass, SEL selector, id block);

#endif /* CLXRuntimeHelper_h */
