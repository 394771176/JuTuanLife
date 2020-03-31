//
//  JTUserBank.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserBank.h"

@implementation JTUserBank

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"itemId" : @"id"};
}

- (NSString *)bankNumCipher
{
    if (_cardNo.length) {
        return [_cardNo stringByReplacingCharactersInRange:NSMakeRange(0, _cardNo.length - 4) withString:@"·"];
    } else {
        return _cardNo;
    }
}

@end
