//
//  JTWebViewController.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/11.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTWebViewController.h"

@interface JTWebViewController () {
    NSString *_rightJumpUrl;
}

@end

@implementation JTWebViewController

- (void)rightItemAction
{
    [JTLinkUtil openWithLink:_rightJumpUrl];
}

- (BOOL)checkWebViewScheme:(NSString *)urlStr
{
    // 强制当前页打开
    if ([urlStr rangeOfString:@"://webview/back"].length) {
        [self backAction];
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/close"].length) {
        [super backAction];
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/login"].length) {
        
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/logout"].length) {
        [JTUserManager logoutAction:^{
            
        }];
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/loading"].length) {
        NSString *message = [urlStr getUrlParamValueForkey:@"message"];
        NSInteger type = [urlStr getUrlParamIntForkey:@"type"];
        BOOL stop = [urlStr getUrlParamBoolForkey:@"stop"];
        if (stop) {
            [DTPubUtil stopHUDLoading];
            [self stopLoadingIndicator];
        } else {
            if (type == 0) {
                [DTPubUtil startHUDLoading:message];
                [DTPubUtil stopHUDLoading:10];
            } else {
                [self startLoadingIndicator];
                [self stopLoadingIndicatorByDelay:10];
            }
        }
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/rightBarItem"].length) {
        if (![JTUserManager sharedInstance].isApplePhone) {
            NSString *title = [urlStr getUrlParamValueForkey:@"title"];
            if (title.length) {
                _rightJumpUrl = [urlStr getUrlParamValueForkey:@"url"];
                [self setRightBarItem:[WCBarItemUtil barButtonItemWithTitle:title target:self action:@selector(rightItemAction)]];
            } else {
                _rightJumpUrl = nil;
                [self setRightBarItem:nil];
            }
        }
        return YES;
    }
    return NO;
}

- (BOOL)checkAppLinkScheme:(NSString *)urlStr
{
    BOOL popOne = [urlStr getUrlParamBoolForkey:@"jt_popone"];
    BOOL needPush = [urlStr getUrlParamBoolForkey:@"jt_push"];
    UIViewController *vc = [JTLinkUtil getControllerWithLink:urlStr forcePush:self.forcePush || popOne || needPush];
    if (vc) {
        [JTLinkUtil checkOpenController:vc withLink:urlStr popOne:popOne];
        return YES;
    }
    return NO;
}

@end
