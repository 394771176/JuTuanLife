//
//  FFUMengManager.m
//  FFStory
//
//  Created by PageZhang on 16/3/11.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFUMengManager.h"
//#import <UMCCommon/UMCommon.h>
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMCommonLog/UMCommonLogHeaders.h>

#define LOAD_UM  ([FFUMengManager canLoadUM])

@implementation FFUMengManager

+ (BOOL)canLoadUM
{
    return YES;
}

+ (void)configWithAppKey:(NSString *)appKey channel:(NSString *)channel {
    if (!LOAD_UM) {
        return;
    }
    
#ifdef DEBUG
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
#endif
    
    [UMConfigure initWithAppkey:appKey channel:channel];
    [MobClick setCrashReportEnabled:YES];
//    [MobClick startWithAppkey:appKey reportPolicy:SEND_INTERVAL channelId:channel];
}

+ (void)event:(NSString *)event {
    if (event.length) {
        if (LOAD_UM) {
            [MobClick event:event];
        }
    }
}

+ (void)event:(NSString *)event title:(NSString *)title {

    if (title.length) {
        if (LOAD_UM) {
            [MobClick event:event attributes:@{@"title":title}];
        }
    } else {
        [self event:event];
    }
}

+ (void)event:(NSString *)event title:(NSString *)title trail:(NSString *)trail
{
    if (!trail.length) {
        [self event:event title:title];
    } else if (!title.length) {
        [self event:event title:trail];
    } else {
        [self event:event title:[NSString stringWithFormat:@"%@（%@）", title, trail]];
    }
}

+ (void)beginPage:(NSString *)pageName
{
    if (!LOAD_UM) {
        return;
    }
    if (pageName.length) {
        [MobClick beginLogPageView:pageName];
    }
}

+ (void)endPage:(NSString *)pageName
{
    if (!LOAD_UM) {
        return;
    }
    if (pageName.length) {
        [MobClick endLogPageView:pageName];
    }
}
@end
