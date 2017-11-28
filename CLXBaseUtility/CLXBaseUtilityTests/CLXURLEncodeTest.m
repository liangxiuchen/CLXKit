//
//  CLXURLEncodeTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/2.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXURLEncodeMaker.h"
@import JavaScriptCore;
@interface CLXURLEncodeTest : XCTestCase

@end

@implementation CLXURLEncodeTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

}

- (void)testJSCore {
    JSContext *context = [JSContext new];
    NSString *script = @"var value = encodeURI('http://www.baidu.com/ liang /x iu;;a = 3&b = 4')";
    [context evaluateScript:script];
    JSValue *value = [context objectForKeyedSubscript:@"value"];
    __unused NSString *result = value.toString;
    NSLog(@"");
}

- (void)testEncodeUsage {
    NSURL *url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"/liang/xiu",@"a=1").toAppend();
        encoder.encodeQuery(@"a = 2 & c = 3").toAppend();
        encoder.encodeFragment(@"dsaf").toAppend();
    }];
    XCTAssertNotNil(url);
    url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"/liang/xiu",@"a=1").toAppend();
        encoder.pure(@"a = 2 & c = 3").toAppend();
        encoder.encodeFragment(@"dsaf").toAppend();
    }];
    XCTAssertNil(url,@"query component contain whiteSpace which need percent excaped");
}

- (void)testEncodePath {
    NSURL *url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"/liang/xiu",@"a=1").toAppend();
    }];
    XCTAssertNotNil(url);
    NSString *str = [url absoluteString];
    XCTAssertTrue([str isEqualToString:@"http://www.baidu.com/liang/xiu;a=1"]);
}

- (void)testEcodeExceptionPath {
    NSURL *url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"/",@"a=1").toAppend();
    }];
    XCTAssertNotNil(url);
    XCTAssertTrue([[url absoluteString] isEqualToString:@"http://www.baidu.com/;a=1"]);

    url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"//",@"a=1").toAppend();
    }];
    XCTAssertNotNil(url);

    url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"/ / ",@"a=1").toAppend();
    }];
    XCTAssertNotNil(url);

    url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"",@"a=1").toAppend();
    }];
    XCTAssertNotNil(url);
    XCTAssertTrue([[url absoluteString] isEqualToString:@"http://www.baidu.com"]);

    url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"//liang//chen",@"a=1").toAppend();
    }];
    XCTAssertNotNil(url);
    url = [CLXURLEncodeMaker makePecentEncode:^(CLXURLEncoder *encoder) {
        encoder.pure(@"http://www.baidu.com").toAppend();
        encoder.encodePath(@"//liang&%-;,//chen",@"a=1").toAppend();
    }];
    XCTAssertNotNil(url);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
