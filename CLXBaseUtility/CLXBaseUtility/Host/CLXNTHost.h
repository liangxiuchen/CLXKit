//
//  CLXHost.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/21.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class CLXNTHost;
typedef void (^CLXHostCallBack_t) (CLXNTHost *host, NSError *_Nullable error);

typedef NS_OPTIONS(NSUInteger, CLXHostReachabilityFlags)
{
    CLXHostReachabilityFlagsTransientConnection    = 1<<0,
    CLXHostReachabilityFlagsReachable        = 1<<1,
    CLXHostReachabilityFlagsConnectionRequired    = 1<<2,
    CLXHostReachabilityFlagsConnectionOnTraffic    = 1<<3,
    CLXHostReachabilityFlagsInterventionRequired    = 1<<4,
    CLXHostReachabilityFlagsConnectionOnDemand    = 1<<5,
    CLXHostReachabilityFlagsIsLocalAddress    = 1<<16,
    CLXHostReachabilityFlagsIsDirect        = 1<<17,
#if    TARGET_OS_IPHONE
    CLXHostReachabilityFlagsIsWWAN        = 1<<18,
#endif    // TARGET_OS_IPHONE

    CLXHostReachabilityFlagsConnectionAutomatic    = CLXHostReachabilityFlagsConnectionOnTraffic
};

@interface CLXNTHost : NSObject

@property (nonatomic, readonly) NSArray<NSString *> *hostNames;
@property (nonatomic, readonly) NSArray<NSData *> *hostAddresses;
@property (nonatomic, readonly) CLXHostReachabilityFlags flags;

//NSString ip address convert to NSData methods.
+ (NSData *)addressWithName:(NSString *)name;
//reverse
+ (NSString *)nameWithAddress:(NSData *)data;

- (instancetype)initWithHostName:(nonnull NSString *)hostName NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithAddress:(nonnull NSData *)address NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithAddressName:(nonnull NSString *)addressName;//convenience init method
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (void)startOnCompletion:(CLXHostCallBack_t)completionHandler;
- (void)reachableOnResult:(CLXHostCallBack_t)resultHandler;

@end
NS_ASSUME_NONNULL_END
