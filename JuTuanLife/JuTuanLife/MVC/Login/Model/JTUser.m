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
    if (self.IDNumCipher.length) {
        return [_IDNum stringByReplacingCharactersInRange:NSMakeRange(1, _IDNum.length - 5) withString:@"·"];
    } else {
        return _IDNum;
    }
}

- (NSString *)bankNumCipher
{
    if (_bankNum.length) {
        return [_bankNum stringByReplacingCharactersInRange:NSMakeRange(0, _bankNum.length - 4) withString:@"·"];
    } else {
        return _bankNum;
    }
}

@end
