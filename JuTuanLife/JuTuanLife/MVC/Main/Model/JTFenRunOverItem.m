//
//  JTFenRunItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/20.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTFenRunOverItem.h"

@implementation JTFenRunOverItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"personalCommStats" : [JTShipItem class]};
}

+ (NSString *)titleForPeriod:(JTFenRunPeriod)period
{
    switch (period) {
        case JTFenRunPeriodYesterday:
            return @"昨日";
            break;
        case JTFenRunPeriodWeek:
            return @"本周";
            break;
        case JTFenRunPeriodMonth:
            return @"本月";
            break;
        case JTFenRunPeriodQuarter:
            return @"本季";
            break;
        case JTFenRunPeriodYear:
            return @"本年";
            break;
        case JTFenRunPeriodFixDay:
            return @"日";
            break;
        case JTFenRunPeriodFixMonth:
            return @"月";
            break;
        case JTFenRunPeriodFixYear:
            return @"年";
            break;
        default:
            break;
    }
}

@end
