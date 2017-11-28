//
//  CLXGCDTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/24.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CLXGCDTest : XCTestCase

@end

@implementation CLXGCDTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGCDApplyAndGroup {
    dispatch_queue_attr_t queue_attr = DISPATCH_QUEUE_CONCURRENT;
    dispatch_queue_t queue = dispatch_queue_create("liangxiu.chen", queue_attr);
    dispatch_group_t group = dispatch_group_create();
    dispatch_apply(1000, queue, ^(size_t index) {
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%ld",index);
            dispatch_group_leave(group);
        });
    });
    XCTKVOExpectation *expection = [self expectationWithDescription:@"group notifiy"];
    dispatch_group_notify(group, queue, ^{
        NSLog(@"finish");
        [expection fulfill];
    });
    [self waitForExpectations:@[expection] timeout:1 * NSEC_PER_SEC];
}

- (void)testGCDSourceOfProcessSig {
    pid_t ppid = getppid();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC,
                                                      ppid, DISPATCH_PROC_EXIT, globalQueue);
    if (source) {
        dispatch_source_set_event_handler(source, ^{
        NSLog(@"pid: %d Exited", ppid);
        dispatch_source_cancel(source);
        });
        dispatch_resume(source);

    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
