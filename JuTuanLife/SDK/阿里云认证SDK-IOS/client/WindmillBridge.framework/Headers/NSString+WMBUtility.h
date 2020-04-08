//
//  NSString+WMBUtility.h
//  Bridge
//
//  Created by lianyu on 2018/4/12.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 返回表示指定整数的字符串。
 */
NS_INLINE NSString * _Nonnull WMBStringFromInteger(NSInteger value) {
	return [NSString stringWithFormat:@"%ld", (long)value];
}

/**
 返回表示指定整数的字符串。
 */
NS_INLINE NSString * _Nonnull WMBStringFromUnsignedInteger(NSUInteger value) {
	return [NSString stringWithFormat:@"%lu", (unsigned long)value];
}

/**
 * 返回表示指定浮点数的字符串。
 */
NS_INLINE NSString * _Nonnull WMBStringFromDouble(double value) {
	return [NSString stringWithFormat:@"%f", value];
}

/**
 * 返回表示指定指针的字符串。
 */
NS_INLINE NSString * _Nonnull WMBStringFromPointer(id _Nonnull value) {
	return [NSString stringWithFormat:@"%p", value];
}

@interface NSString (WMBUtility)

/**
 检查指定的字符串是否是空字符串或 nil。
 */
+ (BOOL)wmbIsBlank:(NSString * _Nullable)str;

/**
 返回 Unicode 编码指定字符后的新字符串，将指定字符编码为 \uXXXX 的形式。
 */
- (NSString * _Nonnull)wmbStringByUnicodeEncodeCharacters:(NSCharacterSet * _Nonnull)characters;

@end
