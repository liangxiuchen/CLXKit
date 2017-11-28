//
//  CLXEncryptor.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/7.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXEncryptor.h"
#import <CommonCrypto/CommonCryptor.h>
#import <Security/SecRandom.h>

@implementation CLXEncryptor

+ (NSData *)ase128EncryptWithData:(NSData *)plainData Key:(NSData *__autoreleasing *)key padding:(CLXEncryptorPadding)paddingMode
{
    if (0 == plainData.length)  return nil;
    //generate a security random ASE128 key
    void *keyBytes = malloc(kCCKeySizeAES128 * sizeof(uint8_t));//free by NSData
    int isSuccess = SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES128, keyBytes);
    if (0 != isSuccess) return nil;
    *key = [NSData dataWithBytesNoCopy:keyBytes length:kCCKeySizeAES128 freeWhenDone:YES];

    //padding avoid if not needed
    if (paddingMode != CLXEncryptorECBMode) {
        if (plainData.length % kCCBlockSizeAES128 == 0) {
            paddingMode = 0x0000;
        } else {
            paddingMode = CLXEncryptorPKCS7Padding;
        }
    } else {};
    return [self realWorkWith:kCCEncrypt inPutData:plainData Key:*key PaddingMode:paddingMode];
}

+ (NSData *)ase128DecryptWith:(NSData *)cipher Key:(NSData *)key padding:(CLXEncryptorPadding)padding
{
    if (0 == cipher.length) return nil;
    if (kCCBlockSizeAES128 != key.length) return nil;
    return [self realWorkWith:kCCDecrypt inPutData:cipher Key:key PaddingMode:padding];
}

+ (NSData *)realWorkWith:(CCOperation)operation inPutData:(NSData *)inputData Key:(NSData *)key PaddingMode:(CCPadding)padding
{
    CCCryptorRef ASE128Cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    uint8_t iv[kCCBlockSizeAES128];
    memset(iv, 0x0, sizeof(iv));
    status = CCCryptorCreate(operation, kCCAlgorithmAES128, padding, key.bytes, kCCKeySizeAES128, iv, &ASE128Cryptor);
    if (status != kCCSuccess) {
        return nil;
    }
    size_t outPutBufferSize = CCCryptorGetOutputLength(ASE128Cryptor, inputData.length, true);
    uint8_t *outPutBuffer = calloc(outPutBufferSize, sizeof(uint8_t));
    uint8_t *remainBuffer = outPutBuffer;
    size_t remainSize = outPutBufferSize;
    size_t totalwritten = 0;
    size_t movedSize = 0;
    status = CCCryptorUpdate(ASE128Cryptor, inputData.bytes, inputData.length, outPutBuffer, outPutBufferSize, &movedSize);
    if (status != kCCSuccess) {
        free(outPutBuffer);
        CCCryptorRelease(ASE128Cryptor);
        return nil;
    }

    remainSize -= movedSize;
    remainBuffer += movedSize;
    totalwritten += movedSize;

    status = CCCryptorFinal(ASE128Cryptor, remainBuffer, remainSize, &movedSize);
    if (status != kCCSuccess) {
        free(outPutBuffer);
        CCCryptorRelease(ASE128Cryptor);
        return nil;
    }
    totalwritten += movedSize;
    NSData *outPutData = [NSData dataWithBytes:outPutBuffer length:totalwritten];
    if (outPutBuffer) free(outPutBuffer);
    if (ASE128Cryptor) CCCryptorRelease(ASE128Cryptor);
    return outPutData;
}

@end
