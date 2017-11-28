//
//  BlockCompression.h
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/4.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#ifndef BlockCompression_h
#define BlockCompression_h

#include <stdio.h>
#include <stdbool.h>
#include "compression.h"

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

float doBlockCompression(FILE *inFile, FILE *outFile, compression_algorithm algorithm);

bool doBlockDecompression(FILE *inFile, FILE *outFile, compression_algorithm algorithm);

#endif /* BlockCompression_h */
