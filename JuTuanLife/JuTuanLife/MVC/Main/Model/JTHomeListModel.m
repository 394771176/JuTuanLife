//
//  JTHomeListModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/19.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTHomeListModel.h"

@implementation JTHomeListModel

KEY(JTHomeListModel_cacheKey)
KEY(JTHomeListModel_cacheKey_fenrun)

- (NSString *)cacheKey
{
    return JTHomeListModel_cacheKey;
}


- (NSString *)cacheKeyFenrun
{
    return [NSString stringWithFormat:@"%@_%zd", JTHomeListModel_cacheKey_fenrun, _period];
}

- (void)loadCache
{
    WCDataResult *result = [[BPCacheManager sharedInstance] cacheForKey:[self cacheKeyFenrun]];
    [self parseFenrunData:result.data];
    [super loadCache];
}

- (NSString *)trait
{
    return [JTUserManager sharedInstance].ac_token;
}

- (WCDataResult *)loadData
{
    {
        WCDataResult *result = [JTService sync:[JTUserRequest get_commission_stats:_period]];
        if (result.success) {
            [[BPCacheManager sharedInstance] setCache:result forKey:[self cacheKeyFenrun]];
            [self parseFenrunData:result.data];
        }
    }
    WCDataResult *result = [JTService sync:[JTUserRequest get_business_list]];
    
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    NSArray *array = [JTBusinessItem itemsFromDict:data forKey:@"businesses"];
    return array;
}

- (void)parseFenrunData:(id)data
{
    self.fenrun = [JTFenRunOverItem itemFromDict:data];
}

@end
