//
//  CLXHostTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/22.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXNTHost.h"
@interface CLXHostTest : XCTestCase

@end

@implementation CLXHostTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testResolution {
    XCTestExpectation *expection = [self expectationWithDescription:@"host name resolution"];
    CLXNTHost *host = [[CLXNTHost alloc] initWithHostName:@"baidu.com"];
    [host startOnCompletion:^(CLXNTHost * _Nonnull host, NSError * _Nullable error) {
        //
        [expection fulfill];
    }];
    [self waitForExpectations:@[expection] timeout:1000];
}

- (void)testReachability {
    XCTestExpectation *expection = [self expectationWithDescription:@"host name resolution"];
    CLXNTHost *host = [[CLXNTHost alloc] initWithHostName:@"baidu.com"];
    [host reachableOnResult:^(CLXNTHost * _Nonnull host, NSError * _Nullable error) {
        //
        [expection fulfill];
    }];
    [self waitForExpectations:@[expection] timeout:1000];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
