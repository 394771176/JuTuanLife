//
//  JTFenrunDetailModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/27.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserFenrunModel.h"

@implementation JTUserFenrunModel

- (NSString *)cacheKey
{
    return [NSString stringWithFormat:@"JTFenrunDetailModel_cachekey_%@_%zd", _userNo, _period];
}

- (WCDataResult *)loadData
{
    WCDataResult *result = [JTService sync:[JTUserRequest get_biz_contrib_commissions:_userNo dateType:_period date:_selectedDate]];
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    self.fenrun = [JTFenRunOverItem itemFromDict:data];
    return [JTFenRunOverItem itemsFromDict:data forKey:@"contribStats"];
}

@end
