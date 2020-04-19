//
//  JTBaseManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBaseManager.h"
#import "JTRefreshHeaderView.h"
#import "JTLoadingView.h"

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
    [dict safeSetObject:APP_PROJECT_NAME forKey:@"jt_app"];
    [dict safeSetObject:APP_VERSION_SHORT forKey:@"jt_appVersion"];
    [dict safeSetObject:@"iOS" forKey:@"jt_os"];
    [dict safeSetObject:[JTNetManager sharedInstance].deviceModel forKey:@"jt_device"];
    [dict safeSetObject:[JTNetManager sharedInstance].osVersion forKey:@"jt_osVersion"];
    
    BOOL isLogin = [JTUserManager sharedInstance].isLogined;
    if (isLogin) {
        NSString *token = [JTUserManager sharedInstance].ac_token;
        [dict safeSetObject:token forKey:@"jt_userToken"];
        
        NSString *name = [JTUserManager sharedInstance].user.name;
        [dict safeSetObject:[name urlEncoded] forKey:@"jt_userName"];
    }
    return dict;
}

- (id<WCBaseUIRefreshHeaderViewProtocol>)getRefreshHeaderView:(DTHttpRefreshTableController *)controller
{
    JTRefreshHeaderView *view = [[JTRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -60, controller.view.width, 60)];
    return view;
}

- (id<WCBaseUILoadingIndicatorProtocol>)getLoadingIndicator:(DTViewController *)controller
{
    return [[JTLoadingView alloc] init];
}

@end
