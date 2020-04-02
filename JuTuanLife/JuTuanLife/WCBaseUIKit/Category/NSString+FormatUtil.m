//
//  NSString+FormatUtil.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/3.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "NSString+FormatUtil.h"

@implementation NSString (FormatUtil)

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
