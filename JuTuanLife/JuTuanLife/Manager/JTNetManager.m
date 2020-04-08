//
//  JTNetManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTNetManager.h"

@interface JTNetManager () {
    NSMutableDictionary *_systemParams;
}

@end

@implementation JTNetManager

+ (void)setupNetManager
{
    JTNetManager *manager = [self sharedInstance];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSystemParams];
    }
    return self;
}

- (void)setupSystemParams
{
    if (_systemParams == nil) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params safeSetObject:@"app" forKey:@"_platform"];
        [params safeSetObject:@"ios" forKey:@"_os"];
        [params safeSetObject:APP_PROJECT_NAME forKey:@"_caller"];
        [params safeSetObject:APP_VERSION_SHORT forKey:@"_appVersion"];
        [params safeSetObject:[UIDevice currentDevice].systemVersion forKey:@"_sysVersion"];
        [params safeSetObject:[self.class machineModel] forKey:@"_model"];
        [params safeSetObject:[self.class openUDID] forKey:@"_openUDID"];
        [params safeSetObject:@"AppStore" forKey:@"_appChannel"];
        //        [params safeSetObject:[self.class clientUDID] forKey:@"cUDID"];
        if (APP_DEBUG) {
            [params safeSetObject:@"true" forKey:@"__intern__show-error-mesg"];
        }
        // jailbroken
        //        if ([self.class isJailbroken]) {
        //            [params safeSetObject:@"1" forKey:@"jb"];
        //        }
        _systemParams = params;
    }
}

- (NSString *)osVersion
{
    return [_systemParams stringForKey:@"_sysVersion"];
}

- (NSString *)deviceModel
{
    return [_systemParams stringForKey:@"_model"];
}

- (NSString *)openUDID
{
    return [_systemParams stringForKey:@"_openUDID"];
}

#pragma mark - WCNetManagerProtocol

- (NSString *)userToken
{
    return [JTUserManager sharedInstance].ac_token;
}

- (void)setUserTokenParams:(NSMutableDictionary *)params
{
    [params safeSetObject:[self userToken] forKey:@"_ac_token"];
}

- (NSDictionary *)systemParams
{
    return _systemParams;
}

@end
