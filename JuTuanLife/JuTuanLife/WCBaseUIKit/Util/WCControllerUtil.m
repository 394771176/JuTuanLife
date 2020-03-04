//
//  WCControllerUtil.m
//  Pods
//
//  Created by cheng on 2020/3/1.
//

#import "WCControllerUtil.h"

@interface UIViewController (WCControllerUtil)

- (id)currentController;

@end

@implementation WCControllerUtil

+ (UIWindow *)appWindow
{
    return [[UIApplication sharedApplication].delegate window];
}

+ (UIViewController *)rootController
{
    return [self appWindow].rootViewController;
}

+ (UIViewController *)topContainerController
{
    UIViewController *controller = [self rootController];
    while (controller.presentedViewController) {
        if (iOS(8)) {
            if ([controller.presentedViewController isKindOfClass:[UIAlertController class]]) {
                break;
            }
        }
        controller = controller.presentedViewController;
    }
    return controller;
}

+ (UIViewController *)topStackController
{
    UINavigationController *top = (id)[self topContainerController];
    if ([top isKindOfClass:UINavigationController.class]) {
        return top.topViewController;
    }
    return top;
}

+ (UIViewController *)topCurrentController
{
    UIViewController *vc = [self topStackController];
    if ([vc respondsToSelector:@selector(currentController)]) {
        vc = [vc currentController];
    }
    return vc;
}

+ (void)pushViewController:(UIViewController *)controller
{
    id top = [self topContainerController];
    if (top) {
        if ([top isKindOfClass:UINavigationController.class]) {
            [top pushViewController:controller animated:YES];
        } else {
            [top presentViewController:controller animated:YES completion:nil];
        }
    }
}

@end
