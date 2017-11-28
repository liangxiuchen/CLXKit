//
//  CLXTreeTest.m
//  CLXBaseUtilityTests
//
//  Created by chen liangxiu on 2017/11/27.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLXTree.h"
@interface CLXTreeTest : XCTestCase

@property (strong, nonatomic) CLXTree *root;

@end

@implementation CLXTreeTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.root = [[CLXTree alloc] initRootTreeWith:@(0)];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
//测试添加节点
- (void)testAddChild {
    CLXTree *child = [[CLXTree alloc] initTreeWith:@(1)];
    [self.root addChild:child];
    CLXTree *fisrtChild = self.root.firstChild;
    assert([fisrtChild isEqual:child]);

    CLXTree *child1 = [[CLXTree alloc] initTreeWith:@(2)];
    BOOL status = [self.root insertChild:child1 at:10];
    assert(status == NO);
    status = [self.root insertChild:child1 at:self.root.countOfChildren];
    assert(status == YES);
    assert([self.root childAt:self.root.countOfChildren - 1] == child1);
    
}
//测试获取子节点
- (void)testGetChild {
    [self testAddChild];
    assert(self.root.countOfChildren);
    CLXTree *firstChild = self.root.firstChild;
    assert(firstChild);
    CLXTree *secondChild = [self.root childAt:1];
    assert(secondChild);
    CLXTree *lastChild = [self.root lastChild];
    assert(lastChild);
}
//测试根据节点路径获取子孙节点
- (void)testDescendantByTreePath {
    [self testAddChild];
    assert(self.root.countOfChildren);
    NSUInteger indices[2] = {0};
    NSIndexPath *descendantPath = [NSIndexPath indexPathWithIndexes:indices length:1];
    CLXTree *descendant = [self.root descendantWithIndexPath:descendantPath];
    assert(descendant == self.root.firstChild);
    assert([self.root.firstChild.path isEqual:descendantPath]);
}
//测试删除节点
- (void)testRemoveChild {
    [self testAddChild];
    assert(self.root.countOfChildren);
    assert(self.root.removeSelf == NO);
    CLXTree *removed = [self.root removeChildAt:10];
    assert(removed == nil);
    removed = [self.root removeChildAt:0];
    assert(removed != nil);
    [self.root removeAllChildren];
    assert(self.root.countOfChildren == 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
