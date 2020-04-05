//
//  BPAppDelegate.h
//  BPCommon
//
//  Created by Huang Tao on 7/11/13.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, APPLaunchType) {
    APPLaunchTypeNormal,//正常
    APPLaunchTypeInstall,//新安装
    APPLaunchTypeUpgrade,//升级
};

extern NSString *const APP_KEY_COM_FIRST_LOAD;
extern NSString *const APP_KEY_COM_BUNDLE_VERSION;

@interface BPAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) APPLaunchType launchType;

/*
 只会在第一次启动app时调用，以APP_KEY_COM_FIRST_LOAD为key
 调用失败会重试
 @return 返回YES，之后不会被调用；否则，下次启动仍会调用
 */
- (void)appFirstInstall;

/*
 只会在app升级时调用，根据版本号判断，第一次安装不调用
 调用失败会重试
 @return 返回YES，下次升级之前不会被调用；否则，下次启动仍会调用
 */
- (void)appUpgrade;

//launch
- (void)launchWillInit:(NSDictionary *)launchOptions;

/*
 window实例初始化之前调用
 */
- (void)windowWillInit:(NSDictionary *)launchOptions;

/*
 window实例初始化之后makeKeyAndVisible之前调用
 */
- (void)windowDidInit:(NSDictionary *)launchOptions;

/*
 window makeKeyAndVisible之后调用
 */
- (void)windowDidAppear:(NSDictionary *)launchOptions;

@end
