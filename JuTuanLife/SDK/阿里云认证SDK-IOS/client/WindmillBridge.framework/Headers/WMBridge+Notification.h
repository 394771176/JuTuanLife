//
//  WMBridge+Notification.h
//  Bridge
//
//  Created by lianyu on 2018/7/16.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import "WMBridge.h"
#import <Foundation/Foundation.h>

/**
 开始定位更新的通知名称。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMBStartUpdateLocationNotification;

/**
 结束定位更新的通知名称。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMBStopUpdateLocationNotification;

/**
 WMBridge 容器通知相关功能。
 */
@interface WMBridge (Notification)

/**
 接收到容器通知的回调。
 
 @param name 通知的名称。
 @param userInfo 通知的额外信息。
 */
typedef void (^WMBridgeNotificationHandler)(NSString * _Nonnull name, NSDictionary * _Nullable userInfo);

/**
 添加指定的容器观察者，接收 API 传递的信息。
 
 @param name 要观察的事件名称。
 @param block 要添加的回调。
 @return 容器观察者，要移除时需要向 removeObserver: 方法传入这里返回的对象。
 */
- (id _Nullable)addObserverForName:(NSString * _Nonnull)name usingBlock:(WMBridgeNotificationHandler _Nonnull)block;

/**
 移除指定的容器观察者。
 
 @param observer 要移除的观察者。
 */
- (void)removeObserver:(id _Nonnull)observer;

@end
