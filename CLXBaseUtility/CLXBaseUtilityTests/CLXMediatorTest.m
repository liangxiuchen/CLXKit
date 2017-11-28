//
//  CLXMediatorTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/23.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXMediator.h"
//测试对象
typedef struct {
    NSInteger typ;
}AStruct;
@interface CLXMediatorTestCase : NSObject

- (NSString *)getStr:(NSString *)s;
- (NSInteger)getInt;

@end

@implementation CLXMediatorTestCase

- (NSString *)getStr:(NSString *)s
{
    return s;
}

- (NSInteger)getInt
{
    return 1;
}

@end

@interface CLXMediatorTest : XCTestCase

@end

@implementation CLXMediatorTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    CLXMediatorCaller *caller = [CLXMediator makeCallerWithTarget:@"CLXMediatorTestCase" selector:@selector(getStr:)];

    NSString *str = (__bridge_transfer NSString *)[caller.parameter(@"123") call].pointerValue;
}

- (void)testPerform {
    id target = [CLXMediatorTestCase new];
//    [target performSelector:@selector(getStr:) withObject:@"liangxiu.chen"];
//    [target performSelector:@selector(getStr:)];
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
