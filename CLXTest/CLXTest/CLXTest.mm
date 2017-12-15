//
//  CLXTest.m
//  CLXTest
//
//  Created by chen liangxiu on 2017/11/30.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXTest.h"
#import <pthread.h>

static int    SubtypeUntil           (const char *    type,
                                      char        end)
{
    int        level = 0;
    const char *    head = type;

    //
    while (*type)
    {
        if (!*type || (!level && (*type == end)))
            return (int)(type - head);

        switch (*type)
        {
            case ']': case '}': case ')': level--; break;
            case '[': case '{': case '(': level += 1; break;
        }

        type += 1;
    }

//    _objc_fatal ("Object: SubtypeUntil: end of type encountered prematurely\n");
    return 0;
}


/***********************************************************************
 * SkipFirstType.
 **********************************************************************/
static const char *    SkipFirstType       (const char *    type)
{
    while (1)
    {
        switch (*type++)
        {
            case 'O':    /* bycopy */
            case 'n':    /* in */
            case 'o':    /* out */
            case 'N':    /* inout */
            case 'r':    /* const */
            case 'V':    /* oneway */
            case '^':    /* pointers */
                break;

            case '@':   /* objects */
                if (type[0] == '?') type++;  /* Blocks */
                return type;

                /* arrays */
            case '[':
                while ((*type >= '0') && (*type <= '9'))
                    type += 1;
                return type + SubtypeUntil (type, ']') + 1;

                /* structures */
            case '{':
                return type + SubtypeUntil (type, '}') + 1;

                /* unions */
            case '(':
                return type + SubtypeUntil (type, ')') + 1;

                /* basic types */
            default:
                return type;
        }
    }
}

@implementation CLXTest

- (void)testSynchronized {


}

@end
