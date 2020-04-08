//
//  RPSDKInterface.h
//  ALRealIdentity
//
//  Created by  Hank Zhang on 2019/11/1.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RPResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `RPSDK` 实人认证 SDK 接口。
 */
NS_SWIFT_NAME(RPSDK)
@interface RPSDK : NSObject

/**
 开始实人认证，适用于 H5 + Native 的认证方案。

 @param verifyToken 实人认证流程的唯一标识，一般从接入方自己的服务端获取，有效时间 30 分钟。
 @param viewController 调用实人认证的视图控制器。
 @param completion 实人认证结果回调。
 */
+ (void)startWithVerifyToken:(NSString *)verifyToken
              viewController:(UIViewController *)viewController
                  completion:(RPCompletion _Nullable)completion;

/**
 开始实人认证，适用于纯 Native 的认证方案。
 只支持纯人脸的登陆 / 解锁 / 认证功能，纯 H5 方案不支持此方法。

 @param verifyToken 实人认证流程的唯一标识，一般从接入方自己的服务端获取，有效时间 30 分钟。
 @param viewController 调用实人认证的视图控制器。
 @param completion 实人认证结果回调。
 */
+ (void)startByNativeWithVerifyToken:(NSString *)verifyToken
                      viewController:(UIViewController *)viewController
                          completion:(RPCompletion _Nullable)completion;

/**
 开始实人认证，使用指定的 H5 地址作为认证入口。

 @param url 实人认证流程的地址。
 @param viewController 调用实人认证的视图控制器。
 @param completion 实人认证结果回调。
 */
+ (void)startByURL:(NSString *)url
    viewController:(UIViewController *)viewController
        completion:(RPCompletion _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
