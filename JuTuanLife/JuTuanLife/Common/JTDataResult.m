//
//  JTDataResult.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/6.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTDataResult.h"

@implementation JTDataResult

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *superDict = [super modelCustomPropertyMapper];
    if (superDict.count) {
        [dict addEntriesFromDictionary:superDict];
    }
    [dict safeSetObject:@"result" forKey:@"data"];
    return dict;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.code = (int)_status;
    self.success = (_status == 20000202);
    return YES;
}

@end
