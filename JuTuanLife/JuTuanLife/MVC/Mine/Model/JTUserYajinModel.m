//
//  JTUserYajinModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/2.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserYajinModel.h"

@implementation JTUserYajinModel

- (NSString *)cacheKey
{
    return @"JTUserYajinModel_cacheKey";
}

- (NSString *)trait
{
    return [JTUserManager sharedInstance].ac_token;
}

- (WCDataResult *)loadData
{
    WCDataResult *result = [JTService sync:[JTUserRequest get_user_deposit_logsWithPos:self.pos pageSize:self.fetchLimit]];
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    [super parseData:data];
    return [JTUserYajin itemsFromDict:data forKey:@"depositLogs"];
}

@end
