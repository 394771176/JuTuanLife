//
//  JTBaseConfig.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCBaseKit/WCBaseKit.h>

typedef NS_ENUM(NSUInteger, JTVersionStatus) {
    JTVersionStatusNewest,
    JTVersionStatusNeedUpgrade,
    JTVersionStatusForceUpgrade,
};

@interface JTBaseConfig : WCBaseEntity

@property (nonatomic, strong) NSString *about_us_url;
@property (nonatomic, strong) NSArray *h5_domain_whitelist;
@property (nonatomic, strong) NSString *deposit_deduct_text;

@end

@interface JTVersionConfig : WCBaseEntity {
    
}

@property (nonatomic, strong) NSString *download_url;//下载地址
@property (nonatomic, strong) NSString *force_update_version;//强制升级版本
@property (nonatomic, strong) NSString *latest_version;//最新版本
@property (nonatomic, strong) NSString *version_desc;//版本描述
@property (nonatomic, strong) NSString *size;//安装包大小

//新版本 三天提醒一次，提示两次
- (void)saveAlertLatestVersion;

+ (void)checkVersion:(JTVersionConfig *)config withBlock:(void (^)(JTVersionStatus status))block;

@end

