//
//  CLXURLEncoder.m
//  CLXBaseUtility
//
//  Created by chen liangxiu on 2017/11/2.
//  Copyright © 2017年 liang.xiu.chen.cn. All rights reserved.
//

#import "CLXURLEncoder.h"

@interface CLXURLEncoder()

@property (nonatomic, strong) NSMutableString *encodedStr;
@property (nonatomic, copy) NSString *toAdd;

@end

@implementation CLXURLEncoder
@dynamic toAppend, pure, encodeUser, encodePassword;
@dynamic  encodehost, encodePath, encodeQuery, encodeFragment;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _encodedStr = [NSMutableString string];
    }
    return self;
}

- (FinishChainBlock_t)toAppend
{
    return ^{
        if (_toAdd.length != 0) {
            [_encodedStr appendString:_toAdd];
            _toAdd = nil;
        }
    };
}

- (ChainPartialBlock_t)pure
{
    return ^CLXURLEncoder *(NSString *pureStr) {
        if (pureStr.length != 0) {
            _toAdd = pureStr;
        };
        return self;
    };
}

- (ChainPartialBlock_t)encodeUser
{
    return ^CLXURLEncoder *(NSString *user) {
        if (user.length != 0) {
            _toAdd = [user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
        }
        return self;
    };
}

- (ChainPartialBlock_t)encodePassword
{
    return ^CLXURLEncoder *(NSString *passwd) {
        if (passwd.length != 0) {
            _toAdd = [passwd stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPasswordAllowedCharacterSet]];
        }
        return self;
    };
}

- (ChainPartialBlock_t)encodehost
{
    return ^CLXURLEncoder *(NSString *host) {
        if (host.length != 0) {
            _toAdd = [host stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        }
        return self;
    };
}

- (ChainPathBlock_t)encodePath
{
    return ^CLXURLEncoder *(NSString *path, NSString *param) {
        if (path.length != 0) {
            if (![path hasPrefix:@"/"]) {
                path = [NSString stringWithFormat:@"/%@",path];
            } else {}
            if ([path hasSuffix:@"/"] && path.length > 1) {
                path = [path substringToIndex:path.length - 2];
            }
            NSString *encodePath = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
            if (param.length != 0) {

                if ([param hasPrefix:@";"] && param.length > 1) {
                    param = [param substringFromIndex:1];
                } else {}
                NSString *encodeParam = [param stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
                _toAdd = [NSString stringWithFormat:@"%@;%@",encodePath,encodeParam];
            } else {
                _toAdd = encodePath;
            }
        }
        return self;
    };
}

- (ChainPartialBlock_t)encodeQuery
{
    return ^CLXURLEncoder *(NSString *query) {
        if (query.length != 0) {
            if (![query hasPrefix:@"?"]) {
                query = [NSString stringWithFormat:@"?%@",query];
            } else {}
            _toAdd = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        return self;
    };
}

- (ChainPartialBlock_t)encodeFragment
{
    return ^CLXURLEncoder *(NSString *fragment) {
        if (fragment.length != 0) {
            if ([fragment hasPrefix:@"#"] && fragment.length > 1) {
                fragment = [fragment substringFromIndex:1];
            } else {}
            NSString *encodeFragment = [fragment stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            _toAdd = [NSString stringWithFormat:@"#%@",encodeFragment];
        }
        return self;
    };
}

- (NSString *)encodedUrlStr
{
    return self.encodedStr;
}

@end
