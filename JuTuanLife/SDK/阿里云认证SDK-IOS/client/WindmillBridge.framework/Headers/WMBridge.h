//
//  WMBridge.h
//  Bridge
//
//  Created by lianyu.ysj on 16/10/17.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WindmillWeaver/WindmillWeaver.h>

@protocol WMBridgeDelegate;

/**
 WMBridge 入口。
 */
@interface WMBridge : NSObject

/**
 绑定到的环境。
 WebView 环境下为 UIView<WVWebViewBasicProtocol> *；Weex 环境下为 WXSDKInstance。
 */
@property (nonatomic, weak, nullable) id env;

/**
 提供环境的相关信息。
 */
@property (nonatomic, copy, nullable) NSDictionary * envInfo;

/**
 绑定到的 UIView。
 */
@property (nonatomic, weak, nullable) UIView * view;

/**
 绑定到的 UIViewController。
 */
@property (nonatomic, weak, nullable) UIViewController * viewController;

/**
 WMBridge 调用方的当前来源 URL。
 */
@property (atomic, strong, nullable) NSURL * referrer;

/**
 当前页面的 ID，用于跟踪 WMBridge 调用情况。
 */
@property (nonatomic, copy, nullable) NSString * pageId;

/**
 是否启用 WMBridge，默认为 YES。
 */
@property (nonatomic, assign, getter=isOpen) BOOL open;

/**
 当前 WMBridge 可以使用的隔离环境。
 */
@property (nonatomic, strong, nullable) WMLIsolationEnv * isolationEnv;

/**
 Bridge 自身的信息，一般用于埋点，会一起通过埋点上传。
 */
@property (nonatomic, copy, nullable) NSDictionary * bridgeInfo;

/**
 使用 WMBridge 调用委托初始化。
 会对 delegate 做弱引用。
 */
- (instancetype _Nonnull)initWithDelegate:(id<WMBridgeDelegate> _Nullable)delegate NS_DESIGNATED_INITIALIZER;

/**
 使用 WMBridge 调用委托和父容器初始化。
 会对 delegate 做弱引用。
 */
- (instancetype _Nonnull)initWithDelegate:(id<WMBridgeDelegate> _Nullable)delegate withParent:(WMBridge * _Nullable)parent;

/**
 要求 WMBridge 对 delegate 做强引用。
 */
- (void)strongRefToDelegate;

@end

#import "WMBridgeProtocol.h"

@interface WMBridge (Register)

#pragma mark - 注册私有 WMBridge

/**
 注册私有 WMBridge 处理器。
 
 @param name  处理器的名称，格式为 @"类名.方法名"。
 @param block 处理器的执行 Block。
 */
- (void)registerHandler:(NSString * _Nonnull)name withBlock:(WMBridgeHandler _Nonnull)block;

/**
 注册私有 WMBridge 处理器。
 可以在页面切换时做清理操作，仅会在调用了 handler 的页面调用，且只会调用一次。
 
 @param name       处理器的名称，格式为 @"类名.方法名"。
 @param block      处理器的执行 Block。
 @param resetBlock 处理器的重置 Block，用于在页面切换时做清理操作。
 */
- (void)registerHandler:(NSString * _Nonnull)name withBlock:(WMBridgeHandler _Nonnull)block withResetBlock:(WMBridgeResetHandler _Nullable)resetBlock;

/**
 注册私有 WMBridge 别名 @{ "类别名.方法别名" : "类名.方法名" }。
 注意别名为键，原始名为值。
 
 @code
 NSDictionary * alias = @{
   @"类别名.方法别名": @"类名.方法名",
   @"aliasClassName.aliasHandlerName": @"className.handlerName"
 };
 [myBridge registerAlias:alias];
 @endcode
 */
- (void)registerAlias:(NSDictionary<NSString *, NSString *> * _Nonnull)alias;

#pragma mark - 调用 WMBridge

/**
 返回指定 WMBridge 是否已注册。
 
 @param name 要判断的 WMBridge 名称，格式为 @"类名.方法名"。
 */
- (BOOL)isHandlerRegistered:(NSString * _Nonnull)name;

/**
 调用 WMBridge。
 
 @param name   要执行的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params 要执行的 WMBridge 参数。
 @param reqId  此次 WMBridge 调用的唯一标识，如果为 nil 则认为此次调用不需要回调。
 */
- (void)callHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withReqId:(NSString * _Nullable)reqId;

/**
 调用 WMBridge。
 
 @param name    要执行的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params  要执行的 WMBridge 参数。
 @param reqId   此次 WMBridge 调用的唯一标识，如果为 nil 则认为此次调用不需要回调。
 @param timeout 此次调用的超时（秒），超时后会直接按照失败回调。
 */
- (void)callHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withReqId:(NSString * _Nullable)reqId withTimeout:(NSTimeInterval)timeout;

/**
 调用 WMBridge。
 
 @param name     要执行的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params   要执行的 WMBridge 参数。
 @param callback 此次 WMBridge 调用的回调，会取代 delegate 的回调方法。可能在任意线程调用。
 */
- (void)callHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withCallback:(WMBridgeCallback _Nullable)callback;

/**
 调用 WMBridge。
 
 @param name     要执行的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params   要执行的 WMBridge 参数。
 @param callback 此次 WMBridge 调用的回调，会取代 delegate 的回调方法。可能在任意线程调用。
 @param timeout  此次调用的超时（秒），超时后会直接按照失败回调。
 */
- (void)callHandler:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withCallback:(WMBridgeCallback _Nullable)callback withTimeout:(NSTimeInterval)timeout;

#pragma mark - Event

/**
 通过事件的方式通知所属 WMBridge 调用方，调用方可能不支持此功能。
 
 @param eventName 要发送的事件名称。
 @param param     要发送的事件参数，必须是可 JSON 序列化的数据类型。
 
 @return 事件是否发送成功。
 */
- (BOOL)dispatchEvent:(NSString * _Nonnull)eventName withParam:(id _Nullable)param;

/**
 通过事件的方式通知所属 WMBridge 调用方，调用方可能不支持此功能。
 
 @param eventName 要发送的事件名称。
 @param param     要发送的事件参数，必须是可 JSON 序列化的数据类型。
 @param callback  要获取事件是否被取消默认行为的回调。仅当事件被成功发送才会调用。
 
 @return 事件是否发送成功。
 */
- (BOOL)dispatchEvent:(NSString * _Nonnull)eventName withParam:(id _Nullable)param withCallback:(WMBEventCallback _Nullable)callback;

#pragma mark - WMBridge 生命周期

/**
 暂停 WMBridge Handler，一般在 UIViewController viewWillDisappear 时调用，用于降低 WMBridge API 的性能消耗，例如暂停播放音乐和持续性监听器等。
 */
- (void)pause;

/**
 恢复 WMBridge Handler，一般在 UIViewController viewWillAppear 时调用，用于恢复 WMBridge API 的性能，例如恢复播放音乐和持续性监听器等。
 */
- (void)resume;

/**
 重置 WMBridge Handler，一般在 View 被重置（例如 WebView 加载新页面）时调用，可以做一些清理工作。

 @param request View 重置后将要展示的请求。
 */
- (void)resetWithRequest:(NSURLRequest * _Nullable)request;

@end
