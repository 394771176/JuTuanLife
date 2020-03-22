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

- (NSTimeInterval)current_server_time
{
    if (self.baseConfig && [self.baseConfig objectForKey:@"current_server_time"]) {
        return [self.baseConfig doubleForKey:@"current_server_time"];
    }
    return WCTimeIntervalWithSecondsSince1970();
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

- (NSString *)imageUrl:(NSString *)url forType:(JTImageType)type
{
    if (!url || !url.length) {
        return url;
    }
    
    /*=====================================================================================================
     "biz_conf_image.original_tpl" = "https://jutuan-small-dev.oss-cn-shanghai.aliyuncs.com/{image}";
     "biz_conf_image.square_big_tpl" = "https://jutuan-small-dev.oss-cn-shanghai.aliyuncs.com/{image}?x-oss-process=style/square_big";
     "biz_conf_image.square_middle_tpl" = "https://jutuan-small-dev.oss-cn-shanghai.aliyuncs.com/{image}?x-oss-process=style/square_middle";
     "biz_conf_image.square_small_tpl" = "https://jutuan-small-dev.oss-cn-shanghai.aliyuncs.com/{image}?x-oss-process=style/square_small";
     "biz_conf_image.square_tiny_tpl" = "https://jutuan-small-dev.oss-cn-shanghai.aliyuncs.com/{image}?x-oss-process=style/square_tiny";
     =====================================================================================================*/
    
    NSString *key = nil;
    switch (type) {
        case JTImageType80x80:
            key = @"biz_conf_image.square_tiny_tpl";
            break;
        case JTImageType160x160:
            key = @"biz_conf_image.square_small_tpl";
            break;
        case JTImageType240x240:
            key = @"biz_conf_image.square_middle_tpl";
            break;
        case JTImageType640x640:
            key = @"biz_conf_image.square_big_tpl";
            break;
        default:
            key = @"biz_conf_image.original_tpl";
            break;
    }
    
    NSString *imageUrl = nil;
    if (key) {
        imageUrl = [self.baseConfig objectForKey:imageUrl];
    }
    
    if (!imageUrl || [imageUrl rangeOfString:@"{image}"].length <= 0) {
        imageUrl = @"https://jutuan-small-dev.oss-cn-shanghai.aliyuncs.com/{image}";
    }
    return [imageUrl stringByReplacingOccurrencesOfString:@"{image}" withString:url];
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

+ (void)checkVersion:(void (^)(void))block
{
    /*
     "current_server_time" = 1584862623;
     "ios_jutuan_version.download_url" = "http://xxxxxxx/ios";
     "ios_jutuan_version.force_update_version" = "v1.0.0";
     "ios_jutuan_version.latest_version" = "v1.0.0";
     "ios_jutuan_version.size" = 4000000;
     "ios_jutuan_version.version_desc" = "1.0.0\U7248\U672c\U5185\U5bb9\U5982\U4e0b\Uff1a#1.\U521d\U59cb\U53d1\U5e03";
    */
    
}

@end
