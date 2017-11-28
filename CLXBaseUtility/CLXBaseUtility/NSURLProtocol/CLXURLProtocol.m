//
//  CLXURLProtocol.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/22.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXURLProtocol.h"

NSString * const kCLXInterceptorConfigPathKey = @"CLXURLProtocolInterceptorConfigPathKey";

@interface CLXURLProtocol()

@property (nonatomic, copy) NSURLSessionTask *task;

@end

@implementation CLXURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    id shoudIntercept = request.allHTTPHeaderFields[kCLXInterceptorConfigPathKey];
    NSURLRequest *cp_req = request.copy;
    NSMutableURLRequest *m_req = request.mutableCopy;
    return shoudIntercept != nil;
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task
{
    return [self canInitWithRequest:task.originalRequest];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    //TODO:setter http header or body
    NSMutableDictionary *allheader = request.allHTTPHeaderFields.mutableCopy;
    NSMutableURLRequest *m_request = request.mutableCopy;
    [m_request setValue:nil forHTTPHeaderField:kCLXInterceptorConfigPathKey];
    return m_request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

- (instancetype)initWithTask:(NSURLSessionTask *)task cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    self = [super initWithTask:task cachedResponse:cachedResponse client:client];
    if (self) {
        _task = task;
    }
    return self;
}

- (void)startLoading
{
    //redirect
    NSHTTPURLResponse *redirect = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:302 HTTPVersion:@"1.0" headerFields:nil];
    [self.client URLProtocol:self wasRedirectedToRequest:self.request redirectResponse:redirect];
}



@end
