//
//  NSObject+CLXKVO.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/28.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "NSObject+CLXKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>

static Class clc_class_getter(id self, SEL sel) {
    return class_getSuperclass(object_getClass(self));
}

@implementation NSObject (CLXKVO)

static void clc_setter(id self, SEL sel, id param)
{
    printf("will setter");
    struct objc_super sp = {self,class_getSuperclass(object_getClass(self))};
    ((void (*)(void *, SEL, id))objc_msgSendSuper)(&sp, sel, param);
    printf("did setter");

}

- (void)clx_addObserverBy:(NSString *)keyPath
{
    const char *className = [[NSString stringWithFormat:@"CLXKVO_%@",NSStringFromClass(self.class)] cStringUsingEncoding:NSUTF8StringEncoding];
    Class kvo_class = objc_allocateClassPair(self.class, className, 0);
    Method super_method = class_getInstanceMethod(kvo_class, @selector(class));
    const char *typeEncoding = method_getTypeEncoding(super_method);
    class_addMethod(kvo_class, @selector(class), (void (*)(void))clc_class_getter, typeEncoding);

    Method name_method = class_getInstanceMethod(kvo_class, @selector(setName:));
    class_addMethod(kvo_class, @selector(setName:), (void (*)(void))clc_setter, method_getTypeEncoding(name_method));

    objc_registerClassPair(kvo_class);
    object_setClass(self, kvo_class);
}

@end
