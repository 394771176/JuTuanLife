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

+ (DTWebViewController *)getWebControllerWith:(NSString *)link
{
    return [super getWebControllerWith:link];
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

@end
