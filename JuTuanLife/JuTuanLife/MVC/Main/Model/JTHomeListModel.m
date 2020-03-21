//
//  JTHomeListModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/19.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTHomeListModel.h"

@implementation JTHomeListModel

KEY(JTHomeListModel_cacheKey_fenrun)

- (NSString *)cacheKey
{
    return @"JTHomeListModel_cacheKey";
}

- (void)loadCache
{
    WCDataResult *result = [[BPCacheManager sharedInstance] cacheForKey:JTHomeListModel_cacheKey_fenrun];
    [self parseFenrunData:result.data];
    [super loadCache];
    
    if (self.data) {
        NSLog(@"%zd = %@", self.itemCount, self.data);
    }
}

- (NSString *)trait
{
    return [JTUserManager sharedInstance].ac_token;
}

- (WCDataResult *)loadData
{
    {
        WCDataResult *result = [JTService sync:[JTUserRequest get_all_commission_stats]];
        if (result.success) {
            [[BPCacheManager sharedInstance] setCache:result forKey:JTHomeListModel_cacheKey_fenrun trait:self.trait];
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
//    self.fenrun = [JTFenRunOverItem itemFromDict:data];
    self.fenrunForAll = [JTFenRunOverItem itemsFromDict:data forKey:@"stats"];
}

@end
