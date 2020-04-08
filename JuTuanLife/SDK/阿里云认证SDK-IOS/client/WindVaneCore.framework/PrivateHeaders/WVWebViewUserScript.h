//
//  WVWebViewUserScript.h
//  Basic
//
//  Created by lianyu.ysj on 2018/1/9.
//  Copyright © 2018年 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WindVaneCore/WVWebViewProtocol.h>

/**
 WVWebView 的 JS 注入器。
 */
@interface WVWebViewUserScript : NSObject

/**
 将 JavaScript 注入到 JSContext 中。
 */
+ (void)executeInJSContext:(JSContext * _Nonnull)jsContext withWebView:(UIView<WVWebViewProtocol> * _Nonnull)webView;

@end
