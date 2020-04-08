/*
 * WVCommonUtil+Deprecated.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <WindVaneCore/WVCommonUtil.h>

// 已废弃的 WVCommonUtil 方法。

@interface WVCommonUtil (Deprecated)

#pragma mark - 已废弃，预计于 2018.8.1 删除

+ (NSString *)getCameraStr:(NSString *)str DEPRECATED_ATTRIBUTE;
+ (NSMutableDictionary *)getParamFromRequestQuery:(NSString *)query DEPRECATED_ATTRIBUTE;
+ (NSMutableDictionary *)getParamFromRequestQuery:(NSString *)query withStopWord:(NSString *)stopPre DEPRECATED_ATTRIBUTE;

@end
