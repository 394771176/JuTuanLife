//
//  JTFenRunItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/20.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCBaseKit/WCBaseKit.h>
#import "JTShipItem.h"
#import "JTBusinessItem.h"

typedef NS_ENUM(NSUInteger, JTFenRunPeriod) {
    JTFenRunPeriodYesterday,
    JTFenRunPeriodWeek,
    JTFenRunPeriodMonth,
    JTFenRunPeriodQuarter,
    JTFenRunPeriodYear,
    JTFenRunPeriodFixDay,
    JTFenRunPeriodFixMonth,
    JTFenRunPeriodFixYear,
};

@interface JTFenRunOverItem : WCBaseEntity

@property (nonatomic, strong) NSString *dateFrom;
@property (nonatomic, strong) NSString *dateTo;

@property (nonatomic, assign) CGFloat totalCommAmt;
@property (nonatomic, assign) CGFloat myCommAmt;
@property (nonatomic, assign) CGFloat descendantCommAmt;
//@property (nonatomic, strong) NSArray<JTShipItem *> *personalCommStats;

@property (nonatomic, assign) CGFloat totalOrderAmt;//总订单金额
@property (nonatomic, assign) NSInteger totalOrders;//总笔数

@property (nonatomic, assign) CGFloat commAmt;//业务分润

@property (nonatomic, strong) JTBusinessItem *business;

- (NSString *)dateStr;
//- (NSString *)dateStrForPeriod:(JTFenRunPeriod)period;

+ (NSString *)titleForPeriod:(JTFenRunPeriod)period;

@end


