//
//  JTCoreUtil.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTCoreUtil.h"

@implementation JTCoreUtil

+ (void)openWithLink:(NSString *)link
{
    NSLog(@"open link : %@", link);
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler
{
    [self showAlertWithTitle:title message:message style:UIAlertControllerStyleAlert cancelTitle:cancelTitle confirmTitle:confirmTitle destructiveTitle:destructiveTitle handler:handler];
}

+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler
{
    [self showAlertWithTitle:title message:message style:UIAlertControllerStyleActionSheet cancelTitle:cancelTitle confirmTitle:confirmTitle destructiveTitle:destructiveTitle handler:handler];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler
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
    [[WCControllerUtil topContainerController] presentViewController:alert animated:YES completion:nil];
}

@end
