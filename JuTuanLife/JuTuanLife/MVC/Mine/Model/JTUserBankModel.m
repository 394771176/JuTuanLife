//
//  JTUserBankModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/29.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserBankModel.h"

@implementation JTUserBankModel

- (NSString *)cacheKey
{
    return @"JTUserBankModel_cachekey";
}

- (NSString *)trait
{
    return [JTUserManager sharedInstance].ac_token;
}

- (WCDataResult *)loadData
{
    WCDataResult *result = [JTService sync:[JTUserRequest get_bank_cards]];
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    return [JTUserBank itemsFromDict:data forKey:@"bankCards"];
}

@end
