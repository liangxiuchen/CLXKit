//
//  NSDictionary+CLXAdd.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/14.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "NSDictionary+CLXAdd.h"

static Boolean CLXCaseInsensitiveEqualCallback(const void *a, const void *b) {
    id objA = (__bridge id)a, objB = (__bridge id)b;
    Boolean ret = FALSE;
    if ([objA isKindOfClass:NSString.class] && [objB isKindOfClass:NSString.class]) {
        ret = ([objA compare:objB options:NSCaseInsensitiveSearch|NSLiteralSearch] == NSOrderedSame);
    }else {
        ret = [objA isEqual:objB];
    }
    return ret;
}

static CFHashCode CLXCaseInsensitiveHashCallback(const void *value) {
    id idValue = (__bridge id)value;
    CFHashCode ret = 0;
    if ([idValue isKindOfClass:NSString.class]) {
        ret = [[idValue lowercaseString] hash];
    }else {
        ret = [(NSObject *)idValue hash];
    }
    return ret;
}

@implementation NSDictionary (CLXAdd)

- (NSDictionary *)clx_caseInsensitiveDictionary
{
    CFDictionaryKeyCallBacks keyCallbacks = kCFCopyStringDictionaryKeyCallBacks;
    keyCallbacks.equal = CLXCaseInsensitiveEqualCallback;
    keyCallbacks.hash  = CLXCaseInsensitiveHashCallback;

    void *keys = NULL, *values = NULL;
    CFIndex count = CFDictionaryGetCount((CFDictionaryRef)self);
    if (count) {
        keys   = malloc(count * sizeof(void *));
        values = malloc(count * sizeof(void *));
        if (keys != NULL && values != NULL) {
            CFDictionaryGetKeysAndValues((CFDictionaryRef)self, keys, values);
        } else{}
    } else{}
    CFDictionaryRef caseInsensitiveDict = CFDictionaryCreate(kCFAllocatorDefault, keys, values, count, &keyCallbacks, &kCFTypeDictionaryValueCallBacks);
    if (keys != NULL && values != NULL) {
        free(keys);
        free(values);
    }
    return CFBridgingRelease(caseInsensitiveDict);
}

@end
