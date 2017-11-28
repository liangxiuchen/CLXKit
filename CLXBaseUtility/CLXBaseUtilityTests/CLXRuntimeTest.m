//
//  CLXRuntimeTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/25.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
@interface SwizzleCase : UIViewController
@end

@implementation SwizzleCase

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL origin  = @selector(viewWillAppear:);
        SEL swizzled = @selector(clx_viewWillAppear:);
        Method origin_method = class_getInstanceMethod(self, origin);
        Method swizzled_method = class_getInstanceMethod(self, swizzled);
        const char *originType = method_getTypeEncoding(origin_method);
        const char *swizzledType = method_getTypeEncoding(swizzled_method);
        BOOL addDone = class_addMethod(self, origin, method_getImplementation(swizzled_method), originType);
        if (addDone) {
            class_replaceMethod(self, swizzled, method_getImplementation(origin_method), method_getTypeEncoding(origin_method));
        } else {
            method_exchangeImplementations(origin_method, swizzled_method);
        }
    });
}

- (void)clx_viewWillAppear:(BOOL)animation
{
    //
}

@end

@interface CLXRuntimeTest : XCTestCase

@end

@implementation CLXRuntimeTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSwizzle {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    const char *initTypes = [[NSString stringWithFormat:@"%s%s%s%s%s%s", @encode(id), @encode(id), @encode(SEL), @encode(id), @encode(id), @encode(NSUInteger)] UTF8String];
    const char *type = @encode(void);

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
