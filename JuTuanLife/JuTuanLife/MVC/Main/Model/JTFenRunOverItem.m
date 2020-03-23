//
//  JTFenRunItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/20.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTFenRunOverItem.h"

@implementation JTFenRunOverItem

//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
//{
//    return @{@"personalCommStats" : [JTShipItem class]};
//}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.totalCommAmt = _totalCommAmt / 100;
    self.myCommAmt = _myCommAmt / 100;
    self.descendantCommAmt = _descendantCommAmt / 100;
    return YES;
}

- (NSString *)dateStrForPeriod:(JTFenRunPeriod)period
{
    if (self.dateFrom && self.dateTo) {
        if (![self.dateFrom isEqualToString:self.dateTo]) {
            return [NSString stringWithFormat:@"%@ - %@", self.dateFrom, self.dateTo];
        }
    }
    if (self.dateFrom) {
        return self.dateFrom;
    } else if (self.dateTo) {
        return self.dateTo;
    }
    return nil;
//    switch (period) {
//        case JTFenRunPeriodYesterday:
//        case JTFenRunPeriodFixDay:
//            return [JTCoreUtil showDateWith:self.dateFrom];
//            break;
//        case JTFenRunPeriodMonth:
//        case JTFenRunPeriodFixMonth:
//        {
//            return [JTCoreUtil showDateWith:self.dateFrom];
//        }
//            break;
//        case JTFenRunPeriodYear:
//        case JTFenRunPeriodFixYear:
//        {
//            return [JTCoreUtil showDateWith:self.dateFrom];
//        }
//            break;
//        case JTFenRunPeriodWeek:
//        {
//            return [NSString stringWithFormat:@"%@ - %@", self.dateFrom, self.dateTo];
//        }
//            break;
//        case JTFenRunPeriodQuarter:
//        {
//            return [NSString stringWithFormat:@"%@ - %@", self.dateFrom, self.dateTo];
//        }
//            break;
//        default:
//            break;
//    }
//    return [JTCoreUtil showDateWith:self.dateFrom];
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
