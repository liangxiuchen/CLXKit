//
//  BlockCompression.c
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/4.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "BlockCompression.h"

float doBlockCompression(FILE *inFile, FILE *outFile,compression_algorithm algorithm)
{
    size_t src_size;
    fseek(inFile, 0, SEEK_END);
    src_size = ftell(inFile);
    fseek(inFile, 0, SEEK_SET);
    if (src_size <= 0) {
        goto Error;
    }
    src_size = src_size == -1 ? 0 :src_size;
    uint8_t *src_buffer = malloc(src_size);
    if (NULL == src_buffer) {
        goto Error;
    }
    // Output buffer: Allocate (add extra 4096 bytes).
    size_t dst_size = src_size + 4096;
    uint8_t *dst_buffer = malloc(dst_size);
    if (NULL == dst_buffer) {
        goto Error;
    }
    //read
    fread(src_buffer, 1, src_size, inFile);
    dst_size = compression_encode_buffer(dst_buffer, dst_size, src_buffer, src_size, NULL, algorithm);
    if (dst_size == 0) {
        goto Error;
    }
    fwrite(dst_buffer, 1, dst_size, outFile);
    float compressionRatio = (float)src_size / (float)dst_size;
    //释放
    free(src_buffer);
    free(dst_buffer);
    fclose(inFile);
    fclose(outFile);
    return compressionRatio;
Error:
    fclose(inFile);
    fclose(outFile);
    fprintf(stderr, "压缩出现错误!");
    return 0.f;
}

bool doBlockDecompression(FILE *inFile, FILE *outFile, compression_algorithm algorithm)
{
    
    //分配压缩块的缓冲
    fseek(inFile, 0, SEEK_END);
    size_t src_size = ftell(inFile);
    fseek(inFile, 0, SEEK_SET);
    if (src_size <= 0) {
        return false;
    }
    uint8_t *src_buffer = malloc(src_size);
    if (src_buffer == NULL) {
        fclose(inFile);
        fclose(outFile);
        return false;
    }
    fread(src_buffer, 1, src_size, inFile);

    size_t dst_size = src_size;
    uint8_t *dst_buffer = malloc(dst_size);
    if (dst_buffer == NULL) {
        fclose(inFile);
        fclose(outFile);
        free(src_buffer);
        false;
    }
    dst_size = compression_decode_buffer(dst_buffer, dst_size, src_buffer, src_size, NULL, algorithm);
    if (dst_size == 0) {
        free(src_buffer);
        free(dst_buffer);
        fclose(inFile);
        fclose(outFile);
        return false;
    } else if (dst_size == 1) {
        fwrite(dst_buffer, 1, dst_size, outFile);
    } else {
        free(dst_buffer);
        dst_buffer = malloc(dst_size);
        dst_size = compression_decode_buffer(dst_buffer, dst_size, src_buffer, src_size, NULL, algorithm);
        fwrite(dst_buffer, 1, dst_size, outFile);
    }
    free(src_buffer);
    free(dst_buffer);
    fclose(inFile);
    fclose(outFile);
    return true;
}

