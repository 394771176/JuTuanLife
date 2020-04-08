//
//  WMBridgeProtocol.h
//  Bridge
//
//  Created by lianyu on 2018/4/9.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#ifndef WMBridgeProtocol_h
#define WMBridgeProtocol_h

#import <UIKit/UIKit.h>

/**
 WMBridge 提供了 Windmill/WindVane/Weex/Native 通用的 Bridge 协议。
 具体的教程可以参考文档 http://h5.alibaba-inc.com/windvane/JSBridge.html，此处作为快捷上手帮助。

 提供动态 WMBridge（对类名有要求，但无需注册，会自动反射查找）：
 [STEP 1] 令你要输出为服务的类实现 WMBridgeProtocol（引入头文件 <Windmill/WMBridgeProtocol.h>）。
 [STEP 2] [可选]根据需要重写 instanceScope 方法，设置实例的作用域，具体的定义参见 WMBridgeScope 枚举。
 [STEP 3] 你要输出的方法的命名需要遵循规范：
            -/+ (void)handlerName:(NSDictionary *)params withBridgeContext:(id<WMBridgeCallbackContext>)context
            其中 handlerName 即为你提供给 WMBridge 调用方的方法名称。
          · 第一个参数为 NSDictionary *，是 WMBridge 调用方传入的参数对象。
          · 第二个参数为 id<WMBridgeCallbackContext>，是 WMBridge 的调用上下文。
 [STEP 4] 在你的方法中，使用 [context callbackSuccess:RESULT]/[context callbackFailure:RET withResult:RESULT]
          来输出执行成功/失败的结果返回给 WMBridge 调用方。
 [STEP 5] 当你的 WMBridge API 逻辑执行完毕，可以主动调用 [context releaseHandler:self] 方法来主动释放内存，否则就只能等到页面销毁的时候才会释放。
          注意在 dealloc 中调用 [context releaseHandler:self] 是没有意义的，因此此时对象已经被释放了。

 提供普通 WMBridge（需要注册才能够使用）：
 · 使用 WMBridgeRegisterHandler 注册全局 WMBridge 处理器；
 · 使用 WMBridgeRegisterAlias 注册全局 WMBridge 别名；
 · 使用 WMBridgeRegisterClass 注册全局 WMBridge 类；

 [注意] 1. WMBridge 总是在主线程调用，如果有耗时操作，请务必自行切换线程。
       2. 可能你提供的服务带有多个阶段输出性，请使用 [context dispatchEvent:eventName withParam:param] 将结果通过事件的方式输出给 WMBridge 调用方。
 */

// 根据是否依赖 Windmill，决定是直接调用还是反射调用，可以单独引入 WMBridgeProtocol.h 而不直接依赖 Windmill。
#if __has_include(<WindmillBridge/WMBridgeConstants.h>)

// 依赖 Windmill 的话，常量在 <WindmillBridge/WMBridgeConstants.h> 中声明。
#import <WindmillBridge/WMBridgeConstants.h>

#else

#pragma mark - WMBridge Status

/**
 表示 WMBridge 的回调状态。
 */
typedef NSString * WMBridgeStatus NS_EXTENSIBLE_STRING_ENUM;

/**
 表示 WMBridge API 执行成功（不允许设置为失败回调的返回值）。
 */
#define WMBridgeStatusSuccess       @"SUCCESS"

/**
 表示 WMBridge API 传入参数错误。
 */
#define WMBridgeStatusParamError    @"PARAM_ERR"

/**
 表示 WMBridge API 执行失败。
 */
#define WMBridgeStatusFailed        @"FAILED"

/**
 表示 WMBridge API 执行出现异常。
 */
#define WMBridgeStatusException     @"EXCEPTION"

/**
 表示 WMBridge API 功能不被支持。
 */
#define WMBridgeStatusNotSupported  @"NOT_SUPPORTED"

/**
 表示 WMBridge API 缺少用户权限。
 */
#define WMBridgeStatusUserDenied    @"USER_DENIED"

/**
 表示 WMBridge API 的执行被用户取消。
 */
#define WMBridgeStatusUserCancelled @"USER_CANCELLED"

#pragma mark WMBridge Callback

/**
 标准返回数据：消息（字符串）。
 */
#define WMBridgeResultMessageName @"message"

/**
 标准返回数据：错误码（数字）。
 */
#define WMBridgeResultErrorName   @"error"

// Windmill 的环境信息。
#pragma mark WMBridge Env Info

/**
 envInfo 中 UserAgent 信息的键。
 */
#define WMBridgeEnvInfoUserAgentKey @"userAgent"

#endif /* __has_include */

/**
 WMBridge API 执行结果的回调。
 
 @param status 执行结果。
 @param result 执行结果的数据。
 */
typedef void (^WMBridgeCallback)(WMBridgeStatus _Nonnull status, NSDictionary * _Nullable result);

/**
 WMBridge 发送事件的回调，用于了解事件的默认行为是否被阻止。
 
 @param eventName      发送的事件名称。
 @param preventDefault 事件的默认行为是否被阻止。
 */
typedef void (^WMBEventCallback)(NSString * _Nonnull eventName, BOOL preventDefault);

#pragma mark - WMBridge Context

@protocol WVWebViewBasicProtocol;
@class WXSDKInstance;
@class WMLIsolationEnv;

/**
 动态 WMBridge API 上下文的 Protocol。
 所有方法都是线程安全的。
 */
@protocol WMBridgeContext <NSObject>

@required

#pragma mark Environment

/**
 当前 WMBridge API 的来源 URL。
 */
@property (nonatomic, strong, readonly, nullable) NSURL * referrer;

/**
 提供环境的相关信息。
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary * envInfo;

/**
 当前 WMBridge API 绑定到的 UIView。
 */
@property (nonatomic, weak, readonly, nullable) UIView * view;

/**
 当前 WMBridge API 绑定到的 UIViewController。
 */
@property (nonatomic, weak, readonly, nullable) UIViewController * viewController;

/**
 当前 WMBridge API 绑定到的环境，不同环境下会返回不同的值。
 WebView 环境下为 UIView<WVWebViewBasicProtocol> *；Weex 环境下为 WXSDKInstance。
 */
@property (nonatomic, weak, readonly, nullable) id env;

/**
 当前 WMBridge API 绑定到的 WebView 环境，如果不是 WebView 环境则为 nil。
 */
@property (nonatomic, weak, readonly, nullable) UIView<WVWebViewBasicProtocol> * webViewEnv;

/**
 当前 WMBridge API 绑定到的 Weex 环境，如果不是 Weex 环境则为 nil。
 */
@property (nonatomic, weak, readonly, nullable) WXSDKInstance * weexEnv;

/**
 当前 WMBridge 可以使用的隔离环境。
 */
@property (nonatomic, strong, readonly, nullable) WMLIsolationEnv * isolationEnv;

/**
 Bridge 自身的信息，一般用于埋点，会一起通过埋点上传。
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary * bridgeInfo;

#pragma mark Event

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

/**
 向容器发送指定通知。

 @param name 要发送的通知名称。
 @param userInfo 要发送的通知额外信息。
 */
- (void)postNotificationName:(NSString * _Nonnull)name userInfo:(NSDictionary * _Nullable)userInfo;

#pragma mark Function

/**
 移除动态 WMBridge API 的实例，仅在动态 WMBridge 将要销毁当前实例时使用。
 */
- (void)releaseHandler:(id _Nonnull)instance;

@end

/**
 WMBridge 的回调策略。
 */
typedef NS_ENUM(NSUInteger, WMBridgeCallbackPolicy) {
	/**
	 仅回调一次。
	 会忽略多余的回调；如果未回调，也会主动补充一个成功回调。
	 */
	WMBridgeCallbackOnce,
	/**
	 允许不回调或回调一次。
	 会忽略多余的回调。
	 */
	WMBridgeCallbackZeroOrOnce,
	/**
	 允许不回调或回调任意次数。
	 */
	WMBridgeCallbackMultiTimes,
};

/**
 动态 WMBridge API 回调上下文的 Protocol。
 所有方法都是线程安全的。
 */
@protocol WMBridgeCallbackContext <WMBridgeContext>

@required

/**
 此次调用使用的参数。
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary * params;

/**
 此次调用的回调策略，默认为 WMBridgeCallbackOnce。
 */
@property (nonatomic, assign) WMBridgeCallbackPolicy callbackPolicy;

/**
 调用是否需要持续性调用，等价与 context.callbackPolicy = WMBridgeCallbackMultiTimes。
 */
@property (nonatomic, assign, getter=isKeepAlive) BOOL keepAlive;

#pragma mark Callback

/**
 将成功信息和指定数据回调给 WMBridge 调用方。

 @param result 执行的结果数据。

 @return 如果可以回调，则为 YES；若此时页面已关闭，或已经回调过（未设置 keepAlive），则为 NO。
 */
- (BOOL)callbackSuccess:(NSDictionary * _Nullable)result;

/**
 将指定失败返回代码和数据回调给 WMBridge 调用方。

 @param status WMBridge 的执行状态，请使用上面定义的 WMBridgeStatus。
 @param result 执行的结果数据。

 @return 如果可以回调，则为 YES；若此时页面已关闭，或已经回调过，则为 NO。
 */
- (BOOL)callbackFailure:(WMBridgeStatus _Nonnull)status withResult:(NSDictionary * _Nullable)result;

/**
 将指定失败返回代码和消息回调给 WMBridge 调用方。
 是 [callbackFailure:ret withResult:@{ @"message": message }] 的快捷包装。

 @param status  WMBridge 的执行结果，请使用上面定义的 WMBridgeStatus。
 @param message 执行的结果消息。

 @return 如果可以回调，则为 YES；若此时页面已关闭，或已经回调过，则为 NO。
 */
- (BOOL)callbackFailure:(WMBridgeStatus _Nonnull)status withMessage:(NSString * _Nullable)message, ... NS_FORMAT_FUNCTION(2,3);

/**
 将指定失败返回代码和错误信息回调给 WMBridge 调用方。

 @param status WMBridge 的执行结果，请使用上面定义的 WMBridgeStatus。
 @param error  错误信息。

 @return 如果可以回调，则为 YES；若此时页面已关闭，或已经回调过，则为 NO。
 */
- (BOOL)callbackFailure:(WMBridgeStatus _Nonnull)status withError:(NSError * _Nullable)error;

/**
 将指定无效参数的代码和消息回调给 WMBridge 调用方。
 是 [callbackFailure:WMBridgeStatusParamError withResult:@{ @"message": @"Invalid parameter {name}: {message}" }] 的快捷包装。

 @param name    无效的参数。
 @param message 参数无效的其它消息。

 @return 如果可以回调，则为 YES；若此时页面已关闭，或已经回调过，则为 NO。
 */
- (BOOL)callbackInvalidParameter:(NSString * _Nullable)name withMessage:(NSString * _Nullable)message, ... NS_FORMAT_FUNCTION(2,3);

/**
 将功能不被支持的的代码和消息回调给 WMBridge 调用方。
 是 [callbackFailure:WMBridgeStatusNotSupported withResult:@{ @"message": @"{className}.{methodName} not supported: {message}" }] 的快捷包装。

 @param message 功能不被支持的其它消息。

 @return 如果可以回调，则为 YES；若此时页面已关闭，或已经回调过，则为 NO。
 */
- (BOOL)callbackNotSupported:(NSString * _Nullable)message, ... NS_FORMAT_FUNCTION(1,2);

#pragma mark Function

/**
 重定向到其它 WMBridge，用于在当前 WMBridge 中转为调用其它 WMBridge，重定向后的结果会直接回调到调用方。

 @param name           要重定向的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params         要重定向的 WMBridge 参数。

 @return 如果可以重定向，则为 YES；若此时页面已关闭、已经回调过或已经重定向过，则为 NO。
 */
- (BOOL)redirect:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params;

/**
 重定向到其它 WMBridge，用于在当前 WMBridge 中转为调用其它 WMBridge，重定向后的结果会直接回调到调用方。

 @param name             要重定向的 WMBridge 名称，格式为 @"类名.方法名"。
 @param params           要重定向的 WMBridge 参数。
 @param resultCallback   重定向后 WMBridge 的执行结果回调，仅作结果通知，无法对返回值做修改。
 @param ignorePermission 是否忽略对其它 WMBridge 的权限校验，如果忽略的话请保证非安全页面不会调用到 WMBridge。
 
 @return 如果可以重定向，则为 YES；若此时页面已关闭、已经回调过或已经重定向过，则为 NO。
 */
- (BOOL)redirect:(NSString * _Nonnull)name withParams:(NSDictionary * _Nullable)params withResultCallback:(WMBridgeCallback _Nullable)resultCallback isIgnorePermission:(BOOL)ignorePermission;

@optional

/**
 已废弃，仅用于旧 API 兼容，实际使用时请使用 callbackSuccess/callbackFailure 系列方法。
 */
@property (nonatomic, copy, readonly, nonnull) WMBridgeCallback callbackBlock DEPRECATED_MSG_ATTRIBUTE("已废弃，仅用做旧版本兼容。请替换为 callbackSuccess/callbackFailure 系列方法");

@end

/**
 WMBridge 的处理器。
 
 @param params  WMBridge 调用方传入的参数对象。
 @param context WMBridge 的调用上下文。
 */
typedef void (^WMBridgeHandler)(NSDictionary * _Nullable params, id<WMBridgeCallbackContext> _Nonnull context);

/**
 WMBridge 的重置处理器。
 用于在页面切换时做清理操作，仅会在调用了 handler 的页面调用，且只会调用一次。
 
 @param context WMBridge 的调用上下文。
 */
typedef void (^WMBridgeResetHandler)(id<WMBridgeContext> _Nonnull context);

#pragma mark - WMBridgeProtocol

/**
 动态 WMBridge 的实例作用域。
 */
typedef NS_ENUM(NSUInteger, WMBridgeScope) {
	/**
	 调用级作用域，每次 WMBridge 调用都使用不同的实例。
	 */
	WMBridgeScopeInvocation,
	/**
	 页面作用域，同一个页面中的 WMBridge 调用都使用同一个实例。
	 */
	WMBridgeScopePage,
	/**
	 View 作用域，同一个 View 中的 WMBridge 调用都使用同一个实例，如果同一个 View 中可能切换多个页面，它们也将共用实例。
	 */
	WMBridgeScopeView,
	/**
	 全局作用域，所有 WMBridge 调用都使用同一个实例。
	 */
	WMBridgeScopeStatic,
};

/**
 动态 WMBridge API 需要实现的 Protocol。
 */
@protocol WMBridgeProtocol <NSObject>

@optional

/**
 WMBridge API 实例的作用域，默认为 WMBridgeScopeInvocation。
 */
+ (WMBridgeScope)instanceScope;

/**
 返回当前类中指定 WMBridge API 方法是否是线程安全的，请保证为相同方法名总是返回相同的结果。
 如果是线程安全的，此方法可能会在后台线程执行，而不是在主线程执行。注意**不允许阻塞后台线程**，避免影响其它 JSBridge 的执行。

 @param methodName 要检查的方法名称。
 */
+ (BOOL)isThreadSafe:(NSString * _Nonnull)methodName;

/**
 WMBridge 的执行上下文，会自动设置进去。
 */
@property (nonatomic, weak, nullable) id<WMBridgeContext> context;

/**
 重置处理器 - 该方法将会在加载新页面时调用，可以做一些清理工作。

 @param context WMBridge 被重置时的上下文。
 @param request 要加载的新页面。
 */
- (void)resetWithContext:(id<WMBridgeContext> _Nonnull)context withNextRequest:(NSURLRequest * _Nullable)request;

/**
 暂停处理器 - 该方法将会在 UIViewController viewWillDisappear 时调用，用于降低 WMBridge API 的性能消耗，例如暂停播放音乐和持续性监听器等。
 不会对 WMBridgeScopeStatic 作用域的 WMBridge 调用。

 @param context WMBridge 被暂停时的上下文。
 */
- (void)pauseWithContext:(id<WMBridgeContext> _Nonnull)context;

/**
 恢复处理器 - 该方法将会在 UIViewController viewWillAppear 时调用，用于恢复 WMBridge API 的性能，例如恢复播放音乐和持续性监听器等。
 不会对 WMBridgeScopeStatic 作用域的 WMBridge 调用。
 
 @param context WMBridge 被恢复时的上下文。
 */
- (void)resumeWithContext:(id<WMBridgeContext> _Nonnull)context;

@end

// 根据是否依赖 Windmill，决定是直接调用还是反射调用，可以单独引入 WMBridgeProtocol.h 而不直接依赖 Windmill。
#if __has_include(<WindmillBridge/WMBridge+Global.h>)

// 直接调用的话，方法在 <WindmillBridge/WMBridge+Global.h> 中声明。
#import <WindmillBridge/WMBridge+Global.h>

#else

/**
 注册全局 WMBridge 处理器。

 @param name    处理器的名称，格式为 @"类名.方法名"。
 @param handler 处理器的执行 Block。
 */
NS_INLINE void WMBridgeRegisterHandler(NSString * _Nonnull name, WMBridgeHandler _Nonnull handler) {
	Class WMBridge = NSClassFromString(@"WMBridge");
	if (WMBridge) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
		[WMBridge performSelector:NSSelectorFromString(@"registerHandler:withBlock:") withObject:name withObject:handler];
#pragma GCC diagnostic pop
	}
}

/**
 注册全局 WMBridge 别名 @{ "类别名.方法别名" : "类名.方法名" }。
 注意别名为键，原始名为值。
 */
NS_INLINE void WMBridgeRegisterAlias(NSDictionary<NSString *, NSString *> * _Nonnull alias) {
	Class WMBridge = NSClassFromString(@"WMBridge");
	if (WMBridge) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
		[WMBridge performSelector:NSSelectorFromString(@"registerAlias:") withObject:alias];
#pragma GCC diagnostic pop
	}
}

/**
 注册全局 WMBridge 类，类必须实现 WMBridgeProtocol。
 这里注册的类，优先级比 className 的同名类要高。
 
 @param name        要注册到的类名。
 @param bridgeClass 提供 WMBridge 实现的 Class，会根据 handlerName 反射调用其中的方法。
 */
NS_INLINE void WMBridgeRegisterClass(NSString * _Nonnull name, Class _Nonnull bridgeClass) {
	Class WMBridge = NSClassFromString(@"WMBridge");
	if (WMBridge) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
		[WMBridge performSelector:NSSelectorFromString(@"registerClassName:withClass:") withObject:name withObject:bridgeClass];
#pragma GCC diagnostic pop
	}
}

/**
 注册全局 WMBridge 类，类必须实现 WMBridgeProtocol。
 这里注册的类，优先级比 className 的同名类要低。
 
 @param name        要注册到的类名。
 @param bridgeClass 提供 WMBridge 实现的 Class，会根据 handlerName 反射调用其中的方法。
 */
NS_INLINE void WMBridgeRegisterDefaultClass(NSString * _Nonnull name, Class _Nonnull bridgeClass) {
	Class WMBridge = NSClassFromString(@"WMBridge");
	if (WMBridge) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
		[WMBridge performSelector:NSSelectorFromString(@"registerClassName:withDefaultClass:") withObject:name withObject:bridgeClass];
#pragma GCC diagnostic pop
	}
}

#endif /* __has_include */

#endif /* WMBridgeProtocol_h */
