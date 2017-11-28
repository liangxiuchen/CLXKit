//
//  CLXURLEncoder.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/2.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 * @abstract:这是一个对URL Components 进行百分号转义后，自动拼接成有效的绝对路径的URL String
 * @URL-Format:"<scheme>://user:password@/path;parameters?query#fragment"
 * @Extension:可以使用CLXURLEncodeMaker,也可在NSURL中扩展一个分类方法，
 */
@class CLXURLEncoder;
typedef CLXURLEncoder *_Nonnull (^ChainPartialBlock_t) (NSString *partial);//单个URL Component
typedef CLXURLEncoder *_Nonnull (^ChainPathBlock_t) (NSString *path,  NSString * _Nullable param);//一个path和对应parameters

typedef void (^FinishChainBlock_t) (void);

NS_CLASS_AVAILABLE_IOS(7.0)
@interface CLXURLEncoder : NSObject

@property (nonatomic, readonly) FinishChainBlock_t toAppend;//拼接经过转义，或者本身安全的 URL Component
@property (nonatomic, readonly) ChainPartialBlock_t pure;//本身安全的URL Component 准备拼接进去
@property (nonatomic, readonly) ChainPartialBlock_t encodeUser;//转义user Component
@property (nonatomic, readonly) ChainPartialBlock_t encodePassword;//转义password Component
@property (nonatomic, readonly) ChainPartialBlock_t encodehost;//转义host Component
@property (nonatomic, readonly) ChainPathBlock_t encodePath;//转义a pair of path and paramters
@property (nonatomic, readonly) ChainPartialBlock_t encodeQuery;//转义query Component
@property (nonatomic, readonly) ChainPartialBlock_t encodeFragment;//转义fragment Component
@property (nonatomic, readonly) NSString *encodedUrlStr;//转义后完整的URL absolutely string

@end

NS_ASSUME_NONNULL_END
