//
//  BPAppDelegate.m
//  BPCommon
//
//  Created by Huang Tao on 7/11/13.
//
//

#import "BPAppDelegate.h"
#import <WCModel/BPFileUtil.h>
#import <WCModel/BPAppPreference.h>

NSString *const APP_KEY_COM_FIRST_LOAD      =  @"app.key.com.first.load";
NSString *const APP_KEY_COM_BUNDLE_VERSION  =  @"app.key.com.bundle.version";

@implementation BPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    {
        NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (pathList.count>0) {
            [BPFileUtil addSkipBackupAttributeToItemAtPath:[pathList objectAtIndex:0]];
        }
    }
    {
        NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        if (pathList.count>0) {
            [BPFileUtil addSkipBackupAttributeToItemAtPath:[pathList objectAtIndex:0]];
        }
    }
    
    _launchType = APPLaunchTypeNormal;
    
    [self launchWillInit:launchOptions];
    
    NSString *curVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (![[BPAppPreference sharedInstance] boolForKey:APP_KEY_COM_FIRST_LOAD]) {
        _launchType = APPLaunchTypeInstall;
        [self appFirstInstall];
        [[BPAppPreference sharedInstance] setBool:YES forKey:APP_KEY_COM_FIRST_LOAD];
        [[BPAppPreference sharedInstance] setObject:curVer forKey:APP_KEY_COM_BUNDLE_VERSION];
    } else {
        NSString *lastVer = [[BPAppPreference sharedInstance] stringForKey:APP_KEY_COM_BUNDLE_VERSION];
        if ([NSString checkIsEmpty:lastVer] || ![lastVer isEqualToString:curVer]) {
            _launchType = APPLaunchTypeUpgrade;
            [self appUpgrade];
            [[BPAppPreference sharedInstance] setObject:curVer forKey:APP_KEY_COM_BUNDLE_VERSION];
        }
    }
    
    [self windowWillInit:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    [self windowDidInit:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    [self windowDidAppear:launchOptions];
    
    return YES;
}

- (void)appFirstInstall
{
    
}

- (void)appUpgrade
{
    
}

- (void)launchWillInit:(NSDictionary *)launchOptions
{
    
}

- (void)windowWillInit:(NSDictionary *)launchOptions
{
    
}

- (void)windowDidInit:(NSDictionary *)launchOptions
{
    
}

- (void)windowDidAppear:(NSDictionary *)launchOptions
{
    
}

@end
