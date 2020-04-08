//
//  WVWebViewPreload.h
//  Basic
//
//  Created by lianyu on 2019/7/8.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 提供 WebView 的预取相关能力。
 */
@interface WVWebViewPreload : NSObject

/**
 预创建 WKWebView。
 */
+ (void)precreateWKWebView;

@end
