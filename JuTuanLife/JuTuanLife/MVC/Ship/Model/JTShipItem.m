//
//  JTShipItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTShipItem.h"

@implementation JTShipItem

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.commAmt = _commAmt / 100;
    return YES;
}

- (NSString *)relationTypeName
{
    return [self.class relationTypeName:_relationType];
}

+ (NSString *)relationTypeName:(NSInteger)type
{
    switch (type) {
        case 0:
            return @"自己";
            break;
        case 1:
            return @"徒弟";
            break;
        case 2:
            return @"徒孙";
            break;
        default:
            return nil;
            break;
    }
}

@end
