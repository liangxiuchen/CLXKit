//
//  CLXDigest.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/6.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXDigest.h"
#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>

#define CLX_TOTAL_ALGORITHMS 10
#define CLXKB (1024)
#define CLX_READ_BUFFER_SIZE (4 * (CLXKB))//4K

const size_t CLXDigest_MD2_Length = CC_MD2_DIGEST_LENGTH;
const size_t CLXDigest_MD4_Length = CC_MD4_DIGEST_LENGTH;
const size_t CLXDigest_MD5_Length = CC_MD5_DIGEST_LENGTH;
const size_t CLXDigest_SHA1_Length = CC_SHA1_DIGEST_LENGTH;
const size_t CLXDigest_SHA224_Length = CC_SHA224_DIGEST_LENGTH;
const size_t CLXDigest_SHA256_Length = CC_SHA256_DIGEST_LENGTH;
const size_t CLXDigest_SHA384_Length = CC_SHA384_DIGEST_LENGTH;
const size_t CLXDigest_SHA512_Length = CC_SHA512_DIGEST_LENGTH;
const size_t CLXDigest_CRC32_Length = sizeof(uLong) / sizeof(uint8_t);
const size_t CLXDigest_Adler32_Length = sizeof(uLong) / sizeof(uint8_t);

static inline size_t hashResultLength(CLXDigestAlgorithm algorithm)
{
    size_t lengthes[CLX_TOTAL_ALGORITHMS];
    lengthes[CLXDigestMD2] = CLXDigest_MD2_Length;
    lengthes[CLXDigestMD4] = CLXDigest_MD4_Length;
    lengthes[CLXDigestMD5] = CLXDigest_MD5_Length;
    lengthes[CLXDigestSHA1] = CLXDigest_SHA1_Length;
    lengthes[CLXDigestSHA224] = CLXDigest_SHA224_Length;
    lengthes[CLXDigestSHA256] = CLXDigest_SHA256_Length;
    lengthes[CLXDigestSHA384] = CLXDigest_SHA384_Length;
    lengthes[CLXDigestSHA512] = CLXDigest_SHA512_Length;
    lengthes[CLXDigestCRC32] = CLXDigest_CRC32_Length;
    lengthes[CLXDigestAdler32] = CLXDigest_Adler32_Length;
    return lengthes[algorithm];
}

@implementation CLXDigest

+ (CLXDigest *)digestForBlockData:(const void *)data Length:(size_t)len Type:(CLXDigestAlgorithm)algorithm
{
    unsigned char *(*CLXBlockAlgorithms[CLX_TOTAL_ALGORITHMS])(const void *, CC_LONG , unsigned char *);
    CLXBlockAlgorithms[CLXDigestMD2] = CC_MD2;
    CLXBlockAlgorithms[CLXDigestMD4] = CC_MD4;
    CLXBlockAlgorithms[CLXDigestMD5] = CC_MD5;
    CLXBlockAlgorithms[CLXDigestSHA1] = CC_SHA1;
    CLXBlockAlgorithms[CLXDigestSHA224] = CC_SHA224;
    CLXBlockAlgorithms[CLXDigestSHA256] = CC_SHA256;
    CLXBlockAlgorithms[CLXDigestSHA384] = CC_SHA384;
    CLXBlockAlgorithms[CLXDigestSHA512] = CC_SHA512;
    CLXBlockAlgorithms[CLXDigestCRC32] = CLX_CRC32;
    CLXBlockAlgorithms[CLXDigestAdler32] = CLX_Adler32;

    size_t length = hashResultLength(algorithm);
    unsigned char *digest = calloc(length, sizeof(unsigned char));
    CLXBlockAlgorithms[algorithm](data,(CC_LONG)len,digest);
    NSData *digestData = [NSData dataWithBytes:digest length:length];
    free(digest);
    return [self resultDigest:algorithm Data:digestData];
}

+ (CLXDigest *)digestForFile:(NSURL *)url Type:(CLXDigestAlgorithm)algorithm
{
    //确定URL文件存在
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:url.path];
    if (!exist) return nil;
    FILE *toHash = fopen([url.path cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (!toHash) return nil;
    //获取文件大小
    fseek(toHash, 0, SEEK_END);
    long fileSize = ftell(toHash);
    fseek(toHash, 0, SEEK_SET);
    if (fileSize <= 0) {
        fclose(toHash);
        return nil;
    }
    //初始化各种算法函数数组
    void *CLXAlgorithmContexts[CLX_TOTAL_ALGORITHMS];//need free items
    int (*CLXInitAlgorithms[CLX_TOTAL_ALGORITHMS])(void *);
    int (*CLXUpdateAlgorithms[CLX_TOTAL_ALGORITHMS])(void *, const void *data, CC_LONG len);
    int (*CLXFinalAlgorithms[CLX_TOTAL_ALGORITHMS])(unsigned char *digest, void *);
#define STREAM_ALGORITHMS_INIT(type, context, init_method, update_method, final_method)\
{\
CLXAlgorithmContexts[type] = malloc(sizeof(context));\
CLXInitAlgorithms[type] = (int (*)(void *))init_method;\
CLXUpdateAlgorithms[type] = (int (*)(void *, const void *, CC_LONG))update_method;\
CLXFinalAlgorithms[type] = (int (*)(unsigned char *, void *))final_method;\
}

    STREAM_ALGORITHMS_INIT(CLXDigestMD2, CC_MD2_CTX, CC_MD2_Init, CC_MD2_Update, CC_MD2_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestMD4, CC_MD4_CTX, CC_MD4_Init, CC_MD4_Update, CC_MD4_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestMD5, CC_MD5_CTX, CC_MD5_Init, CC_MD5_Update, CC_MD5_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestSHA1, CC_SHA1_CTX, CC_SHA1_Init, CC_SHA1_Update, CC_SHA1_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestSHA224, CC_SHA256_CTX, CC_SHA224_Init, CC_SHA224_Update, CC_SHA224_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestSHA256, CC_SHA256_CTX, CC_SHA256_Init, CC_SHA256_Update, CC_SHA256_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestSHA384, CC_SHA512_CTX, CC_SHA384_Init, CC_SHA384_Update, CC_SHA384_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestSHA512, CC_SHA512_CTX, CC_SHA512_Init, CC_SHA512_Update, CC_SHA512_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestCRC32, uLong, CLX_CRC32_Init, CLX_CRC32_Update, CLX_CRC32_Final);
    STREAM_ALGORITHMS_INIT(CLXDigestAdler32, uLong, CLX_Adler32_Init, CLX_Adler32_Update, CLX_Adler32_Final);
#undef STREAM_ALGORITHMS_INIT
    //开始进行摘要计算
    long remain = fileSize - CLX_READ_BUFFER_SIZE;//剩余需要hash的大小
    BOOL final = NO;//所有数据都hash结束
    long readSize = CLX_READ_BUFFER_SIZE;//文件每次读取大小
    unsigned char *digest = malloc(hashResultLength(algorithm));//need free
    CLXInitAlgorithms[algorithm](CLXAlgorithmContexts[algorithm]);
    do {
        if (remain < 0) {
            //剩余不足预定的读取大小,读取最后的一点点数据，计算出摘要结果
            final = YES;
            readSize = CLX_READ_BUFFER_SIZE + remain;
        } else {}
        void *data = malloc(readSize);//need free
        if (fread(data, 1, readSize, toHash) == 0) {
            //释放内存
            free(digest);
            free(data);
            for (uint i = 0; i < CLX_TOTAL_ALGORITHMS; i++) {
                free(CLXAlgorithmContexts[i]);
            }
            fclose(toHash);
            return nil;
        }
        CLXUpdateAlgorithms[algorithm](CLXAlgorithmContexts[algorithm],(const void *)data,(CC_LONG)readSize);
        free(data);
        remain = remain - CLX_READ_BUFFER_SIZE;
    } while (final == NO);
    //返回结果
    CLXFinalAlgorithms[algorithm](digest, CLXAlgorithmContexts[algorithm]);
    NSData *digestData = [NSData dataWithBytes:digest length:hashResultLength(algorithm)];
    //释放内存
    free(digest);
    for (uint i = 0; i < CLX_TOTAL_ALGORITHMS; i++) {
        free(CLXAlgorithmContexts[i]);
    }
    fclose(toHash);//关闭文件流

    return [self resultDigest:algorithm Data:digestData];
}

+ (CLXDigest *)resultDigest:(CLXDigestAlgorithm)algorithm Data:(NSData *)digestData
{
    //格式化显示
    NSMutableString *digestStr = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)digestData.bytes;
    for (int i = 0; i < digestData.length; i++) {
        [digestStr appendFormat:@"%02x",bytes[i]];
    }

    CLXDigest *hash = [CLXDigest new];
    switch (algorithm) {
        case CLXDigestMD2:
        {
            hash->_md2 = digestStr.copy;
            hash->_md2_Data = digestData;
            hash->_md2_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestMD4:
        {
            hash->_md4 = digestStr.copy;
            hash->_md4_Data = digestData;
            hash->_md4_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestMD5:
        {
            hash->_md5 = digestStr.copy;
            hash->_md5_Data = digestData;
            hash->_md5_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestSHA1:
        {
            hash->_sha1 = digestStr.copy;
            hash->_sha1_Data = digestData;
            hash->_sha1_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestSHA224:
        {
            hash->_sha224 = digestStr.copy;
            hash->_sha224_Data = digestData;
            hash->_sha224_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestSHA256:
        {
            hash->_sha256 = digestStr.copy;
            hash->_sha256_Data = digestData;
            hash->_sha256_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestSHA384:
        {
            hash->_sha384 = digestStr.copy;
            hash->_sha384_Data = digestData;
            hash->_sha384_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestSHA512:
        {
            hash->_sha512 = digestStr.copy;
            hash->_sha512_Data = digestData;
            hash->_sha512_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestCRC32:
        {
            hash->_crc32 = digestStr.copy;
            hash->_crc32_Data = digestData;
            hash->_crc32_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        case CLXDigestAdler32:
        {
            hash->_adler32 = digestStr.copy;
            hash->_adler32_Data = digestData;
            hash->_adler32_base64 = [digestData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } break;
        default:
            break;
    }
    return hash;
}

#pragma mark-
#pragma mark-CRC32
int CLX_CRC32_Init(uLong *crc)
{
    *crc = crc32(0L, Z_NULL, 0);
    return 0;
}

int CLX_CRC32_Update(uLong *crc, const void *data, CC_LONG len)
{
    *crc = crc32(*crc, data, len);
    return 0;
}

int CLX_CRC32_Final(unsigned char *result, uLong *crc)
{
    *((uLong *)result) = *crc;
    return 0;
}
//block function
unsigned char *CLX_CRC32(const void *data, CC_LONG len, unsigned char *crc)
{
    uLong c;
    CLX_CRC32_Init(&c);
    CLX_CRC32_Update(&c, data, len);
    CLX_CRC32_Final(crc, &c);
    return crc;
}

#pragma mark-
#pragma mark-Adler
int CLX_Adler32_Init(uLong *adler)
{
    *adler = adler32(0L, Z_NULL, 0);
    return 0;
}

int CLX_Adler32_Update(uLong *adler, const void *data, CC_LONG len)
{
    *adler = adler32(*adler, data, len);
    return 0;
}

int CLX_Adler32_Final(unsigned char *result, uLong *adler)
{
    *((uLong *)result) = *adler;
    return 0;
}

//block function
unsigned char *CLX_Adler32(const void *data, CC_LONG len, unsigned char *adler)
{
    uLong a;
    CLX_Adler32_Init(&a);
    CLX_Adler32_Update(&a, data, len);
    CLX_Adler32_Final(adler, &a);
    return adler;
}

@end
