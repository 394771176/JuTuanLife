//
//  JTCommon.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTCommon.h"

@implementation JTCommon

static id mainController = nil;

+ (void)setupAppStyle
{
    
    /*
     @property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
     
     @property (nonatomic, strong) UIColor *navTitleColor;
     @property (nonatomic, strong) UIFont *navTitleFont;
     
     @property (nonatomic, strong) UIColor *navBgColor;
     
     @property (nonatomic, strong) UIColor *navItemColor;
     @property (nonatomic, strong) UIFont *navItemFont;
     
     @property (nonatomic, strong) UIColor *baseControllerBgColor;
     */
    WCAppStyleConfig *config = [WCAppStyleConfig defaultItem];
//    config.statusBarStyle = UIStatusBarStyleDefault;
//    config.navTitleColor = COLOR(000000);
//    config.navTitleFont = [UIFont boldSystemFontOfSize:18];
//    config.navBgColor = [UIColor whiteColor];
//    config.navItemColor = COLOR(313131);
//    config.navItemFont = [UIFont systemFontOfSize:16];
//    config.baseControllerBgColor = [UIColor whiteColor];
    [WCAppStyleUtil setAppStyleConfig:config];
}

+ (void)setMainController:(JTMainController *)vc
{
    mainController = vc;
}

+ (JTMainController *)mainController
{
    return mainController;
}

+ (void)resetRootController
{
    UIViewController *vc = [JTUserManager rootController];
    DTNavigationController *navC = [[DTNavigationController alloc] initWithRootViewController:vc];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = navC;
    
    if ([vc isKindOfClass:JTMainController.class]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:window.bounds];
        imgView.image = [window captureView];
        [window addSubview:imgView];
        [UIView animateWithDuration:0.25f animations:^{
            imgView.top = window.bottom;
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
    } else {
        
    }
}

+ (BOOL)isServerPro
{
#ifdef DEBUG
    return APP_SERVER_DEBUG == 0;
#endif
    return YES;
}

+ (BOOL)APPDebug
{
#ifdef DEBUG
    return APP_CONST_DEBUG == 1;
#endif
    return NO;
}

+ (NSString *)serverForPro:(NSString *)pro test:(NSString *)test
{
    if ([self isServerPro]) {
        return pro;
    } else {
        return test;
    }
}



@end
