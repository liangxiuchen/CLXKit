//
//  CLXWeakProxy.m
//  CLXDigest
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXWeakProxy.h"
#import <objc/runtime.h>
@implementation CLXWeakProxy

- (instancetype)initWithWeakTarget:(id)target
{
    if (target == nil) {
        return nil;
    }
    _target = target;
    return self;
}

+ (instancetype)weakProxyWithTarget:(id)target
{
    return [[CLXWeakProxy alloc] initWithWeakTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    if (_target == nil) {
        return [NSMethodSignature methodSignatureForSelector:sel];
    }
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:_target];
}

#pragma NSObject protocol methods

- (Class)class
{
    return [_target class];
}

- (BOOL)isProxy
{
    return YES;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return [_target isKindOfClass:aClass
            ];
}

- (BOOL)isMemberOfClass:(Class)aClass
{
    return [_target isMemberOfClass:aClass];
}

- (NSUInteger)hash
{
    return [_target hash];
}

- (BOOL)isEqual:(id)object
{
    return [_target isEqual:object];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [_target respondsToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return [_target conformsToProtocol:aProtocol];
}

@end
