//
//  JTMessageItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMessageItem.h"

@implementation JTMessageItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"itemId" : @"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    
    return YES;
}

@end
