//
//  JTShipListModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTShipListModel.h"

KEY(JTShipListModel_cacheKey)

@implementation JTShipListModel

- (NSString *)cacheKey
{
    return JTShipListModel_cacheKey;
}

- (NSString *)trait
{
    return [JTUserManager sharedInstance].ac_token;
}

- (void)loadCache
{
    [super loadCache];
}

- (WCDataResult *)loadData
{
    WCDataResult *result = [JTService sync:[JTUserRequest getShipList:self.pos pageSize:self.fetchLimit]];
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    [super parseData:data];
    if ([NSDictionary validDict:data]) {
        if (self.isReload || self.isLoadCache) {
            self.teachers = [JTShipItem itemsFromArray:[data objectForKey:@"masters"]];
            self.apprenticeNum = [data integerForKey:@"apprenticeNum"];
            self.masterNum = [data integerForKey:@"masterNum"];
        }
        return [JTShipItem itemsFromArray:[data objectForKey:@"apprentices"]];
    }
    return nil;
}

@end
