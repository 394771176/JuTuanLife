//
//  DTViewController.m
//  DrivingTest
//
//  Created by Huang Tao on 1/22/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "DTViewController.h"
#import "WCUICommon.h"

@interface DTViewController () {
    NSMutableArray<DTCommonBlock> *_blockListForDidAppear;
}

@property (nonatomic, assign) BOOL hadViewDidAppear;

@end

@implementation DTViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ 释放。。。", NSStringFromClass([self class]));
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (UINavigationItem *)navigationItem
{
    if (_superDTController) {
        return [_superDTController navigationItem];
    }
    return [super navigationItem];
}

- (UINavigationController *)navigationController
{
    if (_superDTController) {
        return [_superDTController navigationController];
    }
    return [super navigationController];
}

- (UIStatusBarStyle)statusBarStyle
{
    if (_superDTController) {
        return [_superDTController statusBarStyle];
    }
    return [WCAppStyleUtil statusBarStyle];
}

- (BOOL)hiddenNavBar
{
    if (_superDTController) {
        return [_superDTController hiddenNavBar];
    }
    return NO;
}

- (BOOL)hiddenStatusBar
{
    if (_superDTController) {
        return [_superDTController hiddenStatusBar];
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2" alpha:1];
    self.view.clipsToBounds = YES;
    
    if (!self.disableBackBtn && !_superDTController) {
        [self setLeftBackBarItem];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (![self hiddenStatusBar]) {
        [[UIApplication sharedApplication] setStatusBarStyle:[self statusBarStyle] animated:animated];
    }
    
    [self.navigationController setNavigationBarHidden:[self hiddenNavBar] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(checkViewFirstDidAppear) withObject:nil afterDelay:0.01f];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIViewController *controller = [self getCurrentVisibleViewController];
    //下一个界面 不响应我们的方法，且当前界面做了调整，需要主动恢复
    if (controller && ![controller respondsToSelector:@selector(hiddenStatusBar)] && [self hiddenStatusBar]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    if (controller && ![controller respondsToSelector:@selector(statusBarStyle)] && [self statusBarStyle] != [WCAppStyleUtil statusBarStyle]) {
        [[UIApplication sharedApplication] setStatusBarStyle:[WCAppStyleUtil statusBarStyle] animated:animated];
    }
    if (self.navigationController.presentedViewController == nil && (controller && ![controller respondsToSelector:@selector(hiddenNavBar)]) && [self hiddenNavBar]) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIViewController *)getCurrentVisibleViewController
{
    UIViewController *controller = self.navigationController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)controller visibleViewController];
    }
    return controller;
}

#pragma mark - first Appear

- (void)checkViewFirstDidAppear
{
    if (!_hadViewDidAppear) {
        _hadViewDidAppear = YES;
        [self viewDidFirstAppear];

        if (_blockListForDidAppear.count) {
            WEAK_SELF
            [_blockListForDidAppear enumerateObjectsUsingBlock:^(DTCommonBlock block, NSUInteger idx, BOOL * _Nonnull stop) {
                block(weakSelf);
            }];
            [_blockListForDidAppear removeAllObjects];
            _blockListForDidAppear = nil;
        }
    }
}

- (void)viewDidFirstAppear
{
    //doing some thing in subclass
}

- (void)addBlockWhenFirstDidAppear:(DTCommonBlock)block
{
    if (block) {
        if (_hadViewDidAppear) {
            block(self);
        } else {
            if (!_blockListForDidAppear) {
                _blockListForDidAppear = [NSMutableArray array];
            }
            [_blockListForDidAppear safeAddObject:block];
        }
    }
}

#pragma mark - barItem

- (void)setLeftBackBarItem
{
    if (self.navigationController.viewControllers.count>1) {
        [self setLeftBarItem:[WCBarItemUtil backBarButtonItemTarget:self action:@selector(backAction)]];
    } else {
        [self setLeftBarItem:[WCBarItemUtil closeBarButtonItemTarget:self action:@selector(backAction)]];
    }
}

- (void)setLeftBarItem:(UIBarButtonItem *)item
{
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setRightBarItem:(UIBarButtonItem *)item
{
    self.navigationItem.rightBarButtonItem = item;
}

- (void)realBackAction
{
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count]>1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)backAction
{
    [self realBackAction];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation==UIInterfaceOrientationPortrait;
}

#pragma mark - LoadingIndicator

- (BOOL)canShowLoadingIndicator
{
    if (_superDTController) {
        return [_superDTController canShowLoadingIndicator];
    }
    return YES;
}

- (void)startLoadingIndicator
{
    if ([self canShowLoadingIndicator]) {
        if (!_loadingView) {
            _loadingView = [DTDrivingLoadingView loadingInView:self.view];
        }
        [_loadingView startAnimating];
        _isShowLoadingIndicator = YES;
    } else {
        [self stopLoadingIndicator];
    }
}

- (void)stopLoadingIndicator
{
    if (_loadingView) {
        [_loadingView stopAnimating];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
    _isShowLoadingIndicator = NO;
}

- (void)startHUDLoading:(NSString *)text
{
    [DTPubUtil startHUDLoading:text addTo:self.navigationController.view];
}

- (void)stopHUDLoading
{
    [DTPubUtil stopHUDLoadingFromView:self.navigationController.view];
}

#pragma mark - safe bottom

- (void)addSafeBottomView
{
    [self addSafeBottomViewWithColor:self.safeBottomColor];
}

- (void)removeSafeBottomView
{
    if (_safeBottomView) {
        [_safeBottomView removeFromSuperview];
        _safeBottomView = nil;
    }
}

- (void)addSafeBottomViewWithColor:(UIColor *)color
{
    [self addSafeBottomViewWithColor:color iPhoneXBottomHeight:NO];
}

- (void)addSafeBottomViewWithColor:(UIColor *)color iPhoneXBottomHeight:(BOOL)iPhoneXBottomHeight
{
    if (![DTPubUtil isIPhoneX]) {
        return;
    }
    
    [self removeSafeBottomView];
    
    CGFloat height = iPhoneXBottomHeight ? SAFE_IPHONEX_BOTTOM_HEIGHT : SAFE_BOTTOM_VIEW_HEIGHT;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-height, self.view.width, height)];
    view.backgroundColor = color;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    view.userInteractionEnabled = NO;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    _safeBottomView = view;
}

- (void)addSafeBottomViewWithColor:(UIColor *)color fixHeight:(CGFloat)height
{
    [self addSafeBottomViewWithColor:color];
    _safeBottomView.frame = CGRectMake(0, self.view.height-height, self.view.width, height);
}

@end
