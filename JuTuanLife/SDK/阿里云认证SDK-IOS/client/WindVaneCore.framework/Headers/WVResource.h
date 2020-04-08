//
//  WVResource.h
//  Core
//
//  Created by 郑祯 on 2019/7/15.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 资源的缓存状态。
 */
typedef NS_ENUM(NSInteger, WVZCacheState) {
	WVZCacheStateNotUseZCache, // 未使用 ZCache
	WVZCacheStateNotHitZCache, // 使用了 ZCache，未命中
	WVZCacheStateHitZCache     // 使用了 ZCache，命中了
};

/**
 * 资源模型。
 */
@interface WVResource : NSObject

@property (nonatomic, copy) NSString * url;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, assign) NSUInteger dataSize;
@property (nonatomic, assign) WVZCacheState zcacheState;
@property (nonatomic, copy) NSString * zcacheInfo;
@property (nonatomic, assign) BOOL isHTML;
@property (nonatomic, assign) double loadingStartTime;
@property (nonatomic, assign) double loadingEndTime;
@property (nonatomic, assign) BOOL hasError;

@end
