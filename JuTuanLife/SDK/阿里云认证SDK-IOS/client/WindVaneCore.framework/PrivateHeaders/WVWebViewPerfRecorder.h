//
//  WVWebViewPerfRecorder.h
//  WindVaneBasic
//
//  Created by lianyu.ysj on 16/3/8.
//  Copyright © 2016年 WindVane. All rights reserved.
//

#import <WindVaneCore/WVPagePerformance.h>
#import <WindVaneCore/WVWebViewProtocol.h>
#import <Foundation/Foundation.h>

/**
 * WebView 的性能记录类。
 */
@interface WVWebViewPerfRecorder : NSObject

/**
 * 关联的 WebView。
 */
@property (nonatomic, weak, nullable) UIView<WVWebViewProtocol> * webView;

/**
 * 当前页面的性能信息。
 */
@property (atomic, strong, readonly, nullable) WVPagePerformance * pagePerformance;
	
/**
 * 拦截开始的时间。
 */
@property (nonatomic, assign) double interceptStartTime;

/**
 * 页面开始加载时调用。
 *
 * @param url         页面 URL。
 * @param identifier  页面的全局唯一标识符。
 * @param contentType 当前页面的内容类型。
 */
- (void)pageDidStartLoad:(NSURL * _Nullable)url identifier:(NSString * _Nullable)identifier contentType:(WVURLContentType )contentType;

/**
 * 页面导航失败时调用。
 *
 * @param error 错误信息。
 * @param url URL。
 * @param identifier 唯一标识。
 */
- (void)pageDidFailNavigationWithError:(NSError * _Nullable)error url:(NSURL * _Nullable)url identifier:(NSString * _Nullable)identifier;

/**
 * 页面发生 DOMContentLoaded 事件时调用。
 *
 * @param time 事件发生时间，为 1970 年 1 月 1 日至今的秒数。
 */
- (void)pageDidDomLoadAtTime:(NSTimeInterval)time;

/**
 * 页面完成加载时调用。
 *
 * @param isFinished 页面是否完成加载，或者被用户中断。
 */
- (void)pageDidFinishLoad:(BOOL)isFinished;

/**
 * 页面加载失败时调用。
 *
 * @param error 页面加载失败的错误信息。
 */
- (void)pageDidFailLoadWithError:(NSError * _Nullable)error;

/**
 * WebView 开始 init 时调用。
 */
- (void)webViewDidStartInit;

/**
 * WebView 结束 init 时调用。
 */
- (void)webViewDidFinishInit;

/**
 * 页面开始加载请求时调用。
 */
- (void)pageDidLoadRequest;

/**
 * 页面网络拦截开始时调用。
 */
- (void)pageDidStartIntercept;

/**
 * 页面网络拦截结束时调用。
 */
- (void)pageDidFinishIntercept;

/**
 * 记录 FSP。
 */
- (void)recordFSP:(double)time;

/**
 * 记录 FP。
 */
- (void)recordFP:(double)time;

/**
 * 发生了 JS Error 的时候调用。
 */
- (void)jsErrorOccurred;

/**
 * 通过 APM 上报埋点。
 */
- (void)commitPagePerfByAPM;

#pragma mark - 标记

// 是否是第一次加载。
@property (nonatomic, assign) BOOL isFirstLoad;

@end
