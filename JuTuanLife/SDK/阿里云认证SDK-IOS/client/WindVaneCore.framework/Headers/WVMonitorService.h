//
//  WVMonitorService.h
//  Basic
//
//  Created by 郑祯 on 2019/4/26.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVMonitorAPMProtocol <NSObject>

@optional

/**
 * 通过 APM 上报埋点。
 *
 * @param bizId      业务标识。
 * @param properties 埋点内容。
 * @param instanceId 唯一标识。
 */
+ (void)commitWithBizId:(NSString *)bizId properties:(NSDictionary<NSString *, NSString *> *)properties instanceId:(NSString *)instanceId;

@end

/**
 WVMonitor 模块的 API 服务类。
 */
@interface WVMonitorService : NSObject <WVMonitorAPMProtocol>

/**
 注册 WVAPM 类。
 */
+ (void)registerAPMClass:(Class<WVMonitorAPMProtocol>)class_APM;

/**
 获取 WVAPM 类。
 */
+ (Class<WVMonitorAPMProtocol>)registeredAPMClass;

@end
