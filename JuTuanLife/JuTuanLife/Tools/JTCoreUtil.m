//
//  JTCoreUtil.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTCoreUtil.h"
#import <WCModule/RegexKitLite.h>

@implementation JTCoreUtil

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler
{
    [self showAlertWithTitle:title message:message cancelTitle:cancelTitle confirmTitle:confirmTitle destructiveTitle:destructiveTitle handler:handler cancel:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler cancel:(void (^)(UIAlertAction *))cancelHandler
{
    [self showAlertWithTitle:title message:message style:UIAlertControllerStyleAlert cancelTitle:cancelTitle confirmTitle:confirmTitle destructiveTitle:destructiveTitle handler:handler cancel:cancelHandler];
}

+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler
{
    [self showAlertWithTitle:title message:message style:UIAlertControllerStyleActionSheet cancelTitle:cancelTitle confirmTitle:confirmTitle destructiveTitle:destructiveTitle handler:handler cancel:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler cancel:(void (^)(UIAlertAction *action))cancelHandler
{
    [self showAlertWithTitle:title message:message style:style handler:handler cancel:cancelHandler cancelTitle:cancelTitle destructiveTitle:destructiveTitle confirmTitle:confirmTitle, nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style handler:(void (^)(UIAlertAction *))handler cancel:(void (^)(UIAlertAction *))cancelHandler cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle confirmTitle:(NSString *)confirmTitle, ...
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
        va_list args;
        va_start(args, confirmTitle);
        for (id currentObject = confirmTitle; currentObject != nil; currentObject = va_arg(args, id)) {
            [alert addAction:[UIAlertAction actionWithTitle:currentObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                handlerAction(action);
            }]];
        }
        va_end(args);
    }
    
    if (cancelTitle.length) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelHandler) {
                cancelHandler(action);
            }
        }]];
    }
    [[WCControllerUtil topContainerController] presentViewController:alert animated:YES completion:nil];
}

+ (void)callPhoneNumber:(NSString *)phone
{
    if (phone.length<=0) {
        [DTPubUtil showHUDErrorHintInWindow:@"电话号码不能为空"];
        return;
    }
    //telprompt:
    //NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"telprompt:%@",phone]];
    NSString *strDeviceType = [UIDevice currentDevice].model;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]];
    BOOL canMakeCall = YES;
    if ([strDeviceType isEqualToString:@"iPod touch"] || [strDeviceType isEqualToString:@"iPad"] || [strDeviceType isEqualToString:@"iPhone Simulator"]) {
        canMakeCall = NO;
    }
    if (canMakeCall && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [DTPubUtil showHUDErrorHintInWindow:@"该设备不支持拨号服务"];
    }
}

+ (BOOL)isValidPassword:(NSString *)passwrod
{
    if (!passwrod.length||![passwrod isMatchedByRegex:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$"]) {
        return NO;
    } else {
        return YES;
    }
}

@end
