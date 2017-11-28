//
//  CLXSafeMutableDictionaryTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/28.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXSafeMutableDictionary.h"
@interface CLXSafeMutableDictionaryTest : XCTestCase

@end

@implementation CLXSafeMutableDictionaryTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    CLXSafeMutableDictionary *dic = @{@"1":@(1),@"3":@(2)}.mutableCopy;
    NSArray *allkeys = dic.keyEnumerator.allObjects;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
