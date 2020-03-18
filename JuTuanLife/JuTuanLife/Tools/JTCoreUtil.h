//
//  JTCoreUtil.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTCoreUtil : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler;

+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle confirmTitle:(NSString *)confirmTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (BOOL)isValidPassword:(NSString *)passwrod;

+ (NSString *)showDateWith:(NSString *)date;

@end
