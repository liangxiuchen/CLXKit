//
//  CLXHashTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/5.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXDigest.h"
@interface CLXHashTest : XCTestCase

@end

@implementation CLXHashTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBlockHash {
    NSString *toHash = @"ldsafjlkdsajflasdjflasdjflasdjfkasdljfladsjflasdjfklasdjflkasjdf";
    CLXDigest __unused*hash = [CLXDigest digestForBlockData:[toHash cStringUsingEncoding:NSUTF8StringEncoding] Length:[toHash lengthOfBytesUsingEncoding:NSUTF8StringEncoding] Type:CLXDigestSHA1];
    XCTAssertNotNil(hash);
}

- (void)testFileHash {
    NSURL *filePath = [[NSBundle bundleForClass:self.class] URLForResource:@"iphone" withExtension:@"mp3"];
    NSURL *test = [NSURL fileURLWithPath:filePath.path];
    
    CLXDigest __unused*hash = [CLXDigest digestForFile:filePath Type:CLXDigestMD5];
    XCTAssertNotNil(hash);
    XCTAssertTrue([hash.md5_base64 isEqualToString:@"aUipoAgGJBWPStFPsDFwUQ=="]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
