//
//  WVResPerfRecorder.h
//  WindVaneBasic
//
//  Created by lianyu.ysj on 16/3/9.
//  Copyright © 2016年 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindVaneCore/WVPagePerformance.h>
#import <WindmillWeaver/WindmillWeaver.h>

/**
 * 资源的性能记录器。
 */
@interface WVResPerfRecorder : NSObject

#pragma mark - Windmill 相关

/**
 * 返回 Windmill 的隔离环境。
 */
- (WMLIsolationEnv *_Nullable)isolationEnv:(NSURLRequest *_Nonnull)request;

/**
 * 返回共享实例。
 */
+ (instancetype _Nonnull)sharedInstance;

#pragma mark- 页面管理

/**
 * 添加指定的页面信息。
 */
- (void)addPage:(WVPagePerformance * _Nonnull)pagePerf;
	
/**
 * 移除指定的页面和信息。
 */
- (void)removePage:(WVPagePerformance * _Nonnull)pagePerf;

#pragma mark - 资源性能

/**
 * 资源开始加载时调用。
 *
 * @param request 资源请求。
 * @param time    资源开始加载时间，为 1970 年 1 月 1 日至今的毫秒数。
 */
- (void)resource:(NSURLRequest * _Nonnull)request didStartLoadAtTime:(NSTimeInterval)time;

/**
 * 资源或页面获得状态码等信息时调用。
 *
 * @param request    资源请求。
 * @param statusCode 资源 HTTP 状态码。
 * @param fromType   自定义页面来源，如缓存、线上等。
 * @param header     响应头。
 */
- (void)resource:(NSURLRequest * _Nonnull)request didGetStatusCode:(NSInteger)statusCode withFromType:(NSString * _Nonnull)fromType withHeader:(NSDictionary * _Nullable)header;

/**
 * 资源结束加载时调用。
 *
 * @param request  资源请求。
 * @param time     资源结束加载时间，为 1970 年 1 月 1 日至今的毫秒数。
 * @param dataSize 资源大小。
 */
- (void)resource:(NSURLRequest * _Nonnull)request didFinishLoadAtTime:(NSTimeInterval)time dataSize:(NSUInteger)dataSize;

/**
 * 资源或页面获得缓存状态时调用。
 *
 * @param request 请求。
 * @param state   缓存状态。
 */
- (void)resource:(NSURLRequest * _Nonnull)request didGetCacheState:(WVCacheState)state;

@end
