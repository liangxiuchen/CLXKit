//
//  CompressionTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/4.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BlockCompression.h"
@interface CompressionTest : XCTestCase

@end

@implementation CompressionTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEncode {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle bundlePath];
    NSString *src;
    src = [path stringByAppendingPathComponent:@"src"];
    src = [src stringByAppendingPathExtension:@"data"];

    NSString *dst;
    dst = [path stringByAppendingPathComponent:@"dst"];
    dst = [dst stringByAppendingPathExtension:@"zip"];

    FILE *src_file = fopen([src cStringUsingEncoding:NSUTF8StringEncoding], "wb+");
    fseek(src_file, 0, SEEK_SET);
    char *name = "adsfasdlfasddfasndklfjasdl";
    size_t len = strlen(name);
    size_t writend = fwrite(name, 1, strlen(name), src_file);
    FILE *dst_file = fopen([dst cStringUsingEncoding:NSUTF8StringEncoding], "wb+");
    doBlockCompression(src_file, dst_file, COMPRESSION_ZLIB);
    fclose(src_file);
    fclose(dst_file);
}

- (void)testDeCode {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle bundlePath];
    NSString *src;
    src = [path stringByAppendingPathComponent:@"decode"];
    src = [src stringByAppendingPathExtension:@"data"];

    NSString *dst;
    dst = [path stringByAppendingPathComponent:@"dst"];
    dst = [dst stringByAppendingPathExtension:@"zip"];

    FILE *src_file = fopen([src cStringUsingEncoding:NSUTF8StringEncoding], "wb+");
    FILE *dst_file = fopen([dst cStringUsingEncoding:NSUTF8StringEncoding], "r");
    doBlockDecompression(dst_file, src_file, COMPRESSION_ZLIB);
    fclose(src_file);
    fclose(dst_file);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
