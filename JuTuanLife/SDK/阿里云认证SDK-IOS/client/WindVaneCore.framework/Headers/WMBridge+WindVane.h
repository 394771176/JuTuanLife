//
//  WMBridge+WindVane.h
//  Bridge
//
//  Created by lianyu on 2018/5/15.
//  Copyright © 2018年 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindmillBridge/WMBridge.h>

/**
 提供 WMBridge 的 WindVane 适配。
 */
@interface WMBridge (WindVane)

/**
 检查指定 URL 是否是 WindVane 的 Bridge 协议。
 
 @param url 要检查的 URL。
 */
+ (BOOL)isBridgeProtocol:(NSURL * _Nonnull)url;

/**
 根据指定 URL 执行 Bridge。

 @param url 符合 WindVane Bridge 调用协议的 URL，格式为：hybrid://className:reqId/handlerName?params
 @return 如果 url 符合 WindVane Bridge 协议，则返回 YES；否则返回 NO。
 */
- (BOOL)callHandlerWithURL:(NSURL * _Nonnull)url;

@end
