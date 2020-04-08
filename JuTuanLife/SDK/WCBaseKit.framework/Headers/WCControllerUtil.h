//
//  WCControllerUtil.h
//  Pods
//
//  Created by cheng on 2020/3/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PUSH_VC(_xxx_)  \
{ \
UIViewController *vc = [[_xxx_ alloc] init]; \
[WCControllerUtil pushViewController:vc]; \
}

#define PUSH_VC_WITH(_xxx_, _block_)  \
{ \
_xxx_ *vc = [[_xxx_ alloc] init]; \
{ \
_block_; \
} \
[WCControllerUtil pushViewController:vc]; \
}

#define PRESENT_VC(_xxx_)  \
{ \
_xxx_ *vc = [[_xxx_ alloc] init]; \
[WCControllerUtil presentViewController:vc]; \
}

@interface WCControllerUtil : NSObject

//+ (void)setMainController:(id)controller;
//+ (UIViewController *)mainController;
//+ (UIViewController *)mainCurrentController;

+ (UIWindow *)appWindow;

+ (UIViewController *)rootController;

//当前最顶部容器界面，一般返回Nav
+ (UIViewController *)topContainerController;

//当前栈顶界面，一般返回Nav的top
+ (UIViewController *)topStackController;

/*
 当前栈顶子界面，一般返回Nav的top的currentController,
 如果没有子界面，则返回自身，此时等同topStackController
 */
+ (UIViewController *)topCurrentController;

+ (void)pushViewController:(UIViewController *)controller;

+ (void)pushViewController:(UIViewController *)controller popOne:(BOOL)popOne;

+ (void)presentViewController:(UIViewController *)controller;

@end
