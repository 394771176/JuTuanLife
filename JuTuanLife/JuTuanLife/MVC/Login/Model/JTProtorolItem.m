//
//  JTProtorolItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTProtorolItem.h"

@implementation JTProtorolItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{};
}

+ (JTProtorolItem *)itemWithName:(NSString *)name link:(NSString *)link
{
    CREATE_ITEM(JTProtorolItem)
    item.name = name;
    item.link = link;
    return item;
}

@end
