//
//  JTBusinessFenrunModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBusinessFenrunModel.h"

@implementation JTBusinessFenrunModel

- (NSString *)cacheKey
{
    return [NSString stringWithFormat:@"JTBusinessFenrunModel_cachekey_%@_%zd", _businessCode, _period];
}

- (WCDataResult *)loadData
{
    WCDataResult *result = [JTService sync:[JTUserRequest get_performance_details:_businessCode dateType:_period pos:self.pos pageSize:self.fetchLimit]];
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    if (self.isReload || self.isLoadCache) {
        self.businessFenRunTitle = [JTBusinessFenRunTitleItem itemFromDict:data];
    }
//    NSArray *array = [data objectForKey:@"performanceDetails"];
//    if ([NSArray validArray:array]) {
//        NSMutableArray *values = [NSMutableArray array];
//        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [values safeAddObject:[obj objectForKey:@"values"]];
//        }];
//        return [JTBusinessFenRunItem itemsFromArray:values];
//    }

    return [JTBusinessFenRunItem itemsFromDict:data forKey:@"performanceDetails"];
}

@end
