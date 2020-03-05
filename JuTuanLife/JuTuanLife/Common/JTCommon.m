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

+ (void)resetMainController
{
    JTMainController *mainC = [[JTMainController alloc] init];
    DTNavigationController *navC = [[DTNavigationController alloc] initWithRootViewController:mainC];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:window.bounds];
    imgView.image = [window captureView];
    window.rootViewController = navC;
    [window addSubview:imgView];
    [UIView animateWithDuration:0.25f animations:^{
        imgView.top = window.bottom;
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];
    }];
}

+ (BOOL)isServerPro
{
#if DEBUG
    return APP_SERVER_DEBUG == 0;
#endif
    return YES;
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
