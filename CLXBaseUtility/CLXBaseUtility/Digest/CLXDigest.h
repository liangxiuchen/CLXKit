//
//  CLXDigest.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/6.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CLXDigestAlgorithm)
{
    CLXDigestMD2 = 0,
    CLXDigestMD4,
    CLXDigestMD5,
    CLXDigestSHA1,
    CLXDigestSHA224,
    CLXDigestSHA256,
    CLXDigestSHA384,
    CLXDigestSHA512,
    CLXDigestCRC32,//crc校验
    CLXDigestAdler32,//alder校验
};
//各个摘要算法和校验算法的结果长度，单位字节
extern const size_t CLXDigest_MD2_Length;
extern const size_t CLXDigest_MD4_Length;
extern const size_t CLXDigest_MD5_Length;
extern const size_t CLXDigest_SHA1_Length;
extern const size_t CLXDigest_SHA224_Length;
extern const size_t CLXDigest_SHA256_Length;
extern const size_t CLXDigest_SHA384_Length;
extern const size_t CLXDigest_SHA512_Length;
extern const size_t CLXDigest_CRC32_Length;
extern const size_t CLXDigest_Adler32_Length;

@interface CLXDigest : NSObject

@property (nonatomic, copy, readonly) NSString *md2;
@property (nonatomic, copy, readonly) NSString *md2_base64;
@property (nonatomic, readonly) NSData *md2_Data;
@property (nonatomic, copy, readonly) NSString *md4;
@property (nonatomic, copy, readonly) NSString *md4_base64;
@property (nonatomic, readonly) NSData *md4_Data;
@property (nonatomic, copy, readonly) NSString *md5;
@property (nonatomic, copy, readonly) NSString *md5_base64;
@property (nonatomic, readonly) NSData *md5_Data;
@property (nonatomic, copy, readonly) NSString *sha1;
@property (nonatomic, copy, readonly) NSString *sha1_base64;
@property (nonatomic, readonly) NSData *sha1_Data;
@property (nonatomic, copy, readonly) NSString *sha224;
@property (nonatomic, copy, readonly) NSString *sha224_base64;
@property (nonatomic, readonly) NSData *sha224_Data;
@property (nonatomic, copy, readonly) NSString *sha256;
@property (nonatomic, copy, readonly) NSString *sha256_base64;
@property (nonatomic, readonly) NSData *sha256_Data;
@property (nonatomic, copy, readonly) NSString *sha384;
@property (nonatomic, copy, readonly) NSString *sha384_base64;
@property (nonatomic, readonly) NSData *sha384_Data;
@property (nonatomic, copy, readonly) NSString *sha512;
@property (nonatomic, copy, readonly) NSString *sha512_base64;
@property (nonatomic, readonly) NSData *sha512_Data;
@property (nonatomic, copy, readonly) NSString *crc32;
@property (nonatomic, copy, readonly) NSString *crc32_base64;
@property (nonatomic, readonly) NSData *crc32_Data;
@property (nonatomic, copy, readonly) NSString *adler32;
@property (nonatomic, copy, readonly) NSString *adler32_base64;
@property (nonatomic, readonly) NSData *adler32_Data;

+ (CLXDigest *)digestForBlockData:(const void *)data Length:(size_t)len Type:(CLXDigestAlgorithm)algorithm;

+ (CLXDigest *)digestForFile:(NSURL *)url Type:(CLXDigestAlgorithm)algorithm;

@end
