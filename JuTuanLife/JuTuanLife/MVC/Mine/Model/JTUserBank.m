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

//- (NSString *)bankNumCipher
//{
//    if (_cardNo.length) {
//        return [_cardNo stringByReplacingCharactersInRange:NSMakeRange(0, _cardNo.length - 4) withString:@"·"];
//    } else {
//        return _cardNo;
//    }
//}

- (NSString *)bankNumCipher
{
    if (_cardNo.length > 7) {
        NSString *str = [NSString replaceString:_cardNo withStr:@"·" inRange:NSMakeRange(3, _cardNo.length - 7)];
        return [NSString insertSpaceForString:str withLength:4];
    } else {
        return _cardNo;
    }
}


@end
