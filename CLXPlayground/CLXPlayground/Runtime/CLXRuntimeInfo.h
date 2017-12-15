//
//  CLXRuntimeInfo.h
//  CLXPlayground
//
//  Created by chen liangxiu on 2017/11/28.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 #define _C_ID       '@'
 #define _C_CLASS    '#'
 #define _C_SEL      ':'
 #define _C_CHR      'c'
 #define _C_UCHR     'C'
 #define _C_SHT      's'
 #define _C_USHT     'S'
 #define _C_INT      'i'
 #define _C_UINT     'I'
 #define _C_LNG      'l'
 #define _C_ULNG     'L'
 #define _C_LNG_LNG  'q'
 #define _C_ULNG_LNG 'Q'
 #define _C_FLT      'f'
 #define _C_DBL      'd'
 #define _C_BFLD     'b'
 #define _C_BOOL     'B'
 #define _C_VOID     'v'
 #define _C_UNDEF    '?'
 #define _C_PTR      '^'
 #define _C_CHARPTR  '*'
 #define _C_ATOM     '%'
 #define _C_ARY_B    '['
 #define _C_ARY_E    ']'
 #define _C_UNION_B  '('
 #define _C_UNION_E  ')'
 #define _C_STRUCT_B '{'
 #define _C_STRUCT_E '}'
 #define _C_VECTOR   '!'
 #define _C_CONST    'r'
 */
typedef NS_ENUM(NSUInteger,CLXRuntimeTypeEncode)
{
    CLXRuntimeTypeObj = 0,
    CLXRuntimeTypeClass,
    CLXRuntimeTypeSel,
    CLXRuntimeTypeChar,
    CLXRuntimeTypeUChar,
    CLXRuntimeTypeShort,
    CLXRuntimeTypeUShort,
    CLXRuntimeTypeInt,
    CLXRuntimeTypeLong,
    CLXRuntimeTypeULong,
    
};

@interface CLXRuntimeInfo : NSObject

@end
