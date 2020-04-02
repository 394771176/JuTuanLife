//
//  JTFenRunModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTFenRunModel.h"

@implementation JTFenRunModel

- (NSString *)cacheKey
{
    return @"JTFenRunModel_cacheKey";
}

- (WCDataResult *)loadData
{
    NSString *date = nil;
    if (_period >= JTFenRunPeriodFixDay) {
        date = self.selectedDate;
    }
    WCDataResult *result = [JTService sync:[JTUserRequest get_commission_statsWithPeriod:_period date:date pos:self.pos pageSize:self.fetchLimit]];
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    [super parseData:data];
    
    if (self.isReload || self.isLoadCache) {
        self.fenrun = [JTFenRunOverItem itemFromDict:data];
    }
    
    return [JTShipItem itemsFromDict:data forKey:@"personalCommStats"];
}

@end
