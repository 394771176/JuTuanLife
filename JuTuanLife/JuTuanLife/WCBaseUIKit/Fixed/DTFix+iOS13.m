//
//  DTFix+iOS13.m
//  DrivingTest
//
//  Created by cheng on 2020/1/6.
//  Copyright © 2020 eclicks. All rights reserved.
//

#import "DTFix+iOS13.h"

@implementation DTFix_iOS13

@end

@implementation UIViewController (DT_iOS13)

#ifdef __IPHONE_13_0

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0

+ (void)load
{
    DT_Swizzle(@selector(presentViewController:animated:completion:), @selector(cl_presentViewController:animated:completion:));
}

- (void)cl_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        if (!viewControllerToPresent.allowModalPresentationPageSheet && viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    [self cl_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#endif

#endif

- (void)setAllowModalPresentationPageSheet:(BOOL)allowModalPresentationPageSheet {
    objc_setAssociatedObject(self, @selector(allowModalPresentationPageSheet), @(allowModalPresentationPageSheet), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)allowModalPresentationPageSheet {
    NSNumber *obj = objc_getAssociatedObject(self, @selector(allowModalPresentationPageSheet));
    return obj ? [obj boolValue] : NO;
}

@end

@implementation UIApplication (DT_iOS13)

#ifdef __IPHONE_13_0 //判断编译器xcode是否支持ios13的SDK

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0 //判断终端手机是否支持ios13的SDK

+ (void)load
{
    DT_Swizzle(@selector(setStatusBarStyle:), @selector(cl_setStatusBarStyle:));
    DT_Swizzle(@selector(setStatusBarStyle:animated:), @selector(cl_setStatusBarStyle:animated:));
}

- (void)cl_setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    [self cl_setStatusBarStyle:[self cl_style:statusBarStyle]];
}

- (void)cl_setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated
{
    [self cl_setStatusBarStyle:[self cl_style:statusBarStyle] animated:animated];
}

- (UIStatusBarStyle)cl_style:(UIStatusBarStyle)style
{
    if (@available(iOS 13.0, *)) {
        if (style == UIStatusBarStyleDefault) {
            return UIStatusBarStyleDarkContent;
        }
    }
    return style;
}

#endif

#endif

@end


@implementation UISearchBar (DT_iOS13)

- (UITextField *)searchField
{
    #ifdef __IPHONE_13_0
    if (AvailableiOS(13.0)) {
        return self.searchTextField;
    }
    #endif
    return [self valueForKey:@"_searchField"];
}

- (void)setSearchFieldPlaceholderFont:(UIFont *)font
{
    if (AvailableiOS(13.0)) {
        
    } else {
        /*
         UITextField *searchField = [searchBar valueForKey:@"_searchField"];
         if (searchField) {
             [searchField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
         }
         */
        if (self.searchField) {
            [self.searchField setValue:font forKeyPath:@"_placeholderLabel.font"];
        }
    }
}

- (void)setSearchFieldPlaceholderColor:(UIColor *)color
{
    if (AvailableiOS(13.0)) {
        
    } else {
        if (self.searchField) {
            [self.searchField setValue:color forKeyPath:@"_placeholderLabel.color"];
        }
    }
}
@end
