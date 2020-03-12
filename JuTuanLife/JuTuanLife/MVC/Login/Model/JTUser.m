//
//  JTUser.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUser.h"

@implementation JTUser

- (NSString *)phoneCipher
{
    if (_phone.length) {
        NSInteger right = MIN(_phone.length / 3, 3);
        NSInteger left = MIN((_phone.length - right) / 2, 3);
        return [_phone stringByReplacingCharactersInRange:NSMakeRange(left, _phone.length - left - right) withString:@"*"];
    } else {
        return _phone;
    }
}

- (NSString *)IDNumCipher
{
    NSString *num = self.cert.certNo;
    if (num.length > 5) {
        return [num stringByReplacingCharactersInRange:NSMakeRange(1, num.length - 5) withString:@"·"];
    } else {
        return num;
    }
}

- (NSString *)bankNumCipher
{
    if (_bankNum.length > 4) {
        return [_bankNum stringByReplacingCharactersInRange:NSMakeRange(0, _bankNum.length - 4) withString:@"·"];
    } else {
        return _bankNum;
    }
}

@end
