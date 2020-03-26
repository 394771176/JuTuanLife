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
    if ([link containsString:@"://app/mainTab"]) {
        NSInteger index = [link getUrlParamIntForkey:@"index"];
        return [DTLinkBlankController controllerWithBlock:^(NSInteger num) {
            
        } index:index];
    }
    
    return nil;
}

@end
