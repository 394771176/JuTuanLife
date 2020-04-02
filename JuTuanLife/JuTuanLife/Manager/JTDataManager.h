//
//  JTDataManager.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTBaseConfig.h"

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

@property (nonatomic, strong) NSDictionary *shareDict;

SHARED_INSTANCE_H

//用户数据，基础配置关
+ (void)setupManager;

- (void)updateBaseConfig;

- (NSString *)imageUrl:(NSString *)url forType:(JTImageType)type;

- (NSString *)about_us_url;
- (NSString *)h5_domain_whitelist;
- (NSString *)deposit_deduct_text;

+ (void)checkVersion:(void (^)(void))block;

- (DTShareItem *)shareItem;

@end
