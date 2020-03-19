//
//  JTFenRunItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/20.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCModel.h>
#import "JTShipItem.h"

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
@property (nonatomic, strong) NSArray<JTShipItem *> *personalCommStats;

+ (NSString *)titleForPeriod:(JTFenRunPeriod)period;

@end
