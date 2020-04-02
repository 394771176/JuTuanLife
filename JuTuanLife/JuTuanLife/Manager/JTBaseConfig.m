//
//  JTBaseConfig.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBaseConfig.h"

@implementation JTBaseConfig

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.about_us_url = [dic stringForKey:@"app_jutuan_conf.about_us_url"];
    NSString *whiteListStr = [dic objectForKey:@"app_jutuan_conf.h5_domain_whitelist"];
    if (whiteListStr.length) {
        NSMutableArray *whiteList = [whiteListStr componentsSeparatedByString:@","].mutableCopy;
        [whiteList removeObject:@""];
        self.h5_domain_whitelist = whiteList;
    }
    self.deposit_deduct_text = [dic stringForKey:@"app_jutuan_conf.deposit_deduct_text"];
    
    return YES;
}

@end
