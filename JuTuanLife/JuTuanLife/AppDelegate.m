//
//  AppDelegate.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/3.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "AppDelegate.h"
#import "JTMainController.h"
#import "JTLoginHomeController.h"

@interface AppDelegate ()
<UIDocumentInteractionControllerDelegate>
{
    NSTimeInterval _minDuration;
}

@end

@implementation AppDelegate

- (void)appFirstInstall
{
    
}

- (void)appUpgrade
{
    
}

- (void)windowWillInit:(NSDictionary *)launchOptions
{
    [JTNetManager setupNetManager];
    
    [JTDataManager setupManager];
    
    [FFUMengManager configWithAppKey:APP_UMENG_KEY channel:@"APP Store"];
    [[FFWechatManager sharedInstance] configWithAppKey:APP_WX_APPID appSecret:APP_WX_APPSECRET];
}

- (void)windowDidInit:(NSDictionary *)launchOptions
{
    
}

- (void)windowDidAppear:(NSDictionary *)launchOptions
{
    UIViewController *root = [JTUserManager rootController];
    DTNavigationController *navC = [[DTNavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = navC;
    
    [[JTUserManager sharedInstance] refreshForLaunch:YES];
    
    if (self.launchType == APPLaunchTypeInstall) {
        [FFUMengManager event:@"100_app_launch" title:@"新安装"];
    } else if (self.launchType == APPLaunchTypeUpgrade) {
        [FFUMengManager event:@"100_app_launch" title:@"升级"];
    } else {
        [FFUMengManager event:@"100_app_launch" title:@"启动"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:JTUIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (_minDuration < 1) {
        _minDuration = 60;
        [[JTUserManager sharedInstance] refreshForLaunch:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:JTUIApplicationWillEnterForegroundNotification object:nil];
        WEAK_SELF
        [DTPubUtil addBlock:^{
            STRONG_SELF
            self -> _minDuration = 0;
        } withDelay:_minDuration];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // 判断传过来的url是否为文件类型
    if ([url.scheme isEqualToString:@"file"]) {
        UIDocumentInteractionController *_docVc = [UIDocumentInteractionController interactionControllerWithURL:url];
        _docVc.delegate = self;
        [_docVc presentPreviewAnimated:YES];
        return YES;
    }
    return [WXApi          handleOpenURL:url delegate:[FFWechatManager sharedInstance]] ||
    [JTLinkUtil handleOpenURL:url];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self application:application handleOpenURL:url];
}
#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [self application:application handleOpenURL:url];
}
#endif

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return [WCControllerUtil topContainerController];
}

@end
