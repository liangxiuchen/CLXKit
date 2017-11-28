//
//  CLXSafeMutableDicionary.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/24.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
//注意：使用enumerator时候是不允许改变字典的
@interface CLXSafeMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>

@end
