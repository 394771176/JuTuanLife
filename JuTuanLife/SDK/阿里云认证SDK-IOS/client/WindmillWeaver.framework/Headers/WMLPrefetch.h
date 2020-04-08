//
//  WMLPrefetch.h
//  Weaver
//
//  Created by lianyu on 2018/4/16.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import "WMLPrefetchProtocol.h"
#import <Foundation/Foundation.h>

/**
 预取数据完成的回调。
 */
typedef void(^WMLPrefetchDataCompleted)(NSDictionary * _Nullable data, NSError * _Nullable error);

/**
 预取数据时 externalKey 的键名，一般用于 getData:params:completionHandler: 的 params 参数中。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMLPrefetchExternalKeyKey;

/**
 请求预取数据时用于区分容器的 userAgent 的键名，一般用于 requestData:params: 的 params 参数中。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WMLPrefetchUserAgentKey;

/**
 支持数据的预取。
 */
@interface WMLPrefetch : NSObject

/**
 注册指定的预取接口。
 */
+ (void)registerPrefetchHandler:(id<WMLPrefetchProtocol> _Nonnull)prefetchHandler;

/**
 反注册指定的预取接口。
 */
+ (void)unregisterPrefetchHandler:(id<WMLPrefetchProtocol> _Nonnull)prefetchHandler;

/**
 请求预取指定的数据。
 
 @param url 要预取数据的 URL。
 @param params 要预取数据的相关参数。
 
 @result 数据预取的决定信息。
 */
+ (WMLPrefetchDecision * _Nonnull)requestData:(NSURL * _Nonnull)url params:(NSDictionary<NSString *, NSString *> * _Nullable)params;

/**
 返回指定 URL 相关的预取数据。
 
 @param url 要预取数据的 URL，仅会通过 host+path#externalKey 匹配。
 @param params 要预取数据的相关参数。
 @param completionHandler 数据预取完毕的回调。
 */
+ (void)getData:(NSURL * _Nonnull)url params:(NSDictionary * _Nullable)params completionHandler:(WMLPrefetchDataCompleted _Nonnull)completionHandler;

@end
