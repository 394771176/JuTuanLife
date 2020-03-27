//
//  JTUserCenterModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserCenterModel.h"

@implementation JTUserCenterModel

- (NSString *)cacheKey
{
    return [NSString stringWithFormat:@"JTUserCenterModel_cacheKey_%@_%zd", _userNo, _period];
}

- (WCDataResult *)loadData
{
    WCDataResult *result = [JTService sync:[JTUserRequest get_performance_stats:_period userNo:_userNo]];
    
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    self.fenrun = [JTFenRunOverItem itemFromDict:data];
    return [JTFenRunOverItem itemsFromDict:data forKey:@"performanceStats"];
}

@end
