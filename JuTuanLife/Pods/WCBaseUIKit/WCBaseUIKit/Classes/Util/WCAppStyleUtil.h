//
//  WCAppStyleUtil.h
//  Pods
//
//  Created by cheng on 2020/3/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

+ (UIInterfaceOrientationMask)supportedInterfaceOrientations;

+ (void)setAppSupportedInterfaceOrientations:(UIInterfaceOrientationMask)orientations;

@end

@interface WCAppStyleConfig : NSObject

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property (nonatomic, strong) UIColor *navTitleColor;
@property (nonatomic, strong) UIFont *navTitleFont;

@property (nonatomic, strong) UIColor *navBgColor;

@property (nonatomic, strong) UIColor *navItemColor;
@property (nonatomic, strong) UIFont *navItemFont;

@property (nonatomic, strong) UIColor *baseControllerBgColor;

@property (nonatomic, assign) UIInterfaceOrientationMask appInterfaceOrientations;

+ (WCAppStyleConfig *)defaultItem;

@end

