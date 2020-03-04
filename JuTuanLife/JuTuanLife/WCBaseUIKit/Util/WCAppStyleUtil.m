//
//  WCAppStyleUtil.m
//  Pods
//
//  Created by cheng on 2020/3/1.
//

#import "WCAppStyleUtil.h"
#import "WCUICommon.h"

#define APP_CONST_NAVBAR_BGCOLOR             @"ffffff"
#define APP_CONST_NAVBAR_TITLECOLOR          @"111111"
#define APP_CONST_BASE_CONTROLLER_BGCOLOR          @"ffffff"

@implementation WCAppStyleUtil

static WCAppStyleConfig *_config = nil;

+ (void)setAppStyleConfig:(WCAppStyleConfig *)config
{
    _config = config;
}

+ (WCAppStyleConfig *)config
{
    if (!_config) {
        _config = [WCAppStyleConfig defaultItem];
    }
    return _config;
}

+ (UIStatusBarStyle)statusBarStyle
{
    return UIStatusBarStyleDefault;
}

+ (UIColor *)navBarTitleColor
{
    return [UIColor colorWithHexString:APP_CONST_NAVBAR_TITLECOLOR];
}

+ (UIFont *)navBarTitleFont
{
    return [UIFont boldSystemFontOfSize:18];
}

+ (UIColor *)navBarItemColor
{
    return [UIColor colorWithHexString:APP_CONST_NAVBAR_TITLECOLOR];
}

+ (UIFont *)navBarItemFont
{
    return [UIFont systemFontOfSize:17];
}

+ (UIColor *)navBarBackgroundColor
{
    return [UIColor colorWithHexString:APP_CONST_NAVBAR_BGCOLOR];
}

+ (UIColor *)baseControllerBackgroundColor
{
    return [UIColor colorWithHexString:APP_CONST_BASE_CONTROLLER_BGCOLOR];
}

+ (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return _config.appInterfaceOrientations;
}

+ (void)setAppSupportedInterfaceOrientations:(UIInterfaceOrientationMask)orientations
{
    _config.appInterfaceOrientations = orientations;
}

@end

@implementation WCAppStyleConfig

+ (WCAppStyleConfig *)defaultItem
{
    WCAppStyleConfig *item = [WCAppStyleConfig new];
    item.appInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    return item;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
