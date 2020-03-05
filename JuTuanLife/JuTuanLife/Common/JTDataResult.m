//
//  JTDataResult.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/6.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTDataResult.h"

@implementation JTDataResult

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.code = (int)_status;
    self.data = [dic objectForKey:@"result"];
    self.success = (_status == 20000202);
    return YES;
}

@end
