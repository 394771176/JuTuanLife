//
//  DTTitleIconItem.m
//  DrivingTest
//
//  Created by cheng on 16/3/18.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "DTTitleIconItem.h"
#import <WCCategory/WCCategory.h>

@implementation DTTitleIconItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{
             @"title" : @[@"title", @"text"]
             };
}

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName
{
    return [self itemWithTitle:title iconName:iconName scheme:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName scheme:(NSString *)scheme {
    
    DTTitleIconItem *item = [[self alloc] init];
    item.title = title;
    item.icon = [UIImage imageNamed:iconName];
    item.openSchemeUrl = scheme;
    return item;
}


@end

@implementation DTTitleContentIcon

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName content:(NSString *)content
{
    DTTitleContentIcon *item = [self itemWithTitle:title iconName:iconName];
    item.content = content;
    return item;
}

@end


@implementation DTTitleIconUrlItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    NSMutableDictionary *dict = [[super modelCustomPropertyMapper] mutableCopy];
    [dict addEntriesFromDictionary:@{
                                            @"iconUrl" : @[@"iconUrl", @"icon"]
                                            ,@"jumpUrl" : @[@"jumpUrl", @"clickUrl"]
                                            }];
    return dict;
}

+ (DTTitleIconUrlItem *)itemFromConfigDict:(NSDictionary *)dict
{
    return [DTTitleIconUrlItem itemFromDict:dict];
}

+ (DTTitleIconUrlItem *)itemFromConfig:(NSDictionary *)dict key:(NSString *)key
{
    if ([NSDictionary validDict:dict forKey:key]) {
        return [self itemFromConfigDict:[dict objectForKey:key]];
    }
    return nil;
}

+ (DTTitleIconItem *)itemFromConfig:(NSDictionary *)dict key:(NSString *)key withDefault:(DTTitleIconItem * (^)(void))defaultBlock
{
    DTTitleIconItem *item = [self itemFromConfig:dict key:key];
    if (!item) {
        if (defaultBlock) {
            item = defaultBlock();
        }
    }
    return item;
}

@end
