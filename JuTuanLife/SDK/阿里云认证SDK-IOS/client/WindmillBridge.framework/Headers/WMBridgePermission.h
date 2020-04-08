//
//  WMBridgePermission.h
//  Bridge
//
//  Created by lianyu on 2018/4/5.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 表示 WMBridge 的权限状态。
 */
typedef NS_ENUM(signed char, WMBridgePermissionState) {
	WMBridgePermissionDenied = 0,  // 表示无权限。
	WMBridgePermissionAllowed = 1, // 表示有权限。
	WMBridgePermissionNotSure = 2  // 表示不确定是否有权限。
};

/**
 WMBridge 的权限。
 */
@interface WMBridgePermission : NSObject

/**
 WMBridge 是否具有执行权限。
 */
@property (nonatomic, assign, readonly, getter=isPermitted) WMBridgePermissionState permitted;

/**
 要返回给调用方的权限错误信息。
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary * errorInfo;

/**
 返回允许执行的结果。
 */
+ (instancetype _Nonnull)permissionAllowed;

/**
 返回拒绝执行的结果。
 */
+ (instancetype _Nonnull)permissionDenied:(NSDictionary * _Nullable)result;

/**
 返回无法确认是否具有权限。
 */
+ (instancetype _Nonnull)permissionNotSure;

@end
