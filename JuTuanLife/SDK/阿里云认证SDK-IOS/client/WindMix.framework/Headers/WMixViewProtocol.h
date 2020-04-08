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

#import "RVTComponent.h"
#import "WMixViewParam.h"

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WMixViewProtocol <NSObject, RVTComponentProtocol>

@required
// 初始化 MixView 总是在主线程调用。
- (instancetype _Nonnull)initWithViewId:(NSString* _Nonnull)viewId;
// 返回 MixView 使用的 UIView，总是在主线程调用。
- (UIView* _Nonnull)view;

// 在 View 从视图移除后触发，请在此时释放 View，避免占用内存。总是在主线程调用。
- (void)viewDidUnmount;

typedef void (^WMCallback)(id _Nonnull result, BOOL successOrNot);

@optional
- (instancetype _Nonnull)initWithViewId:(NSString* _Nonnull)viewId data:(NSDictionary* _Nonnull)data;

// 关联到的 WKWebView，必须使用弱引用。
@property (nonatomic, weak, nullable) WKWebView* webView;

// 发送 MixView 事件的 Handler，会在 MixView 创建后设置进去。
@property (nonatomic, copy, nonnull) void (^dispatchEventHandler)(NSString* _Nonnull eventName, id _Nullable data);

// 在 View 已经附加到视图后触发。总是在主线程调用。
- (void)viewDidMount;

/**
 View 的可见部分发生了变化。
 总是在主线程调用。
 @param visible 当前是否可见。如果 visibleFrame 的宽或高为 0，或者 WebView 本身不可见时为 YES；否则为 NO。
 @param visibleFrame 可见部分的 Frame，相对于 MixView.view 本身。由于 CGFloat 计算精度的问题，visibleFrame 的 size 与 MixView 自身的 size 可能并不完全一致。
 */
- (void)visibleChanged:(BOOL)visible frame:(CGRect)visibleFrame;

// View 将要出现被触发的事件:可选实现
- (void)viewWillAppear;

// 在 View 已经可见后触发，保证时机晚于 viewDidMount。包括 WebView 从不可见变为可见，或者 View 滚入可视范围。总是在主线程调用。
- (void)viewDidAppear;

// View 将要消失被触发的事件:可选实现
- (void)viewWillDisappear;

// 在 View 已经不可见后触发。包括 WebView 从可见变为不可见，或者 View 滚出可视范围。总是在主线程调用。
- (void)viewDidDisappear;

// View 将要进入全屏状态被触发的事件:可选实现
- (void)viewWillEnterFullScreen;

// View 已经进入全屏状态被触发的事件:可选实现
- (void)viewDidEnterFullScreen;

// View 将要退出全屏状态被触发的事件:可选实现
- (void)viewWillExitFullScreen;

// View 已经退出全屏状态被触发的事件:可选实现
- (void)viewDidExitFullScreen;

// 重新布局子 View 时触发。总是在主线程调用。
- (void)layoutSubviews;

// View 接收到内存警告时触发。
- (void)didReceiveMemoryWarning;

// 设置 View  的参数。总是在主线程调用。
- (void)setParams:(NSDictionary<NSString*, WMixViewParam*>* _Nonnull)params;

// 移除 View  的参数（恢复默认值）。总是在主线程调用。
- (void)removeParams:(NSArray<NSString*>* _Nonnull)params;

// 增加 View  的事件监听。总是在主线程调用
- (void)addEvent:(NSString* _Nonnull)eventName;

// 移除 View  的事件监听。总是在主线程调用。
- (void)removeEvent:(NSString* _Nonnull)eventName;


@end
