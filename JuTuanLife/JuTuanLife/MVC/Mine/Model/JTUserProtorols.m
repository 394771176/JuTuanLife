//
//  JTUserProtorols.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/10.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserProtorols.h"

@implementation JTUserProtorols

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    return YES;
}

+ (NSArray<NSArray *> *)groupForDateWithItems:(NSArray<JTUserProtorols *> *)items
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [items enumerateObjectsUsingBlock:^(JTUserProtorols * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj.signedTime;
        if ([key rangeOfString:@":"].length) {
            key = [key componentsSeparatedByString:@":"].firstObject;
        }
        NSMutableArray *array = [dict objectForKey:key];
        if (!array) {
            array = [NSMutableArray array];
            [dict safeSetObject:array forKey:key];
            [result safeAddObject:array];
        }
        [array addObject:obj];
    }];
    [dict removeAllObjects];
    dict = nil;
    return result;
}

@end
