//
//  WMLPrefetchProtocol.h
//  Weaver
//
//  Created by lianyu on 2018/4/16.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import "WMLPrefetchDecision.h"
#import "WMLPrefetchDataResponse.h"
#import <Foundation/Foundation.h>

/**
 支持数据的预取接口。
 */
@protocol WMLPrefetchProtocol <NSObject>

@required

/**
 对指定数据做预取。
 
 @param url 要预取数据的完整 URL。
 @param params 要预取数据的相关参数。
 @param completionHandler 数据预取完毕的回调。
 @return 当前接口是否能处理当前 URL 的数据，不能处理则返回 nil。
 */
- (WMLPrefetchDecision * _Nullable)prefetchData:(NSURL * _Nonnull)url params:(NSDictionary * _Nullable)params completionHandler:(void(^ _Nonnull)(WMLPrefetchDataResponse * _Nullable response, NSError * _Nullable error))completionHandler;

@end
