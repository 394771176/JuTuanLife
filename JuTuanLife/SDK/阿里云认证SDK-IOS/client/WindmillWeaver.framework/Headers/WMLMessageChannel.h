//
//  WMLMessageChannel.h
//  Windmill
//
//  Created by lianyu on 2018/3/30.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMLMessageChannel;

/**
 消息通道的消息到达回调。
 
 @param channel 发送消息的消息通道。
 @param message 发送的消息。
 */
typedef void (^WMLMessageChannelCallback)(WMLMessageChannel * _Nonnull channel, id _Nullable message);

/**
 Client 的 ID。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMLMessageClientInfoIdKey;

/**
 提供多对多消息通道的功能，混合了 Broadcast Channel 和 Channel messaging 的功能。
 https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
 */
@interface WMLMessageChannel : NSObject

/**
 当前通道的名称，连接在一起的通道具有相同的名称。
 */
@property (nonatomic, copy, readonly, nonnull) NSString * name;

/**
 当前源的信息。
 */
@property (nonatomic, copy, nullable) NSDictionary * clientInfo;

/**
 当前消息通道是否有效，即是否存在其它已配对的消息通道。
 */
@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

/**
 当前消息通道的平均调用耗时。
 */
@property (nonatomic, assign, readonly) NSTimeInterval cost;

/**
 通道接收到消息的回调。
 */
@property (atomic, copy, nullable) WMLMessageChannelCallback onMessage;

/**
 创建一个匿名消息通道。
 */
+ (instancetype _Nonnull)channel;

/**
 创建一个具有指定名称的消息通道。
 */
+ (instancetype _Nonnull)channelWithName:(NSString * _Nullable)name;

/**
 创建一个与指定通道连接的消息通道。
 */
+ (instancetype _Nonnull)channelWithChannel:(WMLMessageChannel * _Nullable)channel;

/**
 将指定的消息发送给其它消息通道。
 
 @param message 要发送的消息。
 */
- (void)postMessage:(id _Nullable)message;

/**
 关闭当前消息通道。
 */
- (void)close;

@end
