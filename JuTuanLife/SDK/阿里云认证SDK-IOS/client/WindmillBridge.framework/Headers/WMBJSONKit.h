//
//  WMBJSONKit.h
//  Bridge
//
//  Created by lianyu on 2018/4/12.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 包含与 JSON 处理相关的逻辑。
 */
@interface WMBJSONKit : NSObject

/**
 将指定的 JSON 对象序列化为字符串。
 */
+ (NSData * _Nullable)dataWithJSONObject:(id _Nullable)object;

/**
 将指定的 JSON 对象序列化为字符串。
 */
+ (NSString * _Nullable)stringWithJSONObject:(id _Nullable)object;

/**
 修复直接将 JSON 字符串作为 js 使用时，\u2028 和 \u2029 等特殊字符导致 JS 报错的问题。
 这些特殊字符在 JSON 中是合法的，但 JS 中会当做换行等特殊意义的字符，可能会导致出现 JS Error，需要进行 Unicode 转义。
 */
+ (NSString * _Nonnull)fixJSON2JSBug:(NSString * _Nonnull)json;

/**
 将指定的二进制反序列化为 JSON 对象。
 */
+ (id _Nullable)JSONObjectWithData:(NSData * _Nullable)data;

/**
 将指定的 UTF-8 字符串反序列化为 JSON 对象。
 */
+ (id _Nullable)JSONObjectWithString:(NSString * _Nullable)string;

@end
