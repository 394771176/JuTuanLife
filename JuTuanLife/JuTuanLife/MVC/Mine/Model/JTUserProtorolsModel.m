//
//  JTUserProtorolsModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/29.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserProtorolsModel.h"

@implementation JTUserProtorolsModel

- (NSString *)cacheKey
{
    return @"JTUserProtorolsModel_cacheKey";
}

- (NSString *)trait
{
    return [JTUserManager sharedInstance].ac_token;
}

- (WCDataResult *)loadData
{
    WCDataResult *result = [JTService sync:[JTUserRequest get_signed_contracts]];
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    NSArray *array = [JTUserProtorols itemsFromDict:data forKey:@"contracts"];
    return [JTUserProtorols groupForDateWithItems:array];
}

@end
