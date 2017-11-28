//
//  CLXTree.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/25.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface CLXTree : NSObject

@property (nonatomic, readonly) BOOL isRoot;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) NSIndexPath *path;//节点在树中的路径

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initRootTreeWith:(id)data NS_DESIGNATED_INITIALIZER;
- (instancetype)initTreeWith:(id)data NS_DESIGNATED_INITIALIZER;

- (NSInteger)countOfChildren;
- (nullable CLXTree *)parent;
- (CLXTree *)rootNode;

- (nullable CLXTree *)firstChild;
- (nullable CLXTree *)lastChild;
- (nullable CLXTree *)childAt:(NSUInteger)index;
- (nullable CLXTree *)descendantWithIndexPath:(NSIndexPath *)indexPath;

- (void)addChild:(CLXTree *)node;
- (BOOL)insertChild:(CLXTree *)node at:(NSUInteger)index;

- (BOOL)removeSelf;
- (nullable CLXTree *)removeChildAt:(NSUInteger)index;
- (void)removeAllChildren;

@end
NS_ASSUME_NONNULL_END
