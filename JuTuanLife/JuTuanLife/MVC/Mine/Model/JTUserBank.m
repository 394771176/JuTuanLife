//
//  JTUserBank.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserBank.h"

@implementation JTUserBank

- (NSString *)bankNumCipher
{
    if (_bankNum.length) {
        return [_bankNum stringByReplacingCharactersInRange:NSMakeRange(0, _bankNum.length - 4) withString:@"·"];
    } else {
        return _bankNum;
    }
}

@end
