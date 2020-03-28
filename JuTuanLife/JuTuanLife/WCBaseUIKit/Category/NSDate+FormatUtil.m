//
//  NSDate+FormatUtil.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "NSDate+FormatUtil.h"

@implementation NSDate (FormatUtil)

+ (NSString *)dayStr:(NSString *)dateStr
{
    if (dateStr.length) {
        NSArray *array = [dateStr componentsSeparatedByString:@" "];
        if (array.count == 2) {
            return array.firstObject;
        }
    }
    return dateStr;
}

+ (NSString *)hourMinStr:(NSString *)dateStr
{
    if (dateStr.length) {
        NSArray *array = [dateStr componentsSeparatedByString:@" "];
        if (array.count == 2) {
            return [self hourMinStr:array.lastObject];
        }
    }
    return dateStr;
}

+ (NSString *)dayHourMinStr:(NSString *)dateStr
{
    if (dateStr.length) {
        NSArray *array = [dateStr componentsSeparatedByString:@":"];
        if (array.count == 3) {
            return [[array subarrayWithRange:NSMakeRange(0, 2)] componentsJoinedByString:@":"];
        }
    }
    return dateStr;
}

+ (NSString *)autoDayOrHourMinStr:(NSString *)dateStr
{
    NSString *dayStr = [self dayStr:dateStr];
    if (dayStr && [dayStr isEqualToString:[NSDate todayString]]) {
        return [self hourMinStr:dateStr];
    } else {
        return dayStr;
    }
}

+ (NSString *)yesterdayString
{
    static NSString *yesterdayStr = nil;
    if (!yesterdayStr) {
        yesterdayStr = [[NSDate dateWithTimeIntervalSinceNow:-24 * 60 * 60] stringValue:yyyyMMdd];
    }
    return yesterdayStr;
}

+ (NSString *)todayOrYesterdayStr:(NSString *)dateStr
{
    NSString *dayStr = [self dayStr:dateStr];
    if (dayStr) {
        if ([dayStr isEqualToString:[NSDate todayString]]) {
            return @"今天";
        } else if ([dateStr isEqualToString:[NSDate yesterdayString]]) {
            return @"昨天";
        }
    }
    return dayStr;
}

@end
