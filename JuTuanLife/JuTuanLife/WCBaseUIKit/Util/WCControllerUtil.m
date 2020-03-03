//
//  WCControllerUtil.m
//  Pods
//
//  Created by cheng on 2020/3/1.
//

#import "WCControllerUtil.h"

@implementation WCControllerUtil

+ (UIWindow *)appWindow
{
    return [[UIApplication sharedApplication].delegate window];
}

+ (UIViewController *)rootController
{
    return nil;
}

+ (UIViewController *)topContainerController
{
    return nil;
}

+ (UIViewController *)topStackController
{
    return nil;
}

+ (UIViewController *)topCurrentController
{
    return nil;
}

@end
