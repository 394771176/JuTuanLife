//
//  WMBridge+Global.h
//  Bridge
//
//  Created by lianyu on 2018/4/9.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import "WMBridge.h"
#import <Foundation/Foundation.h>

/**
 WMBridge 全局方法。
 */
@interface WMBridge (Global)

#pragma mark - 注册全局 WMBridge

/**
 注册全局 WMBridge 处理器。
 
 @param name  处理器的名称，格式为 @"类名.方法名"。
 @param block 处理器的执行 Block。
 */
+ (void)registerHandler:(NSString * _Nonnull)name withBlock:(WMBridgeHandler _Nonnull)block;

/**
 注册全局 WMBridge 处理器。
 可以在页面切换时做清理操作，仅会在调用了 handler 的页面调用，且只会调用一次。
 
 @param name       处理器的名称，格式为 @"类名.方法名"。
 @param block      处理器的执行 Block。
 @param resetBlock 处理器的重置 Block，用于在页面切换时做清理操作。
 */
+ (void)registerHandler:(NSString * _Nonnull)name withBlock:(WMBridgeHandler _Nonnull)block withResetBlock:(WMBridgeResetHandler _Nullable)resetBlock;

/**
 注册全局 WMBridge 类，类必须实现 WMBridgeProtocol。
 这里注册的类，优先级比 className 的同名类要高。
 
 @param className   要注册到的类名。
 @param bridgeClass 提供 WMBridge 实现的 Class，会根据 handlerName 反射调用其中的方法。
 */
+ (void)registerClassName:(NSString * _Nonnull)className withClass:(Class _Nonnull)bridgeClass;

/**
 注册指定的 WMBridge 默认类，类必须实现 WMBridgeProtocol。
 这里注册的类，优先级比 className 的同名类要低。
 
 @param className   要注册到的类名。
 @param bridgeClass 提供 WMBridge 实现的 Class，会根据 handlerName 反射调用其中的方法。
 */
+ (void)registerClassName:(NSString * _Nonnull)className withDefaultClass:(Class _Nonnull)bridgeClass;

/**
 注册指定的 WMBridge 动态模块类，类必须实现 WMBridgeProtocol。

 @param moduleName    要注册到的模块名。
 @param className     提供模块实现的类名，会根据方法名反射调用其中的方法。
 @param frameworkPath 类所在的 framework 路径。
 @param isDefault     是否注册为默认实现。默认实现的优先级低于相同 moduleName 的其它类。
 */
+ (void)registerModuleName:(NSString * _Nonnull)moduleName withClassName:(NSString * _Nonnull)className inFramework:(NSString * _Nullable)frameworkPath isDefault:(BOOL)isDefault;

/**
 注册全局 WMBridge 别名 @{ "类别名.方法别名" : "类名.方法名" }。
 注意别名为键，原始名为值。
 
 @code
 NSDictionary * alias = @{
   @"类别名.方法别名": @"类名.方法名",
   @"aliasClassName.aliasHandlerName": @"className.handlerName"
 };
 [WMBridge registerAlias:alias];
 @endcode
 */
+ (void)registerAlias:(NSDictionary<NSString *, NSString *> * _Nonnull)alias;

#pragma mark 直接调用 WMBridge

/**
 直接调用 WMBridge。
 一般用于 Native 直接调用 UI 无关的 WMBridge，不适合调用持续性的 JSBridge，很容易相互影响。
 
 @param name     要执行的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params   要执行的 WMBridge 参数。
 @param callback 此次 WMBridge 调用的回调，可能在任意线程调用。
 */
+ (void)callHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withCallback:(WMBridgeCallback _Nullable)callback;

/**
 直接调用 WMBridge。
 一般用于 Native 直接调用 UI 无关的 WMBridge，不适合调用持续性的 JSBridge，很容易相互影响。
 
 @param name     要执行的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params   要执行的 WMBridge 参数。
 @param callback 此次 WMBridge 调用的回调，可能在任意线程调用。
 @param timeout  此次调用的超时（秒），超时后会直接按照失败回调。
 */
+ (void)callHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withCallback:(WMBridgeCallback _Nullable)callback withTimeout:(NSTimeInterval)timeout;

@end

#pragma mark - 内联方法定义

/**
 注册全局 WMBridge 处理器。
 
 @param name    处理器的名称，格式为 @"类名.方法名"。
 @param handler 处理器的执行 Block。
 */
NS_INLINE void WMBridgeRegisterHandler(NSString * _Nonnull name, WMBridgeHandler _Nonnull handler) {
	[WMBridge registerHandler:name withBlock:handler];
}

/**
 注册全局 WMBridge 别名 @{ "类别名.方法别名" : "类名.方法名" }。
 注意别名为键，原始名为值。
 */
NS_INLINE void WMBridgeRegisterAlias(NSDictionary<NSString *, NSString *> * _Nonnull alias) {
	[WMBridge registerAlias:alias];
}

/**
 注册全局 WMBridge 类，类必须实现 WMBridgeProtocol。
 这里注册的类，优先级比 className 的同名类要高。
 
 @param name        要注册到的类名。
 @param bridgeClass 提供 WMBridge 实现的 Class，会根据 handlerName 反射调用其中的方法。
 */
NS_INLINE void WMBridgeRegisterClass(NSString * _Nonnull name, Class _Nonnull bridgeClass) {
	[WMBridge registerClassName:name withClass:bridgeClass];
}

/**
 注册全局 WMBridge 类，类必须实现 WMBridgeProtocol。
 这里注册的类，优先级比 className 的同名类要低。
 
 @param name        要注册到的类名。
 @param bridgeClass 提供 WMBridge 实现的 Class，会根据 handlerName 反射调用其中的方法。
 */
NS_INLINE void WMBridgeRegisterDefaultClass(NSString * _Nonnull name, Class _Nonnull bridgeClass) {
	[WMBridge registerClassName:name withDefaultClass:bridgeClass];
}
