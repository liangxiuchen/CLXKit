//
//  CLXMediator.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXMediator.h"
#import <objc/runtime.h>

typedef NS_ENUM(char,CLXMediatorObjcType)
{
    CLXMediatorObjcNoType = 0,
    CLXMediatorObjcVoidType = 'v',
    CLXMediatorObjcCharType = 'c',
    CLXMediatorObjcShortType = 's',
    CLXMediatorObjcLongType = 'l',
    CLXMediatorObjcLonglongType = 'q',
    CLXMediatorObjcFloatType = 'f',
    CLXMediatorObjcDoubleType = 'd',
    CLXMediatorObjcBoolType = 'B',
    CLXMediatorObjcSelectorType = ':',
    CLXMediatorObjcObjectType = '@',
    CLXMediatorObjcStructType = '{',
    CLXMediatorObjcPointerType = '^',
    CLXMediatorObjcStringType = '*',
    CLXMediatorObjcArrayType = '[',
    CLXMediatorObjcUnionType = '(',
    CLXMediatorObjcBitfield = 'b'
};

@interface CLXMediatorCaller()

@property (nonatomic, strong) NSInvocation *invocation;
@property (nonatomic, assign) NSUInteger paramIndex;

@end

@implementation CLXMediatorCaller

- (instancetype)init
{
    self = [super init];
    if (self) {
        _paramIndex = 2;
    }
    return self;
}

- (ParametersFill_t)parameter
{
    return ^CLXMediatorCaller *(void *param) {
        [self.invocation setArgument:param atIndex:self.paramIndex];
        self.paramIndex += 1;
        return self;
    };
}

- (NSValue *)call
{
    [self.invocation invoke];
    void *returnValue = malloc([self.invocation.methodSignature methodReturnLength]);
    [self.invocation getReturnValue:returnValue];
    return [NSValue value:returnValue withObjCType:self.invocation.methodSignature.methodReturnType];
}

@end

@implementation CLXMediator

+ (CLXMediatorCaller *)makeCallerWithTarget:(NSString *)targetName selector:(SEL)sel
{
    Class targetClass = NSClassFromString(targetName);
    assert(targetClass);
    id target = [targetClass new];
    assert([target respondsToSelector:sel]);

    return [self callerWithTarget:target selector:sel];
}

+ (CLXMediatorCaller *)callerWithTarget:(id)target selector:(SEL)sel
{
    Method instanceMethod = class_getInstanceMethod([target class], sel);
    const char *method_objcType = method_getTypeEncoding(instanceMethod);
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:method_objcType];

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    CLXMediatorCaller *caller = [CLXMediatorCaller new];
    invocation.target = target;
    invocation.selector = sel;
    caller.invocation = invocation;
    return caller;
}

@end
