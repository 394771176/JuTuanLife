//
//  JTDataManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTDataManager.h"

@interface JTDataManager () {
    NSTimeInterval _markSetServerTime;
}

@end

@implementation JTDataManager

@synthesize current_server_time = _current_server_time;

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
//    if (self.baseConfig && [self.baseConfig objectForKey:@"current_server_time"]) {
//        return [self.baseConfig doubleForKey:@"current_server_time"];
//    }
    if (_current_server_time > 0) {
        return _current_server_time + (WCTimeIntervalWithSecondsSince1970() - _markSetServerTime);
    }
    return WCTimeIntervalWithSecondsSince1970();
}

- (void)setCurrent_server_time:(NSTimeInterval)current_server_time
{
    _markSetServerTime = WCTimeIntervalWithSecondsSince1970();
    _current_server_time = current_server_time;
}

- (void)setBaseConfigDict:(NSDictionary *)baseConfigDict
{
    if ([NSDictionary validDict:baseConfigDict]) {
        _baseConfigDict = baseConfigDict;
        self.baseConfig = [JTBaseConfig itemFromDict:baseConfigDict];
        self.versionConfig = [JTVersionConfig itemFromDict:baseConfigDict];
    }
}

- (void)updateBaseConfig
{
    [JTService async:[JTUserRequest getBaseConfig] cacheKey:@"JTUserRequest_getBaseConfig" loadCache:^(WCDataResult *cache) {
        if (cache.success) {
            self.baseConfigDict = cache.data;
        }
    } finish:^(WCDataResult *result) {
        if (result.success) {
            self.baseConfigDict = result.data;
            if ([self.baseConfigDict objectForKey:@"current_server_time"]) {
                self.current_server_time = [self.baseConfigDict doubleForKey:@"current_server_time"];
            }
        }
        [self checkAPPVersionForUpgrade];
    }];
}

- (void)updateShareInfo
{
    if (![JTUserManager sharedInstance].isLogined) {
        self.shareDict = nil;
        return;
    }
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
        imageUrl = [self.baseConfigDict objectForKey:imageUrl];
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

- (void)checkAPPVersionForUpgrade
{
    [JTVersionConfig checkVersion:self.versionConfig withBlock:^(JTVersionStatus status) {
        [JTDataManager showAppUpgradeAlert:self.versionConfig status:status];
    }];
}

+ (void)showAppUpgradeAlert:(JTVersionConfig *)config status:(JTVersionStatus)status
{
    if (status == JTVersionStatusNewest) {
        return ;
    }
    BOOL force = status == JTVersionStatusForceUpgrade;
    NSString *cancelTitle = nil;
    if (!force) {
        cancelTitle = @"取消";
    }
    
    [JTCoreUtil showAlertWithTitle:@"发现新版本" message:config.version_desc cancelTitle:cancelTitle confirmTitle:@"去更新" destructiveTitle:nil handler:^(UIAlertAction *action) {
        if (config.download_url.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:config.download_url]];
        }
        if (force) {
            [self showAppUpgradeAlert:config status:status];
        } else {
            [config saveAlertLatestVersion];
        }
    } cancel:^(UIAlertAction *action) {
        [config saveAlertLatestVersion];
    }];
}

@end
