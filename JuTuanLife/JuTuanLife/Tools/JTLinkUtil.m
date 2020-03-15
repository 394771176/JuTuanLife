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

+ (DTViewController *)getControllerWithLink:(NSString *)link
{
    return nil;
}

+ (void)openLink:(NSString *)link
{
    DTViewController *vc = [self getControllerWithLink:link];
    if (vc) {
        [JTCommon pushViewController:vc];
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return NO;
}

@end
