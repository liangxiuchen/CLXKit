//
//  CLXWeakProxyTests.m
//  CLXDigestTests
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXWeakProxy.h"

@interface CLXHost: NSObject

- (NSString *)hostMethod;

@end

@implementation CLXHost

- (NSString *)hostMethod {
    return @"host";
}

@end

@interface CLXWeakProxyTests : XCTestCase

@end

@implementation CLXWeakProxyTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testproxyMethod {
    CLXHost *host = [CLXHost new];
    CLXWeakProxy *proxy = [CLXWeakProxy weakProxyWithTarget:host];
    CLXHost *hostProxy = (CLXHost *)proxy;
    NSString *result = [hostProxy hostMethod];
    XCTAssert([result isEqualToString:@"host"]);
}


- (void)testNilTarget {
    id obj = nil;
    CLXWeakProxy *proxy = [CLXWeakProxy weakProxyWithTarget:obj];
    XCTAssert(proxy == nil);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
