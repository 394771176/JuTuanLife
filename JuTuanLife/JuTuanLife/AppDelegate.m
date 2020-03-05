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

@interface AppDelegate () {
    
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
    
}

- (void)windowDidInit:(NSDictionary *)launchOptions
{
    
}

- (UIViewController *)rootController
{
    if ([JTUserManager sharedInstance].isLogined) {
        return [[JTMainController alloc] init];
    } else {
        return [[JTLoginHomeController alloc] init];
    }
}

- (void)windowDidAppear:(NSDictionary *)launchOptions
{
    UIViewController *root = [self rootController];
    DTNavigationController *navC = [[DTNavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = navC;
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


@end
