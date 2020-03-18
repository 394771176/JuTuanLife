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
    if ([NSDictionary validDict:data]) {
        self.pos = [data stringForKey:@"lastPos"];
    }
    return data;
}

@end
