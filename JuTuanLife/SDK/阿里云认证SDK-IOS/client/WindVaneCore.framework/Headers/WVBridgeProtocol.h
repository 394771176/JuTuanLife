/*
 * WVBridgeProtocol.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <WindmillBridge/WMBridgeProtocol.h>

/**
 WVBridge 提供了 WebView/Weex/Native 通用的 Bridge 协议。
 具体的教程可以参考 WindVane 的版本正式文档 http://h5.alibaba-inc.com/windvane/JSBridge.html，此处作为快捷上手帮助。

 提供动态 WVBridge（对类名有要求，但无需注册，会自动反射查找）：
 [STEP 1] 令你要输出为服务的类实现 WVBridgeProtocol（引入头文件 <WindVane/WVBridgeProtocol.h>）。
 [STEP 2] [可选]根据需要重写 instanceScope 方法，设置实例的作用域，具体的定义参见 WVBridgeScope 枚举。
 [STEP 3] 你要输出的方法的命名需要遵循规范：
            -/+ (void)handlerName:(NSDictionary *)params withWVBridgeContext:(id<WVBridgeCallbackContext>)context
            其中 handlerName 即为你提供给 WVBridge 调用方的方法名称。
          · 第一个参数为 NSDictionary *，是 WVBridge 调用方传入的参数对象。
          · 第二个参数为 id<WVBridgeCallbackContext>，是 WVBridge 的调用上下文。
 [STEP 4] 在你的方法中，使用 [context callbackSuccess:RESULT]/[context callbackFailure:RET withResult:RESULT]
          来输出执行成功/失败的结果返回给 WVBridge 调用方。
 [STEP 5] 当你的 WVBridge API 逻辑执行完毕，可以主动调用 [context releaseHandler:self] 方法来主动释放内存，否则就只能等到页面销毁的时候才会释放。
          注意在 dealloc 中调用 [context releaseHandler:self] 是没有意义的，因此此时对象已经被释放了。

 提供普通 WVBridge（需要注册才能够使用）：
 · 使用 WVRegisterBridge 宏注册全局 WVBridge 处理器；
 · 使用 WVRegisterBridgeAlias 宏注册全局 WVBridge 别名；
 · 使用 WVRegisterBridgeClass 宏注册全局 WVBridge 类；

 [注意] 1. WVBridge 总是在主线程调用，如果有耗时操作，请务必自行切换线程。
       2. 可能你提供的服务带有多个阶段输出性，请使用 [context dispatchEvent:eventName withParam:param] 将结果通过事件的方式输出给 WVBridge 调用方。
 */

/**
 WVBridge 发送事件的回调，用于了解事件的默认行为是否被阻止。
 */
typedef WMBEventCallback WVEventCallback;

#pragma mark - WVBridge Context

@protocol WVWebViewBasicProtocol;
@class WXSDKInstance;

/**
 动态 WVBridge API 上下文的 Protocol。
 所有方法都是线程安全的。
 */
@protocol WVBridgeContext <WMBridgeContext>
@end

#pragma mark - WVBridge Callback Context

// clang-format off

/**
 WVBridge API 执行结果的回调。
 */
typedef WMBridgeCallback WVBridgeCallback;

/**
 表示 WVBridge API 执行成功（不允许设置为失败回调的返回值）。
 */
#define MSG_RET_SUCCESS       @"HY_SUCCESS"

/**
 表示 WVBridge API 传入参数错误。
 */
#define MSG_RET_PARAM_ERR     @"HY_PARAM_ERR"

/**
 表示 WVBridge API 执行失败。
 */
#define MSG_RET_FAILED        @"HY_FAILED"

/**
 表示 WVBridge API 执行出现异常。
 */
#define MSG_RET_EXCEPTION     @"HY_EXCEPTION"

/**
 表示 WVBridge API 功能不被支持。
 */
#define MSG_RET_NOT_SUPPORTED @"HY_NOT_SUPPORTED"

/**
 表示 WVBridge API 缺少用户权限。
 */
#define MSG_RET_USER_DENIED   @"HY_USER_DENIED"

/**
 表示 WVBridge API 的执行被用户取消。
 */
#define MSG_RET_USER_CANCELED @"HY_USER_CANCELLED"

#pragma mark WVBridge Result Key Constants

/**
 标准返回数据：消息。
 */
#define MSG_RESULT_MSG_NAME  @"msg"

/**
 标准返回数据：错误码。
 */
#define MSG_RESULT_ERROR_NAME  @"error"

/**
 动态 WVBridge API 回调上下文的 Protocol。
 所有方法都是线程安全的。
 */
@protocol WVBridgeCallbackContext <WMBridgeCallbackContext, WVBridgeContext>
@end

#pragma mark - WVBridgeProtocol

/**
 动态 WVBridge 的实例作用域。
 */
typedef WMBridgeScope WVBridgeScope;
enum {
	WVBridgeScopeInvocation = WMBridgeScopeInvocation,
	WVBridgeScopePage = WMBridgeScopePage,
	WVBridgeScopeView = WMBridgeScopeView,
	WVBridgeScopeStatic = WMBridgeScopeStatic,
};

/**
 动态 WVBridge API 需要实现的 Protocol。
 */
@protocol WVBridgeProtocol <WMBridgeProtocol>

@optional

/**
 WVBridge API 实例的作用域，默认为 WVBridgeScopeInvocation。
 */
+ (WMBridgeScope)instanceScope;

/**
 返回当前类中指定 WVBridge API 方法是否是线程安全的，请保证为相同方法名总是返回相同的结果。
 如果是线程安全的，此方法可能会在后台线程执行，而不是在主线程执行。注意**不允许阻塞后台线程**，避免影响其它 JSBridge 的执行。

 @param methodName 要检查的方法名称。
 */
+ (BOOL)isThreadSafe:(NSString * _Nonnull)methodName;

@end

#pragma mark - WVBridgeHandler

/**
 WVBridge 的处理器。
 */
typedef WMBridgeHandler WVBridgeHandler;

/**
 WVBridge 的重置处理器。
 用于在页面切换时做清理操作，仅会在调用了 handler 的页面调用，且只会调用一次。
 */
typedef WMBridgeResetHandler WVBridgeResetHandler;

/**
 注册全局 WVBridge 处理器。

 @param NAME  处理器的名称，格式为 @"类名.方法名"。
 @param BLOCK 处理器的执行 Block。
 */
#define WVBridgeRegisterHandler(NAME, BLOCK) WMBridgeRegisterHandler(NAME, BLOCK)

/**
 注册全局 WVBridge 别名 @{ "类别名.方法别名" : "类名.方法名" }。
 注意别名为键，原始名为值。
 */
#define WVBridgeRegisterAlias(ALIAS) WMBridgeRegisterAlias(ALIAS)

/**
 注册全局 WVBridge 类。
 
 @param NAME  要注册到的类名。
 @param CLASS 提供 WVBridge 实现的 Class，会根据 handlerName 反射调用其中的方法。
 */
#define WVBridgeRegisterClass(NAME, CLASS) WMBridgeRegisterClass(NAME, CLASS)
