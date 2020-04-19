//
//  JTLinkUtil.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLinkUtil.h"
#import "JTMineHomeController.h"

@implementation JTLinkUtil

+ (JTWebViewController *)getWebControllerWith:(NSString *)link
{
    JTWebViewController *vc = [[JTWebViewController alloc] init];
    vc.urlStr = link;
    vc.fromLinkUtil = YES;
    return vc;
}

+ (UIViewController *)getNativeControllerWith:(NSString *)link
{
    if ([link containsString:@"://open/webview"]) {
        NSString *url = [link getUrlParamValueForkey:@"url"];
        return [self getControllerWithLink:url];
    }
    if ([link containsString:@"://open/app"]) {
        NSString *scheme = [link getUrlParamValueForkey:@"scheme"];
        if (scheme.length) {
            NSURL *schemeURL = [NSURL URLWithString:scheme];
            if ([[UIApplication sharedApplication] canOpenURL:schemeURL]) {
                return [DTLinkBlankController controllerWithBlock:^(id userInfo) {
                    [[UIApplication sharedApplication] openURL:userInfo];
                } userInfo:schemeURL];
            }
        }
        NSString *url = [link getUrlParamValueForkey:@"url"];
        return [self getControllerWithLink:url];
    }
    if ([link containsString:@"://app/mainTab"]) {
        NSInteger index = [link getUrlParamIntForkey:@"index"];
        return [DTLinkBlankController controllerWithBlock:^(NSInteger num) {
            
        } index:index];
    }
    
    return nil;
}

+ (UIViewController *)getControllerWithLink:(NSString *)link
{
    return [self getControllerWithLink:link forcePush:YES];
}

+ (UIViewController *)getControllerWithLink:(NSString *)link forcePush:(BOOL)forcePush
{
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (([link hasPrefix:@"http://"] || [link hasPrefix:@"https://"]) && forcePush) {
        return [self getWebControllerWith:link];
    } else {
        return [self getNativeControllerWith:link];
    }
}

//是否允许打开链接，如
+ (BOOL)shouldOpenLink:(NSString *)link
{
    return YES;
}

+ (BOOL)openWithLink:(NSString *)link
{
    return [self openWithLink:link popOne:NO];
}

+ (BOOL)openWithLink:(NSString *)link popOne:(BOOL)popOne
{
    if ([self shouldOpenLink:link]) {
        UIViewController *vc = [self getControllerWithLink:link];
        [self checkOpenController:vc withLink:link popOne:popOne];
        return vc != nil;
    }
    return NO;
}

+ (void)checkOpenController:(UIViewController *)controller withLink:(NSString *)link popOne:(BOOL)popOne
{
    if (controller == nil) {
        return;
    }
    if ([controller isKindOfClass:DTLinkBlankController.class]) {
        [(DTLinkBlankController *)controller didBlock];
        return;
    }
    [WCControllerUtil pushViewController:controller popOne:popOne];
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    if (!url) {
        return NO;
    }
    return [self openWithLink:url.absoluteString];
}

@end


@interface DTLinkBlankController ()
{
    
}

@end

@implementation DTLinkBlankController

+ (DTLinkBlankController *)controller
{
    return [self controllerWithBlock:nil];
}

+ (DTLinkBlankController *)controllerWithBlock:(DTCommonBlock)block
{
    return [self controllerWithBlock:block userInfo:nil];
}

+ (DTLinkBlankController *)controllerWithBlock:(DTCommonBlock)block userInfo:(id)userInfo
{
    DTLinkBlankController *vc = [[self alloc] init];
    vc.block = block;
    vc.userInfo = userInfo;
    return vc;
}

+ (DTLinkBlankController *)controllerWithBlock:(DTIntBlock)block index:(NSInteger)index
{
    DTLinkBlankController *vc = [[self alloc] init];
    vc.intBlock = block;
    vc.index = index;
    return vc;
}

+ (DTLinkBlankController *)controllerForUpgradeApp
{
    return [self controllerWithBlock:^(id userInfo) {
        
    }];
}

- (void)didBlock
{
    if (_block) {
        _block(self.userInfo);
        _block = nil;
    } else if (_intBlock) {
        _intBlock(self.index);
        _intBlock = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self didBlock];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count]>1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
