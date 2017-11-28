//
//  CLXHost.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/21.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXNTHost.h"
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
@import CFNetwork;

typedef NS_ENUM(NSUInteger, CLXHostInfoType) {
    CLXHostName = 0,
    CLXHostAddress,
    CLXHostReachability,
};
static void CLXHostClientCallBack(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError * __nullable error, void * __nullable info);

@interface CLXNTHost()

@property (nonatomic, strong, nullable) CFHostRef host __attribute__ (( NSObject ));
@property (nonatomic, assign) CLXHostInfoType type;
@property (nonatomic, strong) NSArray<NSString *> *hostNames;
@property (nonatomic, strong) NSArray<NSData *> *hostAddresses;
@property (nonatomic, copy) CLXHostCallBack_t callBack;

@end

@implementation CLXNTHost
@synthesize hostNames = __hostNames, hostAddresses = __hostAddresses;

+ (NSData *)addressWithName:(NSString *)name
{
    struct addrinfo hints = {
        .ai_flags = AI_NUMERICHOST | AI_NUMERICHOST
    };
    struct addrinfo *addrList;
    int success = getaddrinfo(name.UTF8String, NULL, &hints, &addrList);
    if (success != 0) {
        return nil;
    } else {
        const struct addrinfo * cursor = addrList;
        NSData * result = [NSData dataWithBytes:cursor->ai_addr length:cursor->ai_addrlen];
        freeaddrinfo(addrList);
        return result;
    }
}

+ (NSString *)nameWithAddress:(NSData *)data
{
    char name[INT_MAX];
    int success = getnameinfo(data.bytes, (socklen_t)data.length, name, sizeof(name),  NULL, 0, NI_NUMERICHOST | NI_NUMERICSERV);
    if (success == 0) {
        return @(name);
    } else {
        return @"?";
    }
}

- (instancetype)initWithHostName:(NSString *)hostName
{
    self = [super init];
    if (self) {
        _type = CLXHostName;
        __hostNames = @[hostName];
        _host = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostName);
    }
    return self;
}

- (instancetype)initWithAddress:(NSData *)address
{
    self = [super init];
    if (self) {
        _type = CLXHostAddress;
        __hostAddresses = @[address];
        _host = CFHostCreateWithAddress(kCFAllocatorDefault, (__bridge CFDataRef)address);
    }
    return self;
}

- (instancetype)initWithAddressName:(NSString *)addressName
{
    return [self initWithAddress:[CLXNTHost addressWithName:addressName]];
}

- (void)startOnCompletion:(CLXHostCallBack_t)completionHandler
{
    self.callBack = completionHandler;
    [self doInfoResolutionWith:(CFHostInfoType)self.type];
}

- (void)reachableOnResult:(CLXHostCallBack_t)resultHandler
{
    self.callBack = resultHandler;
    self.type = CLXHostReachability;
    [self doInfoResolutionWith:kCFHostReachability];
}

- (void)doInfoResolutionWith:(CFHostInfoType)type
{
    CFHostClientContext context = {
        .info = (__bridge void *)self,
        .retain = CFRetain,
        .release = CFRelease
    };
    Boolean success = CFHostSetClient(self.host, CLXHostClientCallBack, &context);
    assert(success);
    CFHostScheduleWithRunLoop(self.host, [NSRunLoop currentRunLoop].getCFRunLoop, kCFRunLoopDefaultMode);
    success = CFHostStartInfoResolution(self.host, type, NULL);
    if (!success) {
        [self clear];
    }
}

- (void)clear
{
    CFHostUnscheduleFromRunLoop(self.host, [NSRunLoop currentRunLoop].getCFRunLoop, kCFRunLoopDefaultMode);
    CFHostCancelInfoResolution(self.host, (CFHostInfoType)self.type);
    CFHostSetClient(self.host, NULL, NULL);
}

static void CLXHostClientCallBack(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError * __nullable streamError, void * __nullable info)
{
    #pragma unused(theHost)
    CLXNTHost *host = (__bridge CLXNTHost *)info;
    assert([host isKindOfClass:CLXNTHost.class]);
    if (NULL == streamError || 0 == streamError->domain || 0 == streamError->error) {
        switch (typeInfo) {
            case kCFHostNames:
                host->__hostNames = (__bridge_transfer NSArray *)CFHostGetNames(theHost, NULL);
                host->_callBack(host,nil);
                break;
            case kCFHostAddresses:
                host->__hostAddresses = (__bridge_transfer NSArray *)CFHostGetAddressing(theHost, NULL);
                host->_callBack(host,nil);
                break;
            case kCFHostReachability:
                host->_flags = (CLXHostReachabilityFlags)CFHostGetReachability(theHost, NULL);
                host->_callBack(host,nil);
                break;
            default:
                host->_callBack(host,nil);
                break;
        }
    } else {
        NSError *error = nil;
        if (streamError->domain == kCFStreamErrorDomainPOSIX) {
            error = [NSError errorWithDomain:NSPOSIXErrorDomain code:streamError->error userInfo:nil];
        } else if (streamError->domain == kCFStreamErrorDomainMacOSStatus) {
            error = [NSError errorWithDomain:NSOSStatusErrorDomain code:streamError->error userInfo:nil];
        } else if (streamError->domain == kCFStreamErrorDomainNetServices) {
            error = [NSError errorWithDomain:(__bridge NSString *) kCFErrorDomainCFNetwork code:streamError->error userInfo:nil];
        } else if (streamError->domain == kCFStreamErrorDomainNetDB) {
            error = [NSError errorWithDomain:(__bridge NSString *) kCFErrorDomainCFNetwork code:kCFHostErrorUnknown userInfo:@{
                                                                                                                               (__bridge NSString *) kCFGetAddrInfoFailureKey: @(streamError->error)
                                                                                                                               }];
        } else {
            // If it's something we don't understand, we just assume it comes from
            // CFNetwork.
            error = [NSError errorWithDomain:(__bridge NSString *) kCFErrorDomainCFNetwork code:streamError->error userInfo:nil];
        }
        host->_callBack(host,error);
    }
    //清理工作
    [host clear];
}

@end
