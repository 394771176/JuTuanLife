//
//  JTMainController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMainController.h"
#import "JTHomeController.h"
#import "JTShipHomeController.h"
#import "JTTaskHomeController.h"
#import "JTMineHomeController.h"

@interface JTMainController () <DTTabBarViewDelegate> {
    DTMainTabBarView *_mainTabBar;
    NSArray *_controllerList;
    NSArray *_titleList;
    
    NSInteger _markSelectIndex;
}

@end

@implementation JTMainController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [JTCommon setMainController:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfoForLaunch) name:JTUserManager_LAUNCH_REFRESH object:nil];
    }
    return self;
}

- (void)setupControllers
{
    JTHomeController *home = [[JTHomeController alloc] init];
    JTShipHomeController *ship = [[JTShipHomeController alloc] init];
    JTTaskHomeController *task = [[JTTaskHomeController alloc] init];
    JTMineHomeController *mine = [[JTMineHomeController alloc] init];
    
    _controllerList = @[home, ship, task, mine];
    
    WEAK_SELF
    [_controllerList enumerateObjectsUsingBlock:^(DTViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.superDTController = weakSelf;
    }];
}

- (void)setupMainTabBar
{
    _titleList = @[@"首页", @"师徒", @"任务",@"我的"];
    UICREATETo(_mainTabBar, DTMainTabBarView, 0, self.height - 50 - SAFE_BOTTOM_VIEW_HEIGHT, self.width, 50 + SAFE_BOTTOM_VIEW_HEIGHT, AAWT, self.view);
    _mainTabBar.delegate = self;
    _mainTabBar.fontSize = 12;
    [_mainTabBar setImages:@[@"main_tab_home", @"main_tab_ship", @"main_tab_task", @"main_tab_mine"]
                 selImages:@[@"main_tab_home_sel", @"main_tab_ship_sel", @"main_tab_task_sel", @"main_tab_mine_sel"]];
    [_mainTabBar setItems:_titleList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarItem:nil];
    [[self currentController] viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self currentController] viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self currentController] viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[self currentController] viewDidDisappear:animated];
}

//- (UIStatusBarStyle)statusBarStyle
//{
//    if (_selectedIndex == 0 || _selectedIndex == 3) {
//        return UIStatusBarStyleLightContent;
//    } else {
//        return UIStatusBarStyleDefault;
//    }
//}

- (BOOL)hiddenNavBar
{
    return _selectedIndex == 0 || _selectedIndex == 3;
}

- (void)viewDidLoad
{
    self.disableBackBtn = YES;
    
    [super viewDidLoad];
    
    [self setupControllers];
    [self setupMainTabBar];
    
    self.selectedIndex = 0;
}

- (DTViewController *)currentController
{
    return [_controllerList safeObjectAtIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (!_controllerList) {
        _markSelectIndex = selectedIndex;
        return;
    }
    if (selectedIndex >= _controllerList.count) {
        return;
    }
    
    UIViewController *oldController = [_controllerList safeObjectAtIndex:_selectedIndex];
    if (oldController.viewLoaded) {
        [[oldController view] removeFromSuperview];
    }
    
    _selectedIndex = selectedIndex;
    _mainTabBar.selectIndex = selectedIndex;
    
    if (_selectedIndex != 1) {
        [self setRightBarItem:nil];
    }
    
    UIViewController *controller = [_controllerList safeObjectAtIndex:_selectedIndex];
    [self.view insertSubview:controller.view belowSubview:_mainTabBar];
    controller.view.frame = CGRectMake(0, 0, self.view.width, self.view.height - _mainTabBar.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.title = [_titleList safeObjectAtIndex:_selectedIndex];
}

#pragma mark - Private Method

- (void)currentControllerScrollToTop
{
    UIViewController *controller = _controllerList[_selectedIndex];
    if ([controller respondsToSelector:@selector(currentController)]) {
        controller = [(DTTabViewController *)controller currentController];
    }
    
    if ([controller respondsToSelector:@selector(scrollToTop:)]) {
        [(DTTableController *)controller scrollToTop:YES];
    }
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    if (index == _selectedIndex) {
        [self currentControllerScrollToTop];
    } else {
        self.selectedIndex = index;
    }
}

#pragma mark - notice

- (void)refreshUserInfoForLaunch
{
    [self addBlockWhenFirstDidAppear:^(id userInfo) {
        [[JTUserManager sharedInstance] checkUserAuthStatus];
    }];
}

@end
