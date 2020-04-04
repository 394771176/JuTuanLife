//
//  JTBaseConfig.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBaseConfig.h"

@implementation JTBaseConfig

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.about_us_url = [dic stringForKey:@"app_jutuan_conf.about_us_url"];
    NSString *whiteListStr = [dic objectForKey:@"app_jutuan_conf.h5_domain_whitelist"];
    if (whiteListStr.length) {
        NSMutableArray *whiteList = [whiteListStr componentsSeparatedByString:@","].mutableCopy;
        [whiteList removeObject:@""];
        self.h5_domain_whitelist = whiteList;
    }
    self.deposit_deduct_text = [dic stringForKey:@"app_jutuan_conf.deposit_deduct_text"];
    
    return YES;
}

@end

@implementation JTVersionConfig

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    /*
     "current_server_time" = 1584862623;
     "ios_jutuan_version.download_url" = "http://xxxxxxx/ios";
     "ios_jutuan_version.force_update_version" = "v1.0.0";
     "ios_jutuan_version.latest_version" = "v1.0.0";
     "ios_jutuan_version.size" = 4000000;
     "ios_jutuan_version.version_desc" = "1.0.0\U7248\U672c\U5185\U5bb9\U5982\U4e0b\Uff1a#1.\U521d\U59cb\U53d1\U5e03";
     */
    self.download_url = [dic stringForKey:@"ios_jutuan_version.download_url"];
    self.force_update_version = [dic stringForKey:@"ios_jutuan_version.force_update_version"];
    self.latest_version = [dic stringForKey:@"ios_jutuan_version.latest_version"];
    self.version_desc = [dic stringForKey:@"ios_jutuan_version.version_desc"];
    self.size = [dic stringForKey:@"ios_jutuan_version.size"];
    
    if (self.latest_version) {
        self.latest_version = [self.latest_version.lowercaseString stringByReplacingOccurrencesOfString:@"v" withString:@""];
    }
    
    if (self.force_update_version) {
        self.force_update_version = [self.force_update_version.lowercaseString stringByReplacingOccurrencesOfString:@"v" withString:@""];
    }
    
    if (!_download_url) {
        _download_url = APP_DOWNLOAD_URL;
    }
#ifdef DEBUG
    _latest_version = @"1.1.1";
#endif
    return YES;
}

KEY(saveAlertLatestVersion);

- (void)saveAlertLatestVersion
{
    NSInteger count = 0;
    NSString *saveLatest = [[DTTodayManager sharedInstance] objectForKey:saveAlertLatestVersion];
    if (saveLatest && [saveLatest isEqualToString:self.latest_version]) {
        [[DTTodayManager sharedInstance] updateDayForKey:saveAlertLatestVersion];
        count = [[BPAppPreference sharedInstance] integerForKey:saveAlertLatestVersion];
    } else {
        [[DTTodayManager sharedInstance] setObject:self.latest_version forKey:saveAlertLatestVersion];
    }
    [[BPAppPreference sharedInstance] setInteger:count + 1 forKey:saveAlertLatestVersion];
}

+ (void)checkVersion:(JTVersionConfig *)config withBlock:(void (^)(JTVersionStatus))block
{
    NSInteger version = [self versionValue:APP_VERSION_SHORT];
    NSInteger latest = [self versionValue:config.latest_version];
    NSInteger force = [self versionValue:config.force_update_version];
    JTVersionStatus status = JTVersionStatusNewest;
    if (version < force) {
        status = JTVersionStatusForceUpgrade;
    } else if (version < latest) {
        NSInteger count = 0;
        BOOL showOnceForThreeDay = YES;
        NSString *saveLatest = [[DTTodayManager sharedInstance] objectForKey:saveAlertLatestVersion];
        if (saveLatest && [saveLatest isEqualToString:config.latest_version]) {
            showOnceForThreeDay = [[DTTodayManager sharedInstance] isValidKeyEX:saveAlertLatestVersion forDays:2];
            count = [[BPAppPreference sharedInstance] integerForKey:saveAlertLatestVersion];
        }
        if (count < 2 && showOnceForThreeDay) {
            status = JTVersionStatusNeedUpgrade;
        }
    }
    if (block) {
        block(status);
    }
}

+ (NSInteger)versionValue:(NSString *)version
{
    if (!version) {
        return 0;
    }
    return [[version stringByReplacingOccurrencesOfString:@"." withString:@"0"] integerValue];
}

@end
