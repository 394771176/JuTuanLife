//
//  WMBridgeDelegate.h
//  Bridge
//
//  Created by lianyu on 2018/4/9.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import "WMBridgeProtocol.h"
#import <Foundation/Foundation.h>

/**
 标准返回数据：状态码。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMBridgeResultStatusName;

/**
 WMBridge 调用方需要实现的 Protocol，一般利用 Category 对现有环境进行扩展。
 需要做好非主线程调用的保护。
 */
@protocol WMBridgeDelegate <NSObject>

@optional

/**
 WMBridge 的成功/失败回调，通过 status 区分成功或者失败。
 可能在任意线程调用。

 @param reqId     请求 ID。
 @param status    回调返回值。
 @param result    回调结果。
 @param keepAlive 是否需要保持回调不销毁，可以持续性调用。
 */
- (void)bridgeCallback:(NSString * _Nonnull)reqId withStatus:(NSString * _Nonnull)status withResult:(NSDictionary * _Nullable)result keepAlive:(BOOL)keepAlive;

/**
 表示 WMBridge 的持续回调已结束，可以回收。
 可能在任意线程调用。

 @param reqId 请求 ID。
 */
- (void)bridgeDisposeCallback:(NSString * _Nonnull)reqId;

/**
 WMBridge 发送事件的接口。
 可能在任意线程调用。

 @param eventName 要发送的事件名称。
 @param param     事件参数，必须是可 JSON 序列化的数据类型。
 @param callback  事件结果的回调。
 */
- (void)bridgeDispatchEvent:(NSString * _Nonnull)eventName withParam:(id _Nullable)param withCallback:(WMBEventCallback _Nullable)callback;

@end
