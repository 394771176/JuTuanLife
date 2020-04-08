//
//  WMBridge+Advance.h
//  Bridge
//
//  Created by lianyu.ysj on 2017/7/15.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import "WMBridge.h"
#import "WMBridgeProtocol.h"
#import <Foundation/Foundation.h>

/**
 Bridge API 的类型。
 */
typedef NS_OPTIONS(NSUInteger, WMBridgeType) {
	WMBridgeTypeDefault = 0,         // 默认类型
	WMBridgeTypeThreadSafe = 1 << 1, // 线程安全的 API，允许在任意线程调用。
	WMBridgeTypeSecure = 1 << 2,     // 安全的 API，允许跳过 API 的权限检查，需要自行承担安全风险。
	WMBridgeTypeSync = 1 << 3,       // 允许同步调用的 API，无法保证同步处理器的线程，请自行做好线程安全的保护。
};

@protocol WMBridgeAdvanceProtocol <WMBridgeProtocol>

/**
 [慎用]对于实现 WMBridgeProtocol 的动态 WMBridge，会通过以下方法获取 API 的类型。
 
 @param methodName 要判断类型的方法名称。
 */
+ (WMBridgeType)getMethodType:(NSString * _Nonnull)methodName;

/**
 [慎用]对于实现 WMBridgeProtocol 的动态 WMBridge，会通过以下方法判断指定 API 是否是安全的，不会对返回 YES 的 API 做安全校验，需要自行承担安全风险。
 
 @param methodName 要检查的方法名称。
 */
+ (BOOL)isMethodSecure:(NSString * _Nonnull)methodName DEPRECATED_MSG_ATTRIBUTE("已废弃，请改为提供 +getMethodType: 方法");

@end

/**
 WMBridge 的同步处理器，无法保证同步处理器的线程，请自行做好线程安全的保护。

 @param params  WMBridge 调用方传入的参数对象。
 @param context WMBridge 的调用上下文。
 @return 要同步返回的值。
 */
typedef NSDictionary * _Nullable (^WMBridgeSyncHandler)(NSDictionary * _Nonnull params, id<WMBridgeContext> _Nonnull context) DEPRECATED_ATTRIBUTE;

/**
 【慎用】包含高级的 WMBridge 功能。
 */
@interface WMBridge (Advance)

/**
 注册全局 WMBridge 处理器。
 
 @param name  处理器的名称，格式为 @"类名.方法名"。
 @param type  处理器的类型，默认为 WMBridgeTypeDefault。
 @param block 处理器的执行 Block。
 */
+ (void)registerHandler:(NSString * _Nonnull)name withType:(WMBridgeType)type withBlock:(WMBridgeHandler _Nonnull)block;

/**
 注册私有 WMBridge 处理器。
 
 @param name  处理器的名称，格式为 @"类名.方法名"。
 @param type  处理器的类型，默认为 WMBridgeTypeDefault。
 @param block 处理器的执行 Block。
 */
- (void)registerHandler:(NSString * _Nonnull)name withType:(WMBridgeType)type withBlock:(WMBridgeHandler _Nonnull)block;

/**
 调用同步 WMBridge。
 
 @param name   要执行的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params 要执行的 WMBridge 字符串参数。
 @param callback 此次 WMBridge 调用的回调，会在方法执行完毕前同步调用。
 */
- (void)callSyncHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withCallback:(WMBridgeCallback _Nullable)callback;

#pragma mark - 已废弃，预计于 2019.5.1 移除

/**
 【慎用】注册同步全局 WMBridge 处理器，允许同步返回内容给 JS。

 @param name       处理器的名称，格式为 @"类名.方法名"。
 @param block      处理器的执行 Block。
 */
+ (void)registerSyncHandler:(NSString * _Nonnull)name withBlock:(WMBridgeSyncHandler _Nonnull)block DEPRECATED_MSG_ATTRIBUTE("已废弃，请改为 +registerHandler:withType:WMBridgeTypeSync withBlock: 方法");

/**
 【慎用】注册安全的全局 WMBridge 处理器，不会对此 API 做安全校验，需要自行承担安全风险。

 @param name       处理器的名称，格式为 @"类名.方法名"。
 @param block      处理器的执行 Block。
 @param resetBlock 处理器的重置 Block，用于在页面切换时做清理操作。
 */
+ (void)registerSecureHandler:(NSString * _Nonnull)name withBlock:(WMBridgeHandler _Nonnull)block withResetBlock:(WMBridgeResetHandler _Nullable)resetBlock DEPRECATED_MSG_ATTRIBUTE("已废弃，请改为 +registerHandler:withType:WMBridgeTypeSecure withBlock: 方法");

/**
 【慎用】注册安全的私有 WMBridge 处理器，不会对此 API 做安全校验，需要自行承担安全风险。

 @param name       处理器的名称，格式为 @"类名.方法名"。
 @param block      处理器的执行 Block。
 @param resetBlock 处理器的重置 Block，用于在页面切换时做清理操作。
 */
- (void)registerSecureHandler:(NSString * _Nonnull)name withBlock:(WMBridgeHandler _Nonnull)block withResetBlock:(WMBridgeResetHandler _Nullable)resetBlock DEPRECATED_MSG_ATTRIBUTE("已废弃，请改为 -registerHandler:withType:WMBridgeTypeSecure withBlock: 方法");

/**
 调用同步 WMBridge。

 @param name   要执行的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params 要执行的 WMBridge 字符串参数。
 @param reqId  此次 WMBridge 调用的唯一标识。

 @return 同步 WMBridge 的执行结果。
 */
- (NSDictionary * _Nullable)callSyncHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withReqId:(NSString * _Nullable)reqId DEPRECATED_MSG_ATTRIBUTE("已废弃，请改为 -callSyncHandler:withParams 方法");

@end
