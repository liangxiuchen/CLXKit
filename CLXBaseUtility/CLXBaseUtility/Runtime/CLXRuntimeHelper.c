//
//  CLXRuntimeHelper.c
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/10.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#include "CLXRuntimeHelper.h"

BOOL CLXSubclassOverridesSelector(Class aSub, Class aSuper,SEL instance_sel)
{
    if (aSub == aSuper) return NO;
    Method aSub_method = class_getInstanceMethod(aSub, instance_sel);
    Method aSuper_method = class_getInstanceMethod(aSuper, instance_sel);
    IMP aSub_imp = method_getImplementation(aSub_method);
    IMP aSuper_imp = method_getImplementation(aSuper_method);
    return (aSub_imp != aSuper_imp);
}

BOOL CLXSubclassOverridesClassSelector(Class aSub, Class aSuper, SEL class_sel)
{
    if (aSub == aSuper) return NO;
    Method aSub_method = class_getClassMethod(aSub, class_sel);
    Method aSuper_method = class_getClassMethod(aSuper, class_sel);
    IMP aSub_imp = method_getImplementation(aSub_method);
    IMP aSuper_imp = method_getImplementation(aSuper_method);
    return (aSub_imp != aSuper_imp);
}

IMP CLXReplaceMethodWithBlcok(Class aClass, SEL selector, id block)
{
    assert(block != nil);
    Method origin_method = class_getInstanceMethod(aClass, selector);
    IMP replace_imp = imp_implementationWithBlock(block);
    // Try adding the method if not yet in the current class
    BOOL added = class_addMethod(aClass, selector, replace_imp, method_getTypeEncoding(origin_method));
    if (added) {
        return method_getImplementation(origin_method);
    } else {
        return method_setImplementation(origin_method, replace_imp);
    }
}
