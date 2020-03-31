//
//  WCBarItemUtil.m
//  Pods
//
//  Created by cheng on 2020/3/2.
//

#import "WCBarItemUtil.h"
#import "WCUICommon.h"

@implementation WCBarItemUtil

// MARK: - Barbutton
+ (UIBarButtonItem *)backBarButtonItemTarget:(id)target action:(SEL)action
{
    return [self barButtonItemWithImage:[UIImage imageNamed:@"nav_back_b"] target:target action:action];
}

+ (UIBarButtonItem *)closeBarButtonItemTarget:(id)target action:(SEL)action
{
    return [self barButtonItemWithImage:[UIImage imageNamed:@"nav_close_b"] target:target action:action];
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    item.tintColor = [WCAppStyleUtil navBarItemColor];
    return item;
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    item.tintColor = [WCAppStyleUtil navBarItemColor];
    return item;
}

+ (UIBarButtonItem *)barButtonItemWithCustomImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.exclusiveTouch = YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action
{
    UIFont *font = [UIFont systemFontOfSize:17];
    return [self barButtonItemWithTitle:title color:color font:font target:target action:action];
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    
    CGFloat width = [btn.titleLabel getTextWidth]+10;
    if (width < 44) {
        width = 44;
    } else if (width > 88) {
        width = 88;
    }
    btn.width = width;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.exclusiveTouch = YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIImage *)backImageForTranslucent
{
    CGRect rect = CGRectMake(0, 0, 28, 28);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.4] cornerRadius:rect.size.height/2 withSize:rect.size] drawInRect:rect];
    
    UIImage *img = [UIImage imageNamed:@"nav_back"];
    [img drawInRect:CGRectMake(floorf(rect.size.width/2-img.size.width/2), floorf(rect.size.height/2-img.size.height/2), img.size.width, img.size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIButton *)backButtonItemTarget:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(6, 20, 40, 40);
    [btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)backButtonBgItemTarget:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(6, 20, 40, 40);
    [btn setImage:[self backImageForTranslucent] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
