//
//  WCAppStyleUtil.h
//  Pods
//
//  Created by cheng on 2020/3/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define APP_CONST_NAVBAR_BGCOLOR                 @"ffffff"
#define APP_CONST_NAVBAR_TITLE_COLOR             @"111111"
#define APP_CONST_BASE_CONTROLLER_BGCOLOR        @"f2f2f2"

#define APP_CONST_CELL_SEL_BGCOLOR               @"eeeeee"
#define APP_CONST_CELL_LINE_COLOR                @"dcdcdc"

@class WCAppStyleConfig;

@interface WCAppStyleUtil : NSObject

+ (void)setAppStyleConfig:(WCAppStyleConfig *)config;

+ (WCAppStyleConfig *)config;

+ (UIStatusBarStyle)statusBarStyle;

+ (UIColor *)navBarTitleColor;

+ (UIFont *)navBarTitleFont;

+ (UIColor *)navBarItemColor;

+ (UIFont *)navBarItemFont;

+ (UIColor *)navBarBackgroundColor;

+ (UIColor *)baseControllerBackgroundColor;

+ (UIColor *)cellSelectedBackgroundColor;
+ (UIColor *)cellLineColor;

+ (UIInterfaceOrientationMask)supportedInterfaceOrientations;

+ (void)setAppSupportedInterfaceOrientations:(UIInterfaceOrientationMask)orientations;

@end

@interface WCAppStyleConfig : NSObject

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property (nonatomic, strong) UIColor *navTitleColor;
@property (nonatomic, strong) UIFont *navTitleFont;//default is bold 18

@property (nonatomic, strong) UIColor *navBgColor;

@property (nonatomic, strong) UIColor *navItemColor;
@property (nonatomic, strong) UIFont *navItemFont;//default is 16

@property (nonatomic, strong) UIColor *baseControllerBgColor;

@property (nonatomic, strong) UIColor *cellSelectedBgColor;
@property (nonatomic, strong) UIColor *cellLineColor;

@property (nonatomic, assign) UIInterfaceOrientationMask appInterfaceOrientations;

+ (WCAppStyleConfig *)defaultItem;

@end

