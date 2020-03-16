//
//  FFConfiguration.m
//  FFStory
//
//  Created by PageZhang on 16/3/3.
//  Copyright © 2016年 Chelun. All rights reserved.
//

//@import CoreLocation;
//@import AVFoundation;
//@import AudioToolbox;
#import "FFConfiguration.h"
#import <libkern/OSAtomic.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface FFPreference : NSObject {
    OSSpinLock lock;
    NSMutableDictionary *_storage;
}
@end

@implementation FFPreference
+ (instancetype)sharedInstance {
    static __strong FFPreference *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self.class new];
    });
    return _instance;
}
- (instancetype)init {
    if (self = [super init]) {
        lock = OS_SPINLOCK_INIT;
        _storage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"APP_Preference"] mutableCopy];
        if (_storage == nil) _storage = [NSMutableDictionary dictionary];
    }
    return self;
}
- (id)valueForConfig:(NSString *)key {
    OSSpinLockLock(&lock);
    id value = _storage[key];
    OSSpinLockUnlock(&lock);
    return value;
}
- (void)setValue:(id)value forConfig:(NSString *)key {
    OSSpinLockLock(&lock);
    _storage[key] = value;
    OSSpinLockUnlock(&lock);
    // 更新配置
    [[NSUserDefaults standardUserDefaults] setObject:_storage forKey:@"APP_Preference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end


@implementation FFConfiguration

#pragma mark - Notif
+ (BOOL)localNotif:(NSString *)body {
    return [self localNotif:nil body:body sound:nil userInfo:nil];
}
+ (BOOL)localNotif:(NSString *)title body:(NSString *)body sound:(NSString *)sound userInfo:(NSDictionary *)userInfo {
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        UILocalNotification *localNotfi = [UILocalNotification new];
        localNotfi.timeZone = [NSTimeZone localTimeZone];
        localNotfi.alertBody = body;
        localNotfi.soundName = sound;
        localNotfi.userInfo = userInfo;
        if ([localNotfi respondsToSelector:@selector(setAlertTitle:)]) {
            localNotfi.alertTitle = title;
        }
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotfi];
        return YES;
    }
    return NO;
}

#pragma mark - Play
+ (void)playSystemVibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
+ (void)playSoundWithName:(NSString *)soundName {
    [self playSoundWithName:soundName vibrate:NO];
}
+ (void)playSoundAndVibrateWithName:(NSString *)soundName {
    [self playSoundWithName:soundName vibrate:YES];
}
+ (void)playSoundWithName:(NSString *)soundName vibrate:(BOOL)vibrate {
    SystemSoundID soundID;
    if (soundName.length) {
        static NSMutableDictionary *soundIDs = nil;
        if (soundIDs == nil) {
            soundIDs = [NSMutableDictionary dictionary];
        }
        if ([soundIDs objectForKey:soundName]) {
            soundID = [[soundIDs objectForKey:soundName] unsignedIntValue];
        } else {
            // 创建音效
            NSURL *filePath = [[NSBundle mainBundle] URLForResource:soundName.stringByDeletingPathExtension withExtension:soundName.pathExtension];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
            [soundIDs setObject:@(soundID) forKey:soundName];
        }
    } else {
        // 调用系统音效 http://iphonedevwiki.net/index.php/AudioServices
        soundID = 1007;
    }
    if (vibrate) {
        AudioServicesPlayAlertSound(soundID);
    } else {
        AudioServicesPlaySystemSound(soundID);
    }
    // 释放音效资源
//        AudioServicesDisposeSystemSoundID(soundID);
}

#pragma mark - Access
+ (BOOL)accessEnable:(FFAccessType)type {
    switch (type) {
        case FFAccessType_PHOTOS: {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            if (status==AVAuthorizationStatusDenied || status==AVAuthorizationStatusRestricted) {
                return NO;
            } else {
                return YES;
            }
//            return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        case FFAccessType_CAMERA: {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status==AVAuthorizationStatusDenied || status==AVAuthorizationStatusRestricted) {
                return NO;
            } else {
                return YES;
            }
//            return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] != AVAuthorizationStatusDenied;
        }
        case FFAccessType_MICROPHONE: {
            __block BOOL _granted = NO;
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession requestRecordPermission:^(BOOL granted) {
                _granted = granted;
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            return _granted;
        }
        case FFAccessType_LOCATION: {
            return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
        }
        case FFAccessType_NOTIFICATION: {
            if (iOS(8)) {
                UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
                if (types == UIUserNotificationTypeNone) {
                    return NO;
                }
            } else {
                UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
                if (type == UIRemoteNotificationTypeNone) {
                    return NO;
                }
            }
            return YES;
        }
        default:break;
    }
}

+ (BOOL)accessEnable:(FFAccessType)type handler:(void (^)(void))handler
{
    BOOL enable = [self accessEnable:type];
    if (handler) {
        if (enable) {
            handler();
        } else {
            [self accessPrompt:type];
        }
    }
    return enable;
}

+ (NSString *)appName
{
    return APP_DISPLAY_NAME;
}

+ (void)accessPrompt:(FFAccessType)type {
    return [self accessPrompt:type content:nil];
}
+ (void)accessPrompt:(FFAccessType)type content:(NSString *)content {
    NSString *message = nil;
    NSString *accessName = @"";
    switch (type) {
        case FFAccessType_PHOTOS: {
            accessName = @"照片";
        } break;
        case FFAccessType_CAMERA: {
            accessName = @"相机";
        } break;
        case FFAccessType_MICROPHONE: {
            accessName = @"麦克风";
        } break;
        case FFAccessType_LOCATION: {
            accessName = @"定位";
        } break;
        case FFAccessType_NOTIFICATION: {
            accessName = @"通知";
        } break;
        default:break;
    }
    message = [NSString stringWithFormat:@"该功能需要%@服务，你可以在设置中打开对\"%@\"的%@服务", accessName, [self appName], accessName];
    // 开启提示
//    FFAlertView *alertView = [[FFAlertView alloc] initWithTitle:@"温馨提示" message:message];
//    [alertView addActionWithTitle:@"设置" handler:^{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    }];
//    [alertView setCancelButtonWithTitle:nil handler:NULL];
//    [alertView showInViewController:nil];
    [self showAlertWithTitle:@"温馨提示" message:message style:UIAlertControllerStyleAlert handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } cancelTitle:@"取消" destructiveTitle:nil confirmTitle:@"设置"];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style handler:(void (^)(UIAlertAction *))handler cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle confirmTitle:(NSString *)confirmTitle
{
    void (^handlerAction)(UIAlertAction *) = ^(UIAlertAction *action) {
        if (handler) {
            handler(action);
        }
    };
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    if (destructiveTitle.length) {
        [alert addAction:[UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            handlerAction(action);
        }]];
    }
    if (confirmTitle.length) {
        [alert addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handlerAction(action);
        }]];
    }
    
    if (cancelTitle.length) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end

