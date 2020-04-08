//
//  WVLoadRequestExt.h
//  Core
//
//  Created by lianyu on 2019/9/13.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindVaneCore/WVWKWebView.h>

/**
 WindVane loadRequest 的响应协议。
 */
@protocol WVLoadRequestResponserProtocol <NSObject>

/**
 WebView 加载指定的请求。
 */
- (WKNavigation * _Nullable)webView:(WVWKWebView * _Nonnull)webView loadRequest:(NSURLRequest * _Nonnull)request;

@end

/**
 WindVane loadRequest 的扩展协议。
 */
@protocol WVLoadRequestExtensionProtocol <NSObject>

/**
 WebView 加载指定的请求。
 */
- (WKNavigation * _Nullable)webView:(WVWKWebView * _Nonnull)webView loadRequest:(NSURLRequest * _Nonnull)request responser:(id<WVLoadRequestResponserProtocol> _Nonnull)responser;

@end

/**
 WindVane loadRequest 的扩展。
 */
@interface WVLoadRequestExt : NSObject

/**
 注册指定的扩展项。
 */
+ (void)registerExt:(id<WVLoadRequestExtensionProtocol> _Nonnull)extension;

/**
 WebView 加载指定的请求。
 */
+ (WKNavigation * _Nullable)webView:(WVWKWebView * _Nonnull)webView loadRequest:(NSURLRequest * _Nonnull)request;

@end
