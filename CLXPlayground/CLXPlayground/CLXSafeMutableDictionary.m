//
//  CLXSafeMutableDicionary.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/24.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXSafeMutableDictionary.h"
#import <pthread/pthread.h>

#define CLXLock_ForRead pthread_rwlock_rdlock(&_locker);
#define CLXLock_ForWrite pthread_rwlock_wrlock(&_locker);
#define CLXUnlock pthread_rwlock_unlock(&_locker);

@implementation CLXSafeMutableDictionary
{
    @private
    pthread_rwlock_t _locker;
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_locker);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        {
            pthread_rwlockattr_t attr;
            pthread_rwlockattr_init(&attr);
            pthread_rwlockattr_setpshared(&attr, PTHREAD_PROCESS_PRIVATE);
            pthread_rwlock_init(&_locker, &attr);
            pthread_rwlockattr_destroy(&attr);
        }
    }
    return self;
}

#pragma mark -all getter methods

- (NSUInteger)count
{
    NSUInteger c;
    CLXLock_ForRead;
    c = [super count];
    CLXUnlock;
    return c;
}

- (id)objectForKey:(id)aKey
{
    id obj;
    CLXLock_ForRead;
    obj = [super objectForKey:aKey];
    CLXUnlock;
    return obj;
}

- (id)objectForKeyedSubscript:(id)key
{
    id obj;
    CLXLock_ForRead;
    obj = [super objectForKeyedSubscript:key];
    CLXUnlock;
    return obj;
}

- (NSArray *)allKeys
{
    NSArray *all;
    CLXLock_ForRead;
    all = [super allKeys];
    CLXUnlock;
    return all;
}

- (NSArray *)allValues
{
    NSArray *all;
    CLXLock_ForRead;
    all = [super allValues];
    CLXUnlock;
    return all;
}

#pragma mark - setter methods
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    CLXLock_ForWrite;
    [super setObject:anObject forKey:aKey];
    CLXUnlock;
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    CLXLock_ForWrite;
    [super setObject:obj forKeyedSubscript:key];
    CLXUnlock;
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary
{
    CLXLock_ForWrite;
    [super addEntriesFromDictionary:otherDictionary];
    CLXUnlock;
}

#pragma mark - remove methods
- (void)removeObjectForKey:(id)aKey
{
    CLXLock_ForWrite;
    [super removeObjectForKey:aKey];
    CLXUnlock;
}

- (void)removeAllObjects
{
    CLXLock_ForWrite;
    [super removeAllObjects];
    CLXUnlock;
}

#pragma mark - enumeration
- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id _Nonnull, id _Nonnull, BOOL * _Nonnull))block
{
    CLXLock_ForRead;
    [super enumerateKeysAndObjectsUsingBlock:block];
    CLXUnlock;
}

- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id _Nonnull, id _Nonnull, BOOL * _Nonnull))block
{
    CLXLock_ForRead;
    [super enumerateKeysAndObjectsWithOptions:opts usingBlock:block];
    CLXUnlock;
}

@end
