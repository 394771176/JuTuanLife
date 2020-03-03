//
//  DTTabItem.m
//  DrivingTest
//
//  Created by cheng on 2017/11/30.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTTabItem.h"

@implementation DTTabItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"beyond_bounds" : @"allow_overflow"};
}

@end
