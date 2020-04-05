//
//  JTPosListDataModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/18.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTPosListDataModel.h"

@implementation JTPosListDataModel

- (id)parseData:(id)data
{
    if (self.result.code == 40008201 || self.result.code == 40009201) {
        [JTService addBlockOnMainThread:^{
            [DTPubUtil showHUDErrorHintInWindow:@"登录信息已过期，请重新登录"];
            [JTUserManager logoutAction:nil];
        }];
    }
    if ([NSDictionary validDict:data]) {
        self.pos = [data stringForKey:@"lastPos"];
    }
    return data;
}

@end
