//
//  CLXKVOTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/28.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+CLXKVO.h"
@interface CLXKVOCase1 : NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation CLXKVOCase1

@end

@interface CLXKVOTest : XCTestCase

@end

@implementation CLXKVOTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    CLXKVOCase1 *case1 = [CLXKVOCase1 new];
    [case1 clx_addObserverBy:@"name"];
    case1.name = @"123";
    NSString *s = NSStringFromClass(case1.class);
    NSLog(@"");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
