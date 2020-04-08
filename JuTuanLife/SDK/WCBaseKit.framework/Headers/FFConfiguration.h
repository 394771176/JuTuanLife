//
//  FFConfiguration.h
//  FFStory
//
//  Created by PageZhang on 16/3/3.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FFAccessType) {
    FFAccessType_PHOTOS,
    FFAccessType_CAMERA,
    FFAccessType_MICROPHONE,
    FFAccessType_LOCATION,
    FFAccessType_NOTIFICATION
};

@interface FFConfiguration : NSObject

// 系统通知
+ (BOOL)localNotif:(NSString *)body;
+ (BOOL)localNotif:(NSString *)title body:(NSString *)body sound:(NSString *)sound userInfo:(NSDictionary *)userInfo;

// 声音和振动
+ (void)playSystemVibrate;
+ (void)playSoundWithName:(NSString *)soundName;
+ (void)playSoundAndVibrateWithName:(NSString *)soundName;

// 系统权限
+ (BOOL)accessEnable:(FFAccessType)type;
+ (BOOL)accessEnable:(FFAccessType)type handler:(void (^)(void))handler;

// 系统权限提示
+ (void)accessPrompt:(FFAccessType)type;
+ (void)accessPrompt:(FFAccessType)type content:(NSString *)content;

@end
