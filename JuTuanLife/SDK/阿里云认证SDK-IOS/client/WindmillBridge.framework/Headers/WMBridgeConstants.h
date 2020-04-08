//
//  WMBridgeConstants.h
//  Bridge
//
//  Created by lianyu on 2018/11/14.
//  Copyright © 2018 Windmill. All rights reserved.
//

#ifndef WMBridgeConstants_h
#define WMBridgeConstants_h

#import <Foundation/Foundation.h>

#pragma mark - WMBridge Status

/**
 表示 WMBridge 的回调状态。
 */
typedef NSString * WMBridgeStatus NS_EXTENSIBLE_STRING_ENUM;

/**
 表示 WMBridge API 执行成功（不允许设置为失败回调的返回值）。
 */
FOUNDATION_EXPORT WMBridgeStatus _Nonnull const WMBridgeStatusSuccess;

/**
 表示 WMBridge API 传入参数错误。
 */
FOUNDATION_EXPORT WMBridgeStatus _Nonnull const WMBridgeStatusParamError;

/**
 表示 WMBridge API 执行失败。
 */
FOUNDATION_EXPORT WMBridgeStatus _Nonnull const WMBridgeStatusFailed;

/**
 表示 WMBridge API 执行出现异常。
 */
FOUNDATION_EXPORT WMBridgeStatus _Nonnull const WMBridgeStatusException;

/**
 表示 WMBridge API 功能不被支持。
 */
FOUNDATION_EXPORT WMBridgeStatus _Nonnull const WMBridgeStatusNotSupported;

/**
 表示 WMBridge API 缺少用户权限。
 */
FOUNDATION_EXPORT WMBridgeStatus _Nonnull const WMBridgeStatusUserDenied;

/**
 表示 WMBridge API 的执行被用户取消。
 */
FOUNDATION_EXPORT WMBridgeStatus _Nonnull const WMBridgeStatusUserCancelled;

#pragma mark WMBridge Callback

/**
 标准返回数据：消息（字符串）。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMBridgeResultMessageName;

/**
 标准返回数据：错误码（数字）。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMBridgeResultErrorName;

#pragma mark WMBridge Env Info

/**
 envInfo 中 UserAgent 信息的键。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMBridgeEnvInfoUserAgentKey;

#endif /* WMBridgeConstants_h */
