//
//  CLXTree.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/25.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXTree.h"
#import <CoreFoundation/CFTree.h>

@interface CLXTree ()

@property (nonatomic, strong) CFTreeRef cf_node __attribute__ (( NSObject ));
@property (nonatomic, weak) CFTreeRef cf_weakNode __attribute__ (( NSObject ));
@property (nonatomic, strong) id data;
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, strong) NSIndexPath *path;

@end

@implementation CLXTree
#ifdef DEBUG
- (void)dealloc
{
    NSLog(@"CLXTree dealloc");
}
#endif

- (instancetype)initRootTreeWith:(id)data
{
    self = [super init];
    if (self == nil) return self;
    [self commonInitTreeWith:data isRoot:YES];
    return self;
}

- (instancetype)initTreeWith:(id)data
{
    self = [super init];
    if (self == nil) return self;
    [self commonInitTreeWith:data isRoot:NO];
    return self;
}

- (void)commonInitTreeWith:(id)data isRoot:(BOOL)rootOne
{
    CFTreeContext rootContext = {
        .info = (__bridge void *)data,
        .retain = CFRetain,
        .release = CFRelease,
        .copyDescription = CFCopyDescription
    };
    _cf_node = CFTreeCreate(kCFAllocatorDefault, &rootContext);
    _isRoot = rootOne;
    _path = nil;
    _data = data;
}

#pragma  mark -
- (NSInteger)countOfChildren
{
    return CFTreeGetChildCount([self __cfNode]);
}

- (CLXTree *)parent
{
    if (_isRoot) return nil;
    CFTreeRef cf_parent = CFTreeGetParent([self __cfNode]);
    assert(cf_parent);
    CFTreeContext context;
    CFTreeGetContext(cf_parent, &context);
    id obj = (__bridge id)context.info;
    if ([obj isKindOfClass:CLXTree.class]) {
        return obj;
    } else {
        return nil;
    }
}

- (CLXTree *)rootNode
{
    if (_isRoot) {
        return self;
    } else {
        CFTreeRef cf_root = CFTreeFindRoot(_cf_weakNode);
        assert(cf_root);
        CFTreeContext context;
        CFTreeGetContext(cf_root, &context);
        id obj = (__bridge id)context.info;
        if ([obj isKindOfClass:CLXTree.class]) {
            return obj;
        } else {
            return nil;
        }
    }
}

#pragma mark - get child
- (CLXTree *)firstChild
{
    return [self childAt:0];
}

- (CLXTree *)lastChild
{
    return [self childAt:[self countOfChildren] - 1];
}

- (CLXTree *)childAt:(NSUInteger)index
{
    NSUInteger count = [self countOfChildren];
    if (index >= count) {
        return nil;
    } else {
        CFTreeRef child = CFTreeGetChildAtIndex([self __cfNode], index);
        CFTreeContext context;
        CFTreeGetContext(child, &context);
        return (__bridge CLXTree *)context.info;
    }
}

- (CLXTree *)descendantWithIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath || indexPath.length == 0) return nil;
    CLXTree *searched = self.rootNode;
    for (NSInteger i = 0; i < indexPath.length; i++) {
        NSUInteger idx = [indexPath indexAtPosition:i];
        searched = [searched childAt:idx];
        if (searched == nil) {
            return nil;
        } else {}
    }
    return searched;
}

#pragma mark - add child
- (void)addChild:(CLXTree *)node
{
    [self insertChild:node at:[self countOfChildren]];
}

- (BOOL)insertChild:(CLXTree *)node at:(NSUInteger)index
{
    if (node.isRoot) NO;
    NSInteger count = [self countOfChildren];
    /*!更换context info，同时把cf_node 转为cf_weakNode，为了处理循环引用。weak:-->;strong: ->
     * case1:rootTree
     *      rootNode->cf_node->data,外部对象会负责持有rootNote
     * case2:非rootTree
     *      初始化阶段:node->cf_node,cf_node.context.info->data
     *      加入Tree中:cf_node.context->node-->cf_weakNode,同时node->data
     */
    void (^polishPath)(void) = ^{
        if (node->_path) {
            node->_path = [node->_path indexPathByAddingIndex:index];
        } else {
            NSIndexPath *emptyPath = [NSIndexPath new];
            node->_path = [emptyPath indexPathByAddingIndex:index ? index - 1: index];
        }
    };
    if (index == count && index == 0) {
        CFTreeAppendChild(_cf_node, node.cf_node);
        polishPath();
    } else if (index <= count) {
        CFTreeInsertSibling([self childAt:index - 1].cf_weakNode, node.cf_node);
        polishPath();
    } else {
        return NO;
    }
    node.cf_weakNode = node.cf_node;
    node.cf_node = NULL;
    CFTreeContext dataContext;
    CFTreeGetContext(node.cf_weakNode, &dataContext);
    node.data = (__bridge id)dataContext.info;
    CFTreeContext context = {
        .info = (__bridge void *)node,
        .retain = CFRetain,
        .release = CFRelease,
        .copyDescription = CFCopyDescription
    };
    CFTreeSetContext(node.cf_weakNode, &context);
    return YES;
}

#pragma mark - remove self or child
- (BOOL)removeSelf
{
    if (_isRoot) return NO;
    CFTreeRemove(_cf_weakNode);
    return YES;
}

- (CLXTree *)removeChildAt:(NSUInteger)index
{
    CLXTree *tree = [self childAt:index];
    if (tree && [tree removeSelf]) {
        return tree;
    } else {
        return nil;
    }
}

- (void)removeAllChildren
{
    CFTreeRef tree = [self __cfNode];
    CFTreeRemoveAllChildren(tree);
}

#pragma  mark -utility
- (CFTreeRef)__cfNode
{
    CFTreeRef tree;
    tree = _isRoot ? _cf_node : _cf_weakNode;
    return tree;
}

#pragma mark -override
-(NSUInteger)hash
{
    return [_data hash];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) return YES;
    if (![object isKindOfClass:self.class]) return NO;
    CLXTree *obj = (CLXTree *)object;
    return [obj.data isEqual:_data];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"CLXTree:%p--treePath:%@--data:%@",self,self.path, self.data];
}

@end
