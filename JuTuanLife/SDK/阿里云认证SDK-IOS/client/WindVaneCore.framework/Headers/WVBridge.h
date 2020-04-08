/*
 * WVBridge.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVBridgeDelegate.h"
#import "WVBridgeProtocol.h"
#import <Foundation/Foundation.h>
#import <WindmillBridge/WMBridge.h>

/**
 * WVBridge 入口。
 */
@interface WVBridge : WMBridge

/**
 * 使用 WVBridge 调用环境和委托初始化。
 * 会对 delegate 做强引用。
 */
- (instancetype _Nonnull)initWithEnv:(id _Nullable)env withDelegate:(id<WVBridgeDelegate> _Nullable)delegate NS_DESIGNATED_INITIALIZER;

/**
 * 检查指定 URL 是否是 WVBridge 的协议。
 *
 * @param url 要检查的 URL。
 */
+ (BOOL)isBridgeProtocol:(NSURL * _Nullable)url;

#pragma mark - 注册全局 WVBridge

/**
 * 注册全局 WVBridge 处理器。
 *
 * @param name  处理器的名称，格式为 @"类名.方法名"。
 * @param block 处理器的执行 Block。
 */
+ (void)registerHandler:(NSString * _Nonnull)name withBlock:(WVBridgeHandler _Nonnull)block;

/**
 * 注册全局 WVBridge 处理器。
 * 可以在页面切换时做清理操作，仅会在调用了 handler 的页面调用，且只会调用一次。
 *
 * @param name       处理器的名称，格式为 @"类名.方法名"。
 * @param block      处理器的执行 Block。
 * @param resetBlock 处理器的重置 Block，用于在页面切换时做清理操作。
 */
+ (void)registerHandler:(NSString * _Nonnull)name withBlock:(WVBridgeHandler _Nonnull)block withResetBlock:(WVBridgeResetHandler _Nullable)resetBlock;

/**
 * 注册全局 WVBridge 类，类必须实现 WVBridgeProtocol。
 *
 * @param className   要注册到的类名。
 * @param bridgeClass 提供 WVBridge 实现的 Class，会根据 handlerName 反射调用其中的方法。
 */
+ (void)registerClassName:(NSString * _Nonnull)className withClass:(Class _Nonnull)bridgeClass;

/**
 * 注册全局 WVBridge 别名 @{ "类别名.方法别名" : "类名.方法名" }。
 * 注意别名为键，原始名为值。
 *
 * @code
 * NSDictionary * alias = @{
 *   @"类别名.方法别名": @"类名.方法名",
 *   @"aliasClassName.aliasHandlerName": @"className.handlerName"
 * };
 * [WVBridge registerAlias:alias];
 * @endcode
 */
+ (void)registerAlias:(NSDictionary<NSString *, NSString *> * _Nonnull)alias;

/**
 调用 WVBridge API。
 
 @param name     要执行的 Bridge 名称，格式为 @"类名.方法名"。
 @param params   要执行的 Bridge 参数。
 @param callback 此次 Bridge 调用的回调，会取代 delegate 的回调方法。可能在任意线程调用。
 */
- (void)callHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withCallback:(void (^ _Nullable)(NSString * _Nonnull ret, NSDictionary * _Nullable result))callback;

/**
 直接调用 WVBridge API。
 一般用于 Native 直接调用 UI 无关的 Bridge，不适合调用持续性的 Bridge，很容易相互影响。
 
 @param name     要执行的 Bridge 名称，格式为 @"类名.方法名"。
 @param params   要执行的 Bridge 参数。
 @param callback 此次 Bridge 调用的回调，可能在任意线程调用。
 */
+ (void)callHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withCallback:(void (^ _Nullable)(NSString * _Nonnull ret, NSDictionary * _Nullable result))callback;

@end
