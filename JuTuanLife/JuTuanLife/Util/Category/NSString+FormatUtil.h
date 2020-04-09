//
//  NSString+FormatUtil.h
//  JuTuanLife
//
//  Created by cheng on 2020/4/3.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FormatUtil)

//指定区间内 将字符替换为str
+ (NSString *)replaceString:(NSString *)string withStr:(NSString *)str inRange:(NSRange)range;

//指定长度 插入字符string
+ (NSString *)insertSpaceForString:(NSString *)string withLength:(NSInteger)length;

@end
