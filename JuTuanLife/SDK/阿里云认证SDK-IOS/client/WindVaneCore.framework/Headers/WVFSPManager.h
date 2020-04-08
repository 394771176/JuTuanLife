//
//  WVFSPManager.h
//  Basic
//
//  Created by 郑祯 on 2019/2/17.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVPageTracker;

/**
 首屏时间单元流程结束后的操作。
 
 @param FSP First Screen Paint。
 @param FP  First Paint。
 */
typedef void (^WVFSPCompletionHandler)(double FSP, double FP);

/**
 首屏时间的管理类。
 */
@interface WVFSPManager : NSObject

/**
 首屏时间的结束时间。
 */
@property (nonatomic, assign, readonly) double endTime;

/**
 关联的性能追踪器。
 */
@property (nonatomic, weak, nullable) WVPageTracker * pageTracker;

/**
 首屏时间的开关。
 */
+ (BOOL)isOpenFSP;

/**
 返回首屏时间的 JS 代码。
 */
+ (NSString * _Nonnull)jsCodeForFSP;

/**
 返回首屏时间的关闭信号名称。
 */
+ (NSString * _Nonnull)eventForFSPStop;

/**
 接收 JS 回调的信息。
 
 @param message 接受到的消息。
 */
- (void)receiveJSMessage:(id _Nullable)message;

#pragma mark - Process

/**
 首屏时间导航路由开始。
 
 放在导航路由中的入口方法中：decidePolicyForNavigationAction
 */
- (void)navigationDidStart;

/**
 首屏时间导航路由结束。
 
 放在导航路由的出口方法中：didFinishNavigation || didFailNavigation
 
 @param url 导航路由中的 url。
 */
- (void)navigationDidFinishWithURL:(NSString * _Nonnull)url;

/**
 首屏时间单元流程结束。
 
 @param completionHandler 单元流程结束后的操作。
 */
- (void)unitDidFinish:(WVFSPCompletionHandler _Nullable)completionHandler;

@end
