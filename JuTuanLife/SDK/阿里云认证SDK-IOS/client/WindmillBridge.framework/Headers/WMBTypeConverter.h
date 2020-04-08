//
//  WMBTypeConverter.h
//  Bridge
//
//  Created by xuyouyang on 2018/5/15.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

/**
 提供了安全的类型转换接口，
 */

#if defined __cplusplus
extern "C" {
#endif

#define WMB_SAFE_TYPE_INVOKE(NAME, VALUE, DEFAULT, ...) NAME(VALUE, DEFAULT)

/**
 安全的转换为 BOOL 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
BOOL wmbSafeBOOL(id value, BOOL defaultValue);
#define WMB_SAFE_BOOL(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeBOOL, VALUE, ##__VA_ARGS__, NO)

/**
 安全的转换为 NSInteger 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
NSInteger wmbSafeInteger(id value, NSInteger defaultValue);
#define WMB_SAFE_INTEGER(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeInteger, VALUE, ##__VA_ARGS__, 0)

/**
 安全的转换为 NSInteger 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定，字符串会按照十六进制解析。
 */
NSInteger wmbSafeHexInteger(id value, NSInteger defaultValue);
#define WMB_SAFE_HEX_INTEGER(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeHexInteger, VALUE, ##__VA_ARGS__, 0)

/**
 安全的转换为 NSUInteger 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
NSUInteger wmbSafeUnsignedInteger(id value, NSUInteger defaultValue);
#define WMB_SAFE_UINTEGER(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeUnsignedInteger, VALUE, ##__VA_ARGS__, 0)

/**
 安全的转换为 long long 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
long long wmbSafeLongLong(id value, long long defaultValue);
#define WMB_SAFE_LLONG(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeLongLong, VALUE, ##__VA_ARGS__, 0LL)

/**
 安全的转换为 unsigned long long 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
unsigned long long wmbSafeUnsignedLongLong(id value, unsigned long long defaultValue);
#define WMB_SAFE_ULLONG(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeUnsignedLongLong, VALUE, ##__VA_ARGS__, 0ULL)

/**
 安全的转换为 CGFloat 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
CGFloat wmbSafeFloat(id value, CGFloat defaultValue);
#define WMB_SAFE_FLOAT(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeFloat, VALUE, ##__VA_ARGS__, 0.0)

/**
 安全的转换为 double 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
double wmbSafeDouble(id value, double defaultValue);
#define WMB_SAFE_DOUBLE(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeDouble, VALUE, ##__VA_ARGS__, 0.0)

/**
 安全的转换为 NSString 类型，如果不存在或类型错误则返回默认值。
 */
NSString * wmbSafeString(id value, NSString * defaultValue);
#define WMB_SAFE_STRING(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeString, VALUE, ##__VA_ARGS__, nil)

/**
 安全的转换为 NSArray 类型，如果不存在或类型错误则返回默认值。
 */
NSArray * wmbSafeArray(id value, NSArray * defaultValue);
#define WMB_SAFE_ARRAY(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeArray, VALUE, ##__VA_ARGS__, nil)

/**
 安全的转换为 NSDictionary 类型，如果不存在或类型错误则返回默认值。
 */
NSDictionary * wmbSafeDictionary(id value, NSDictionary * defaultValue);
#define WMB_SAFE_DICTIONARY(VALUE, ...) WMB_SAFE_TYPE_INVOKE(wmbSafeDictionary, VALUE, ##__VA_ARGS__, nil)
	
#if defined __cplusplus
};
#endif
