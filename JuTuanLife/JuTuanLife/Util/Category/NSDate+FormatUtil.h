//
//  NSDate+FormatUtil.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FormatUtil)

+ (NSString *)dayStr:(NSString *)dateStr;
+ (NSString *)hourMinStr:(NSString *)dateStr;
+ (NSString *)dayHourMinStr:(NSString *)dateStr;
+ (NSString *)autoDayOrHourMinStr:(NSString *)dateStr;

+ (NSString *)yesterdayString;
+ (NSString *)todayOrYesterdayStr:(NSString *)dateStr;

@end
