// Copyright 2019 Taobao (China) Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "WMMessageHandler.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMixView : NSObject

// 返回指定名称的插件类。
+ (Class)pluginClassForName:(NSString*)name;

// 注册指定的 MixView 插件。
+ (void)registerPluginClass:(Class)pluginClass forName:(NSString*)name;

// 注册指定的 MixView 插件 observeDOM为依赖DOM监听 目前仅限Weex-View
+ (void)registerPluginClass:(Class)pluginClass forName:(NSString*)name observeDOM:(BOOL)observeDOM;

// 注册指定的 MixView 插件 默认为非全屏 目前仅限WebView
+ (void)registerPluginClass:(Class)pluginClass forName:(NSString*)name fullScreen:(BOOL)fullScreen;

//返回当前 WebView 绑定的 MessageHandler
+ (WMMessageHandler*)messageHandlerForWebView:(WKWebView*)webView createIfNotExists:(BOOL)createIfNotExists;

// 返回注册的 Class 是否是全屏
+ (BOOL)pluginClassIsFullScreen:(NSString*)name;

// 返回注册的 Class 是否是只依赖于DOM监听
+ (BOOL)pluginClassIsObserveDOM:(NSString*)name;

// Private Function
+ (void)swizzleClassName:(NSString*)clsName origSelectorName:(NSString*)origSelName newClass:(Class)newClass newSelector:(SEL)new;

@end

@interface WKWebView (WMixView)

// 为当前 WKWebView 扩展 MixView 能力。
- (void)setupMixView;

// 为当前 Appx WKWebView 扩展 MixView 能力。
- (void)setupMixViewForAppx;

// 移除当前 WebView 相关的所有 MixView; 一般在 webView:didCommitNavigation: 回调中调用，清空前一页面中用到的 MixView。
- (void)removeAllMixViews;

// 当前 WebView 的可见性发生了改变，用于 WebView 不可见（ViewController 切换等）时，停止 MixView 的相关功能。
- (void)mixViewVisibleChanged:(BOOL)webViewVisible;

// 释放当前 WebView 相关的 MixView 功能，用于避免 KVO 未释放导致的 Crash。
- (void)disposeMixView;

// 返回已渲染的 MixView 的基本描述。
- (NSString*)getMixViewDescription;

@end

NS_ASSUME_NONNULL_END
