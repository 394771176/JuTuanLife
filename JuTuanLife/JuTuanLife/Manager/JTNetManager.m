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

SHARED_INSTANCE_M

+ (void)setupNetManager
{
    [self sharedInstance];
//    [WCNetManager sharedInstance].defaultTimeOut = 15;
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
        [params safeSetObject:[WCSystemUtil systemVersion] forKey:@"_sysVersion"];
        [params safeSetObject:[WCSystemUtil deviceModel] forKey:@"_model"];
        [params safeSetObject:[WCSystemUtil openUDID] forKey:@"_openUDID"];
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

- (NSDictionary *)systemParams
{
    return _systemParams;
}

@end
