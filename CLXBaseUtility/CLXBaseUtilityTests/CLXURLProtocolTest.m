//
//  CLXURLProtocolTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/22.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AFNetworking.h>
#import "CLXURLProtocol.h"
@interface CLXURLProtocolTest : XCTestCase

@end

@implementation CLXURLProtocolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [NSURLProtocol registerClass:CLXURLProtocol.class];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTestExpectation *expectation = [self expectationWithDescription:@"CLXURLProtocol test"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.protocolClasses = @[[CLXURLProtocol class]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:config];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:kCLXInterceptorConfigPathKey];
    [manager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [expectation fulfill];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:100];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
