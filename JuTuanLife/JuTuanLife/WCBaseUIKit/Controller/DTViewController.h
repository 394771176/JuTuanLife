//
//  DTViewController.h
//  DrivingTest
//
//  Created by Huang Tao on 1/22/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTDrivingLoadingView.h"

#define viewTopWithoutNavBar (iOS(7)?20.0f:.0f)

@interface DTViewController : UIViewController {
    @protected
    DTDrivingLoadingView *_loadingView;
}

@property (nonatomic) BOOL disableBackBtn;
@property (nonatomic) BOOL disableBackGesture;
@property (nonatomic) BOOL hiddenNavBar;

@property (nonatomic, weak) id superDTController;

@property (nonatomic, readonly) BOOL isShowLoadingIndicator;

@property (nonatomic,strong) UIColor *safeBottomColor;
@property (nonatomic,strong) UIView  *safeBottomView;

#pragma mark - StatusBar、NavBar

- (UIStatusBarStyle)statusBarStyle;
- (BOOL)hiddenNavBar;
- (BOOL)hiddenStatusBar;

#pragma mark - first appear

- (void)viewDidFirstAppear;
- (void)addBlockWhenFirstDidAppear:(DTCommonBlock)block;

#pragma mark - barItem

- (void)setLeftBackBarItem;
- (void)setLeftBarItem:(UIBarButtonItem *)item;
- (void)setRightBarItem:(UIBarButtonItem *)item;

- (void)realBackAction;
- (void)backAction;

#pragma mark - Loading Indicator

- (BOOL)canShowLoadingIndicator;//default is YES
- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;

- (void)startHUDLoading:(NSString *)text;
- (void)stopHUDLoading;

#pragma mark - safe bottom

- (void)addSafeBottomView;
- (void)removeSafeBottomView;
- (void)addSafeBottomViewWithColor:(UIColor *)color;
- (void)addSafeBottomViewWithColor:(UIColor *)color iPhoneXBottomHeight:(BOOL)iPhoneXBottomHeight;
- (void)addSafeBottomViewWithColor:(UIColor *)color fixHeight:(CGFloat)height;

@end
