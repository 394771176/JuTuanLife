//
//  JTBaseManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBaseManager.h"

@interface JTBaseManager ()
<WCBaseManagerProtocol>
{
    
}

@end

@implementation JTBaseManager

SHARED_INSTANCE_M

+ (void)setupManager
{
    [JTNetManager setupNetManager];
    [WCBaseManager setupManager:[self sharedInstance]];
}

#pragma mark - WCBaseManagerProtocol

- (NSArray *)domainWhiteList
{
    return [JTDataManager sharedInstance].baseConfig.h5_domain_whitelist;
}

- (NSDictionary *)appInsertCookiesList
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    return dict;
}

@end
