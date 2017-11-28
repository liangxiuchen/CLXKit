//
//  CLXEncryptorTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/14.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXEncryptor.h"
@interface CLXEncryptorTest : XCTestCase

@end

@implementation CLXEncryptorTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    char *plainText = "1234567890fdsafjkadslfjalsdjflasdjfklasdjfklasdjflasdjf;gcnx,nvjffgendlkf2p3kdsdaklfdaskfhleersda,fnadsifoqndfnakdjfhiaodfnaklsd";
    NSData *plain = [NSData dataWithBytes:plainText length:strlen(plainText)];
    NSData *key = nil;
    NSData *cipher = [CLXEncryptor ase128EncryptWithData:plain Key:&key padding:CLXEncryptorPKCS7Padding];
    NSData *deCipher = [CLXEncryptor ase128DecryptWith:cipher Key:key padding:CLXEncryptorPKCS7Padding];
    XCTAssertTrue([deCipher isEqualToData:plain]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
