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
    
}

@end

@implementation AppDelegate

- (BOOL)firstSetUp
{
    return YES;
}

- (BOOL)appUpgrade
{
    return YES;
}

- (void)windowWillInit:(NSDictionary *)launchOptions
{
    [JTNetManager setupNetManager];
    
    [JTDataManager setupManager];
    
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
    
    [[JTUserManager sharedInstance] refreshUserInfoForLaunch];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
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
