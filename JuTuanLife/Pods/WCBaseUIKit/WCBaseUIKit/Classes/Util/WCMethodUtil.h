//
//  WCMethodUtil.h
//  Pods-WCBaseUIKit_Example
//
//  Created by cheng on 2020/3/3.
//

#import <Foundation/Foundation.h>

extern NSString * readTxtFromPath(NSString *path);

extern void writeTxtToPath(NSString *text, NSString *path);

extern BOOL CGFloatEqualToFloat(CGFloat f1, CGFloat f2);

/* 比较 f1 与 f2
 * 0 为 等于， 1 为 大于   -1 为小于
 */
extern int CGFloatCompareWithFloat(CGFloat f1, CGFloat f2);

extern CGFloat validValue(CGFloat f, CGFloat min, CGFloat max);

@interface WCMethodUtil : NSObject

@end
