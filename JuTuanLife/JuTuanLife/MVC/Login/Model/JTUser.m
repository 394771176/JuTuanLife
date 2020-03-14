//
//  JTUser.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUser.h"

@implementation JTUser

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"teams" : [JTUserTeam class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if (APP_DEBUG) {
        _bankNum = @"1234567890123344";
    }
    return YES;
}

- (NSString *)phone
{
    if (!_phone) {
        _phone = [JTUserManager sharedInstance].phone;
    }
    return _phone;
}

- (NSString *)phoneCipher
{
    if (self.phone.length) {
        NSInteger right = MIN(_phone.length / 3, 3);
        NSInteger left = MIN((_phone.length - right) / 2, 3);
        
//        NSMutableString *str = [NSMutableString string];
//        for (int i=0; i < _phone.length - left - right; i++) {
//            [str appendString:@"*"];
//        }
//        return [_phone stringByReplacingCharactersInRange:NSMakeRange(left, _phone.length - left - right) withString:str];
        return [self.class replaceString:_phone withStr:@"*" inRange:NSMakeRange(left, _phone.length - left - right)];
    } else {
        return _phone;
    }
}

- (NSString *)IDNumCipher
{
    NSString *num = self.cert.certNo;
    if (APP_DEBUG) {
        num = @"362334199008253112";
    }
    if (num.length > 5) {
//        return [num stringByReplacingCharactersInRange:NSMakeRange(1, num.length - 5) withString:@"·"];
        return [self.class replaceString:num withStr:@"·" inRange:NSMakeRange(1, num.length - 5)];
    } else {
        return num;
    }
}

- (NSString *)bankNumCipher
{
    if (_bankNum.length > 4) {
//        return [_bankNum stringByReplacingCharactersInRange:NSMakeRange(0, _bankNum.length - 4) withString:@"·"];
        NSString *str = [self.class replaceString:_bankNum withStr:@"·" inRange:NSMakeRange(0, _bankNum.length - 4)];
        return [self.class insertSpaceForString:str withLength:4];
    } else {
        return _bankNum;
    }
}

+ (NSString *)replaceString:(NSString *)string withStr:(NSString *)str inRange:(NSRange)range
{
    if (string.length && str.length && range.location + range.length < string.length) {
        NSMutableString *mStr = [NSMutableString string];
        for (NSInteger i = 0; i < range.length; i++) {
            [mStr appendString:str];
        }
        return [string stringByReplacingCharactersInRange:range withString:mStr];
    }
    return string;
}

+ (NSString *)insertSpaceForString:(NSString *)string withLength:(NSInteger)length
{
    if (string.length > length) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *str = [string mutableCopy];
        while (str.length > length) {
            [array safeAddObject:[str substringToIndex:length]];
            str = [str substringFromIndex:length];
        }
        if (str.length) {
            [array safeAddObject:str];
        }
        return [array componentsJoinedByString:@" "];
    }
    return string;
}

@end

@interface JTUserTeam ()
{
    
}

@end

@implementation JTUserTeam

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"itemId" : @"id"};
}

@end
