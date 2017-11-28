//
//  CLXDigestTests.m
//  CLXDigestTests
//
//  Created by chen liangxiu on 2017/10/21.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface CLXDigestTests : XCTestCase

@property (nonatomic, assign) CCCryptorRef cryptor;

@end

@implementation CLXDigestTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSString *key = @"0123456789abcdef";
    NSString *mData = @"adfjdlksafjalds";
    void *outData = malloc(16);
    size_t dataOutMoved;

    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, (void *)[key cStringUsingEncoding:NSUTF8StringEncoding], kCCKeySizeAES128, (void *)[key cStringUsingEncoding:NSUTF8StringEncoding], (void *)[mData cStringUsingEncoding:NSUTF8StringEncoding], [mData lengthOfBytesUsingEncoding:NSUTF8StringEncoding], outData, 16, &dataOutMoved);
    XCTAssert(status == kCCSuccess);
    NSData *encryptData = [NSData dataWithBytes:outData length:16];
    NSString *encryptStr = [encryptData base64EncodedStringWithOptions:0];

}

- (void)testRandomData {
    NSData *random = [CLXRandom randomDataWithLength:16];
    XCTAssert(random != nil);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
