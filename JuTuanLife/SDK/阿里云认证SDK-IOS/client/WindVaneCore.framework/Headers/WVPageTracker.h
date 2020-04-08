//
//  WVPageTracker.h
//  Core
//
//  Created by 郑祯 on 2019/7/12.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVWKWebView;
@class WVResource;

/**
 * 页面追踪器。
 */
@interface WVPageTracker : NSObject

#pragma mark - WebView Event

- (void)webViewDidStartInitWithWebView:(WVWKWebView * _Nonnull)webView;
- (void)webViewDidFinishInit;
- (void)webViewDidLoadRequest;
- (void)webViewDidStartBlockURL;
- (void)webViewDidFinishBlockURL;
- (void)webViewDidJSErrorOccurred;
- (void)webViewDidDealloc;

#pragma mark - Page Event

- (void)webView:(WVWKWebView * _Nonnull)webView decideRequest:(NSURLRequest * _Nonnull)request;
- (void)webViewDidStartLoadRequest:(WVWKWebView * _Nonnull)webView;
- (void)webViewDidRedirect:(WVWKWebView * _Nonnull)webView;
- (void)webView:(WVWKWebView * _Nonnull)webView decideResponse:(NSURLResponse * _Nonnull)response;
- (void)webViewDidStartLoadContent:(WVWKWebView * _Nonnull)webView;
- (void)webView:(WVWKWebView * _Nonnull)webView didFailDataLoadingWithError:(NSError * _Nonnull)error;
- (void)webViewDidFinishNavigation:(WVWKWebView * _Nonnull)webView;
- (void)webView:(WVWKWebView * _Nonnull)webView didFailNavigationWithError:(NSError * _Nonnull)error;

#pragma mark - Performance Event

- (void)webView:(WVWKWebView * _Nullable)webView accessToFSP:(double)fsp;
- (void)webView:(WVWKWebView * _Nullable)webView accessToFP:(double)fp;
- (void)webViewAccessToPerformanceTiming:(WVWKWebView * _Nonnull)webView;

#pragma mark - Resource

- (void)recordResource:(WVResource * _Nonnull)resource;
- (WVResource * _Nullable)takeResource:(NSString * _Nonnull)url;
- (BOOL)isPage:(NSString * _Nonnull)url;
- (BOOL)isCorrespondingUA:(NSString * _Nonnull)userAgent;

#pragma mark - Identifier

- (void)recordWebViewIdentifier:(NSString * _Nonnull)identifier;
- (void)recordWebViewUserAgent:(NSString * _Nonnull)userAgent;

#pragma mark - Switch

+ (BOOL)usable;

@end
