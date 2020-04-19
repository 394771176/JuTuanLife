//
//  JTDataManager.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTBaseConfig.h"
#import "DTShareItem.h"

#define JTIMAGEURL(url, type)   [[JTDataManager sharedInstance] imageUrl:url forType:type]

typedef NS_ENUM(NSUInteger, JTImageType) {
    JTImageTypeOrig,
    JTImageType80x80,
    JTImageType160x160,
    JTImageType240x240,
    JTImageType640x640,
};

@interface JTDataManager : NSObject

@property (nonatomic, assign) NSTimeInterval current_server_time;
@property (nonatomic, strong) NSDictionary *baseConfigDict;
@property (nonatomic, strong) JTBaseConfig *baseConfig;
@property (nonatomic, strong) JTVersionConfig *versionConfig;

@property (nonatomic, strong) NSDictionary *shareDict;

@property (nonatomic, assign) NSInteger currentPeriod;

SHARED_INSTANCE_H

//用户数据，基础配置关
+ (void)setupManager;

//基础配置
- (void)updateBaseConfig;

//分享数据
- (void)updateShareInfo;

//APP版本升级
- (void)checkAPPVersionForUpgrade;

- (NSString *)imageUrl:(NSString *)url forType:(JTImageType)type;

+ (void)checkVersion:(void (^)(void))block;

- (DTShareItem *)shareItem;

@end
