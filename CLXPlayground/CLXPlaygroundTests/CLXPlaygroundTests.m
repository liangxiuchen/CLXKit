//
//  CLXPlaygroundTests.m
//  CLXPlaygroundTests
//
//  Created by chen liangxiu on 2017/11/28.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#include <stdatomic.h>
@interface CLXPlaygroundTests : XCTestCase

@property (nonatomic, assign)  NSInteger i;

@end

@implementation CLXPlaygroundTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    unsigned int count = 0;
    objc_property_t *p = class_copyPropertyList(self.class, &count);
    const char *attr = property_getAttributes(p[0]);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
