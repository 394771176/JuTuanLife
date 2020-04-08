//
//  WMBridgeChecker.h
//  Bridge
//
//  Created by lianyu on 2018/4/5.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import "WMBridgeCheckerProtocol.h"
#import "WMBridgePermission.h"
#import "WMBridgeProtocol.h"
#import <Foundation/Foundation.h>

/**
 WMBridge 的检查器。
 */
@interface WMBridgeChecker : NSObject

/**
 注册指定的权限校验器。
 */
+ (void)registerChecker:(id<WMBridgeCheckerProtocol> _Nonnull)checker;

/**
 取消注册指定的权限校验器。
 */
+ (void)unregisterChecker:(id<WMBridgeCheckerProtocol> _Nonnull)checker;

/**
 检查指定 WMBridge 是否具有执行权限。

 @param apiName WMBridge 的名称，格式为 "类名.方法名"。
 @param params  WMBridge 的调用参数。
 @param context WMBridge 的执行上下文。

 @return 权限检查结果。
 */
+ (WMBridgePermission * _Nonnull)checkPermission:(NSString * _Nonnull)apiName withParams:(NSDictionary * _Nullable)params withContext:(id<WMBridgeContext> _Nonnull)context;

@end
