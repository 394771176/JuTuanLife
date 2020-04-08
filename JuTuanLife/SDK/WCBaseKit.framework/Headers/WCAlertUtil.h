//
//  WCAlertUtil.h
//  WCBaseKit
//
//  Created by cheng on 2020/4/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCAlertUtil : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler cancel:(void (^)(UIAlertAction *action))cancelHandler;

+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style handler:(void (^)(UIAlertAction *action))handler cancel:(void (^)(UIAlertAction *action))cancelHandler cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle confirmTitle:(NSString *)confirmTitle, ... NS_REQUIRES_NIL_TERMINATION;

@end
