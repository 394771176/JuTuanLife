/*
 * WVJavascriptApplication.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <WindVaneCore/WVJSBridgeCallbackDelegate.h>
#import <WindVaneCore/WindVaneJSBridgeCore.h>
#import <WindVaneCore/WVBridge.h>

/**
 表示与 WebView 关联的 JSBridge，核心功能已迁移到 WVBridge 类中，这里主要为了做旧版本兼容，旧接口均已废弃。
 */
DEPRECATED_MSG_ATTRIBUTE("已废弃，请替换为 WMBridge 类的相关方法")
@interface WVJavascriptApplication : WVBridge

/**
 使用指定的 WebView 初始化。
 */
- (instancetype)initWithWebView:(UIView<WVWebViewBasicProtocol> *)webView NS_DESIGNATED_INITIALIZER;

#pragma mark - 已废弃，预计于 2019.5.1 删除

+ (void)notifyByEventForWebView:(UIView<WVWebViewBasicProtocol> *)webview withEventName:(NSString *)eventName withResult:(NSDictionary *)eventResult DEPRECATED_MSG_ATTRIBUTE("请替换为 Context 的 dispatchEvent 或 [WVStandardEventCenter postNotificationToJS:withEventData:withWebView:] 方法");

#pragma mark - 已废弃，预计于 2019.1.1 删除

- (void)registeHandler:(NSString *)name withClassName:(NSString *)className handler:(WVPrivateJSBHandler)handler DEPRECATED_MSG_ATTRIBUTE("请替换为 registerHandler:withBlock: 方法，用法请参考 http://h5.alibaba-inc.com/windvane/JSBridge.html#2-2-iOS-静态注册-JSBridge");
+ (void)registerAppHandler:(NSString *)name withClassName:(NSString *)className handler:(WVJSBHandler)handler DEPRECATED_ATTRIBUTE;

@end
