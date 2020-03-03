//
//  WCBarItemUtil.h
//  Pods
//
//  Created by cheng on 2020/3/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCBarItemUtil : NSObject

// MARK: - Barbutton
+ (UIBarButtonItem *)backBarButtonItemTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)closeBarButtonItemTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithCustomImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;

// MARK: - 无导航栏时 返回按钮
+ (UIButton *)backButtonItemTarget:(id)target action:(SEL)action;
+ (UIButton *)backButtonBgItemTarget:(id)target action:(SEL)action;

@end
