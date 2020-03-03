//
//  DTAppPreference.m
//  DrivingTest
//
//  Created by cheng on 17/3/2.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTAppPreferenceManager.h"
#import "BPFileUtil.h"
#import <WCCategory/WCCategory.h>

#define APP_CONST_APP_PREFERENCE_VERSION_KEY    @"app.const.app.preference.version.key"

@interface DTAppPreferenceManager () {
    NSMutableDictionary *_managerDict;
}

@end

@implementation DTAppPreferenceManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

+ (BPAppPreference *)sharedFileName:(NSString *)fileName
{
    return [[self sharedInstance] appPreferenceWithFileName:fileName];
}

+ (BPAppPreference *)answerAppPreference
{
    return [self sharedFileName:@"dt_answer.plist"];
}

+ (BPAppPreference *)userSessionAppPreference
{
    return [self sharedFileName:@"dt_user_session.plist"];
}

+ (BPAppPreference *)userCityAppPreference
{
    return [self sharedFileName:@"dt_user_city.plist"];
}

+ (BPAppPreference *)courseAppPreference
{
    return [self sharedFileName:@"dt_course.plist"];
}

+ (BPAppPreference *)favAppPreference
{
    return [self sharedFileName:@"dt_plate_fav.plist"];
}

+ (BPAppPreference *)todayAppPreference
{
    return [self sharedFileName:@"dt_today.plist"];
}

+ (BPAppPreference *)skillAppPreference
{
    return [self sharedFileName:@"dt_skill.plist"];
}

+ (BPAppPreference *)smartAppPreference
{
    return [self sharedFileName:@"dt_smart.plist"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _managerDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BPAppPreference *)appPreferenceWithFileName:(NSString *)fileName
{
    if (!fileName || fileName.length <= 0) {
        return [BPAppPreference sharedInstance];
    } else {
        BPAppPreference *item = [_managerDict objectForKey:fileName];
        if (!item) {
            NSString *path = [self getAppPreferencePathWithFileName:fileName];
            item = [[BPAppPreference alloc] initWithFilePath:path];
            [_managerDict safeSetObject:item forKey:fileName];
        }
        return item;
    }
}

- (NSString *)getAppPreferencePathWithFileName:(NSString *)fileName
{
    return [BPFileUtil getDocumentPathWithDir:@"appPreference" fileName:fileName];
}

static int preference_Version = 3;

+ (void)clearAppPreferenceOldKey
{
    NSInteger preferenceVersion = [[BPAppPreference sharedInstance] integerForKey:APP_CONST_APP_PREFERENCE_VERSION_KEY];
    switch (preferenceVersion) {
        case 0:
        {
            [[BPAppPreference sharedInstance] removeObjectForKey:@"app.const.key.enroll.mode.status"];
            [[BPAppPreference sharedInstance] removeObjectForKey:@"app.const.key.enroll.mode.tips"];
            [[BPAppPreference sharedInstance] removeObjectForKey:@"app.const.key.enroll.mode.tips.date"];
            [[BPAppPreference sharedInstance] removeObjectForKey:@"app.const.key.enroll.my.bind.coach.info"];
            [[BPAppPreference sharedInstance] removeObjectForKey:@"gccar.param.group.list.cached.key_6_0_4"];
            [[BPAppPreference sharedInstance] removeObjectForKey:@"app.const.vip.course.comments.index"];
            //移除废弃的 6.6.0
            [[BPAppPreference sharedInstance] removeObjectForKey:@"app.const.user.last.select.tab.index"];
        }
        case 1:
        {
            
        }
        case 2:
        {
            [[BPAppPreference sharedInstance] removeObjectForKey:@"ActivityVipCountConfigDic"];
        }
        case 3:
        {
            
        }
            break;
            //不要break, 依次执行
        default:
            break;
    }
    [self updateAppPreferenceVersion];
}

+ (void)updateAppPreferenceVersion
{
    [[BPAppPreference sharedInstance] setInteger:preference_Version forKey:APP_CONST_APP_PREFERENCE_VERSION_KEY];
}

@end

@implementation BPAppPreference (DTUpdate)

- (BPAppPreference *)validAppPreference_dt
{
    if ([self isUpdateSuccess_dt]) {
        return self;
    } else {
        return [BPAppPreference sharedInstance];
    }
}

- (BOOL)isUpdateSuccess_dt
{
    return [self boolForKey:APP_CONST_PREFERENCE_MANAGER_UPDATE_SUCCESS];
}

- (void)setUpdateSuccess_dt
{
    [self setBool:YES forKey:APP_CONST_PREFERENCE_MANAGER_UPDATE_SUCCESS];
}

- (void)updateValueWithKey_dt:(NSString *)key
{
    if (self != [BPAppPreference sharedInstance] && key.length) {
        id obj = [[BPAppPreference sharedInstance] objectForKey:key];
        if (obj) {
            [self setObject:obj forKey:key];
            [[BPAppPreference sharedInstance] removeObjectForKey:key];
        }
    }
}

- (void)updateValueWithKeyArray_dt:(NSArray *)keys
{
    for (NSString *key in keys) {
        [self updateValueWithKey_dt:key];
    }
}

- (void)checkUpdateValueWithKeyArray_dt:(NSArray *)keys
{
    if (![self isUpdateSuccess_dt]) {
        [self updateValueWithKeyArray_dt:keys];
        [self setUpdateSuccess_dt];
    }
}

- (void)clearAllKey
{
    NSDictionary *dict = [self valueForKey:@"mutableDict"];
    if (dict) {
        [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObjectForKey:obj];
        }];
    }
}

@end
