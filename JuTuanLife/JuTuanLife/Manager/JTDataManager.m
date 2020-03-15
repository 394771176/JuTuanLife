//
//  JTDataManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTDataManager.h"

@implementation JTDataManager

SHARED_INSTANCE_M

+ (void)setupManager
{
    [[self sharedInstance] updateBaseConfig];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)updateBaseConfig
{
    [JTService async:[JTUserRequest getBaseConfig] cacheKey:@"JTUserRequest_getBaseConfig" loadCache:^(WCDataResult *cache) {
        if (cache.success && [NSDictionary validDict:cache.data]) {
            self.baseConfig = cache.data;
        }
    } finish:^(WCDataResult *result) {
        if (result.success && [NSDictionary validDict:result.data]) {
            self.baseConfig = result.data;
        }
    }];
    [JTService async:[JTUserRequest getShareInfo] cacheKey:@"JTUserRequest_getShareInfo" loadCache:^(WCDataResult *cache) {
        if (cache.success && [NSDictionary validDict:cache.data]) {
            self.shareDict = cache.data;
        }
    } finish:^(WCDataResult *result) {
        if (result.success && [NSDictionary validDict:result.data]) {
            self.shareDict = result.data;
        }
    }];
}

- (DTShareItem *)shareItem
{
    DTShareItem *item = [DTShareItem new];
    if (self.shareDict) {
        item.title = [_shareDict stringForKey:@"title"];
        item.desc = [_shareDict stringForKey:@"desc"];
        item.imageUrl = [_shareDict stringForKey:@"image"];
        item.link = [_shareDict stringForKey:@"url"];
    } else {
        item.title = APP_DISPLAY_NAME;
        item.desc = @"邀请你加入";
        item.link = APP_DOWNLOAD_URL;
    }
    return item;
}

@end
