//
//  JTCoreUtil.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTCoreUtil : NSObject

+ (void)openWithLink:(NSString *)link;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler;
+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle destructiveTitle:(NSString *)destructiveTitle handler:(void (^)(UIAlertAction *action))handler;

@end
