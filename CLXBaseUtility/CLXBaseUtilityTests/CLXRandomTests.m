//
//  CLXRandomTests.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/10/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXRandom.h"

@interface CLXRandomTests : XCTestCase

@end

@implementation CLXRandomTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRandomData {
    NSData *random = [CLXRandom secRandomDataWithLength:16];
    XCTAssert(random != nil);
}

- (void)testPerformanceArc4 {
    // This is an example of a performance test case.
    [self measureBlock:^{
        __unused uint32_t result = arc4random();
    }];
}

@end
