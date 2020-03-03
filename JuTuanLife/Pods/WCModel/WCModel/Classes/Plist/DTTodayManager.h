//
//  DTTodayManager.h
//  DrivingTest
//
//  Created by cheng on 2017/10/31.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTAppPreferenceManager.h"

@interface DTTodayManager : NSObject

@property (nonatomic, strong) NSString *today;

+ (DTTodayManager *)sharedInstance;

- (BOOL)isTodayKey:(NSString *)key;
- (BOOL)isTodayKey:(NSString *)key containNull:(BOOL)containNull;
- (BOOL)isValidKey:(NSString *)key forDays:(NSInteger)day;//day 为间隔
- (BOOL)isValidKeyEX:(NSString *)key forDays:(NSInteger)day;//todo 优化
- (void)updateDayForKey:(NSString *)key;

- (void)updateDayForKey:(NSString *)key withDateStr:(NSString *)dateStr;

- (BOOL)containDayKey:(NSString *)key;

- (id)objectForKey:(NSString *)key;
- (id)todayObjectForKey:(NSString *)key;

- (id)stringForKey:(NSString *)key;
- (id)todayStringForKey:(NSString *)key;

- (void)setObject:(id)value forKey:(NSString *)key;

//移除key object,同时更新dayKey 的时间
- (void)removeObjectForKey:(NSString *)key;
//移除dayKey object
- (void)removeObjectForDayKey:(NSString *)key;

- (void)setObject:(id)value forKey:(NSString *)key updateDay:(BOOL)update;
//移除key object,同时控制dayKey 的时间是否更新
- (void)removeObjectForKey:(NSString *)key updateDay:(BOOL)update;
//移除key object,同时移除dayKey object
- (void)removeObjectForKey:(NSString *)key andRemoveDayObject:(BOOL)remove;

//拼接value,以逗号拼接，并以 一天 存储
- (void)appendTodayObject:(id)value forKey:(NSString *)key;
- (BOOL)deleteTodayObject:(id)value forKey:(NSString *)key;
- (BOOL)deleteTodayObjects:(NSArray *)objs forKey:(NSString *)key;

@end
