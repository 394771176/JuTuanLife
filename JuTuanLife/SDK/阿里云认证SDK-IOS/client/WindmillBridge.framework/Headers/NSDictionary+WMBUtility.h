//
//  NSDictionary+WMBUtility.h
//  Bridge
//
//  Created by xuyouyang on 2018/5/15.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@interface NSDictionary (WMBUtility)

/**
 * 获取指定键的 BOOL 值，如果不存在或类型错误则返回 NO。
 */
- (BOOL)wmbBoolValue:(id)key;

/**
 * 获取指定键的 BOOL 值，如果不存在或类型错误则返回默认值。
 */
- (BOOL)wmbBoolValue:(id)key default:(BOOL)defaultValue;

/**
 * 获取指定键的 NSInteger 值，如果不存在或类型错误则返回 0。
 */
- (NSInteger)wmbIntegerValue:(id)key;

/**
 * 获取指定键的 NSInteger 值，如果不存在或类型错误则返回默认值。
 */
- (NSInteger)wmbIntegerValue:(id)key default:(NSInteger)defaultValue;

/**
 * 获取指定键的 NSUInteger 值，如果不存在或类型错误则返回 0。
 */
- (NSUInteger)wmbUnsignedIntegerValue:(id)key;

/**
 * 获取指定键的 NSUInteger 值，如果不存在或类型错误则返回默认值。
 */
- (NSUInteger)wmbUnsignedIntegerValue:(id)key default:(NSUInteger)defaultValue;

/**
 * 获取指定键的 long long 值，如果不存在或类型错误则返回 0。
 */
- (long long)wmbLongLongValue:(id)key;

/**
 * 获取指定键的 long long 值，如果不存在或类型错误则返回默认值。
 */
- (long long)wmbLongLongValue:(id)key default:(long long)defaultValue;

/**
 * 获取指定键的 unsigned long long 值，如果不存在或类型错误则返回 0。
 */
- (unsigned long long)wmbUnsignedLongLongValue:(id)key;

/**
 * 获取指定键的 unsigned long long 值，如果不存在或类型错误则返回默认值。
 */
- (unsigned long long)wmbUnsignedLongLongValue:(id)key default:(unsigned long long)defaultValue;

/**
 * 获取指定键的 CGFloat 值，如果不存在或类型错误则返回 0.0。
 */
- (CGFloat)wmbFloatValue:(id)key;

/**
 * 获取指定键的 CGFloat 值，如果不存在或类型错误则返回默认值。
 */
- (CGFloat)wmbFloatValue:(id)key default:(CGFloat)defaultValue;

/**
 * 获取指定键的 double 值，如果不存在或类型错误则返回 0.0。
 */
- (double)wmbDoubleValue:(id)key;

/**
 * 获取指定键的 double 值，如果不存在或类型错误则返回默认值。
 */
- (double)wmbDoubleValue:(id)key default:(double)defaultValue;

/**
 * 获取指定键的 NSString 值，如果不存在或类型错误则返回 nil。
 */
- (NSString *)wmbStringValue:(id)key;

/**
 * 获取指定键的 NSString 值，如果不存在或类型错误则返回默认值。
 */
- (NSString *)wmbStringValue:(id)key default:(NSString *)defaultValue;

/**
 * 获取指定键的 NSArray 值，如果不存在或类型错误则返回 nil。
 */
- (NSArray *)wmbArrayValue:(id)key;

/**
 * 获取指定键的 NSDictionary 值，如果不存在或类型错误则返回 nil。
 */
- (NSDictionary *)wmbDictionaryValue:(id)key;

@end
