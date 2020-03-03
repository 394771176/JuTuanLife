//
//  DTTodayManager.m
//  DrivingTest
//
//  Created by cheng on 2017/10/31.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTTodayManager.h"
#import <WCCategory/WCCategory.h>

#define DTTodayManager_TODAY  @"_DTTodayManager.today"

@interface DTTodayManager () {
    BPAppPreference *_todayPreference;
}

@end

@implementation DTTodayManager

+ (DTTodayManager *)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.today = [NSDate todayString];
        _todayPreference = [DTAppPreferenceManager todayAppPreference];
    }
    return self;
}

#pragma mark - update day key

- (NSString *)dayKey:(NSString *)key
{
    if (key.length) {
        return [key stringByAppendingString:DTTodayManager_TODAY];
    }
    return key;
}

- (NSString *)dayForKey:(NSString *)key
{
    if (key.length) {
        return [_todayPreference stringForKey:[self dayKey:key]];
    }
    return nil;
}

- (void)updateDayForKey:(NSString *)key
{
    [_todayPreference setObject:_today forKey:[self dayKey:key]];
}

- (void)updateDayForKey:(NSString *)key withDateStr:(NSString *)dateStr
{
    [_todayPreference setObject:dateStr forKey:[self dayKey:key]];
}

- (BOOL)containDayKey:(NSString *)key
{
    NSString *dayStr = [self dayForKey:key];
    return dayStr != nil;
}

- (BOOL)isTodayKey:(NSString *)key
{
    return [self isTodayKey:key containNull:NO];
}

- (BOOL)isTodayKey:(NSString *)key containNull:(BOOL)containNull
{
    if (key.length) {
        NSString *dayStr = [self dayForKey:key];
        if (dayStr.length) {
            return [dayStr isEqualToString:_today];
        } else {
            return containNull;
        }
    }
    return NO;
}

- (BOOL)isValidKey:(NSString *)key forDays:(NSInteger)day
{
    if (key.length) {
        NSString *dayStr = [self dayForKey:key];
        if (dayStr.length) {
            NSDate *date = [[NSDate dateFromDateStr:dayStr formatter:yyyyMMdd] dateByAddingTimeInterval:24 * 60 * 60 * day];
            dayStr = [date stringValue:yyyyMMdd];
            return [NSDate NoEarlierToday:dayStr];
        } else {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isValidKeyEX:(NSString *)key forDays:(NSInteger)day
{
    if (key.length) {
        NSString *dayStr = [self dayForKey:key];
        if (dayStr.length) {
            NSDate *date = [[NSDate dateFromDateStr:dayStr formatter:yyyyMMdd] dateByAddingTimeInterval:24 * 60 * 60 * day];
            dayStr = [date stringValue:yyyyMMdd];
            return [NSDate NoLaterToday:dayStr];
        } else {
            return YES;
        }
    }
    return NO;
}

#pragma mark - update key value

- (void)setObject:(id)value forKey:(NSString *)key
{
    [self setObject:value forKey:key updateDay:YES];
}

- (void)removeObjectForKey:(NSString *)key
{
    [self removeObjectForKey:key updateDay:YES];
}

- (void)setObject:(id)value forKey:(NSString *)key updateDay:(BOOL)update
{
    if (key) {
        if (value) {
            [_todayPreference setObject:value forKey:key];
        } else {
            [_todayPreference removeObjectForKey:key];
        }
        if (update) {
            [self updateDayForKey:key];
        }
    }
}

- (void)removeObjectForKey:(NSString *)key updateDay:(BOOL)update
{
    if (key) {
        [_todayPreference removeObjectForKey:key];
        if (update) {
            [self updateDayForKey:key];
        }
    }
}

- (void)removeObjectForKey:(NSString *)key andRemoveDayObject:(BOOL)remove
{
    [self removeObjectForKey:key updateDay:(remove ? NO : YES)];
    if (remove) {
        [self removeObjectForDayKey:key];
    }
}

- (void)removeObjectForDayKey:(NSString *)key
{
    [self removeObjectForKey:[self dayKey:key]];
}

- (id)objectForKey:(NSString *)key
{
    return [_todayPreference objectForKey:key];
}

- (id)stringForKey:(NSString *)key
{
    return [_todayPreference stringForKey:key];
}

- (id)todayObjectForKey:(NSString *)key
{
    if ([self isTodayKey:key]) {
        return [self objectForKey:key];
    }
    return nil;
}

- (id)todayStringForKey:(NSString *)key
{
    id obj = [self todayObjectForKey:key];
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            return [obj stringValue];
        }
    }
    return nil;
}

- (void)appendTodayObject:(id)value forKey:(NSString *)key
{
    if (value) {
        NSString *string = [self todayStringForKey:key];
        if (string && [string isKindOfClass:[NSString class]]) {
            [self setObject:[string stringByAppendingFormat:@",%@", value] forKey:key];
        } else {
            [self setObject:[NSString stringWithFormat:@"%@", value] forKey:key];
        }
    }
}

- (BOOL)deleteTodayObject:(id)value forKey:(NSString *)key
{
    BOOL didRemove = NO;
    if (value) {
        NSString *string = [self todayStringForKey:key];
        if (string && [string isKindOfClass:[NSString class]]) {
            NSString *valueStr = [NSString stringWithFormat:@"%@", value];
            NSMutableArray *array = [[string componentsSeparatedByString:@","] mutableCopy];
            if ([array containsObject:valueStr]) {
                didRemove = YES;
                [array removeObject:valueStr];
            }
            if (didRemove) {
                if (array.count) {
                    [self setObject:[array componentsJoinedByString:@","] forKey:key];
                } else {
                    [self removeObjectForKey:key];
                }
            }
        }
    }
    return didRemove;
}

- (BOOL)deleteTodayObjects:(NSArray *)objs forKey:(NSString *)key
{
    BOOL didRemove = NO;
    if (objs.count) {
        NSString *string = [self todayStringForKey:key];
        if (string && [string isKindOfClass:[NSString class]]) {
            NSMutableArray *array = [[string componentsSeparatedByString:@","] mutableCopy];
            for (id value in array) {
                NSString *valueStr = [NSString stringWithFormat:@"%@", value];
                if ([array containsObject:valueStr]) {
                    didRemove = YES;
                    [array removeObject:valueStr];
                }
            }
            
            if (didRemove) {
                if (array.count) {
                    [self setObject:[array componentsJoinedByString:@","] forKey:key];
                } else {
                    [self removeObjectForKey:key];
                }
            }
        }
    }
    return didRemove;
}

@end
