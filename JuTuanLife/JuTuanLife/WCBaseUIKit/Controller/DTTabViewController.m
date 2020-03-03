//
//  CWTabViewController.m
//  ChelunWelfare
//
//  Created by cheng on 15/1/22.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import "DTTabViewController.h"
#import "DTTableController.h"

@interface DTTabViewController () {
    
}

@end

@implementation DTTabViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedLineWidth = 65;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabView];
    [self.view addSubview:_tabBar];
    
    if (_selectedLineWidth>0) {
        [_tabBar setSelectedLineWidth:_selectedLineWidth];
    }
    
    CGFloat top = (_hiddenTab?0.f:_tabBar.bottom);
    _scrollView = [[DTHorizontalScrollView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height-top)];
    _scrollView.horizontalDataSource = self;
    _scrollView.horizontalDelegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.scrollsToTop = NO;
    _scrollView.nonreusable = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    self.scrollGap = _scrollGap;
    
    [_scrollView setCurrentIndex:_selectedIndex];
    
    if(_titleList.count <= 1){
        [self setHiddenTab:YES];
    }
}

- (void)createTabView
{
    if (_tabBarScroll) {
        DTScrollTabView *tabBar = [[DTScrollTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
        tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tabBar.tDelegate = self;
        tabBar.selectIndex = _selectedIndex;
        _tabBar = (id)tabBar;
        return;
    }
    _tabBar = [[DTTabBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45) withItems:_titleList];
    _tabBar.delegate = self;
    _tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabBar.backgroundColor = [UIColor whiteColor];
    _tabBar.selectIndex = _selectedIndex;
}

- (void)setControllerList:(NSArray *)controllerList
{
    _controllerList = controllerList;
    for (DTViewController *controller in _controllerList) {
        if ([controller respondsToSelector:@selector(setSuperDTController:)]) {
            [controller setSuperDTController:self];
        }
    }
}

- (NSString *)pageName
{
    return [self.titleList safeObjectAtIndex:self.selectedIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self currentController] viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self currentController] viewDidAppear:animated];
    WEAK_SELF
    [_controllerList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTTableController class]]) {
            [(DTTableController *)obj setTableViewScrollToTop:idx==weakSelf.selectedIndex];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self currentController] viewWillDisappear:animated];
}

- (void)setHiddenTab:(BOOL)hiddenTab
{
    _hiddenTab = hiddenTab;
    _tabBar.hidden = hiddenTab;
    CGFloat top = (_hiddenTab?0.f:_tabBar.bottom);
    _scrollView.frame = CGRectMake(0, top, self.view.width, self.view.height-top);
}

- (void)setUnScroll:(BOOL)unScroll
{
    _unScroll = unScroll;
    if (_scrollView) {
        [_scrollView reloadData];
    }
}

- (void)setScrollGap:(CGFloat)scrollGap
{
    _scrollGap = scrollGap;
    if (_scrollView) {
        _scrollView.gap = scrollGap;
        _scrollView.frame = CGRectMake(-scrollGap, _scrollView.top, self.view.width+scrollGap*2, _scrollView.height);
        [_scrollView reloadData];
    }
}

- (DTViewController *)currentController
{
    if (_selectedIndex<_controllerList.count) {
        return [_controllerList safeObjectAtIndex:_selectedIndex];
    }
    return nil;
}

- (void)setselectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex!=selectedIndex) {
        [self setCurrentControllerCanScrollToTop:NO];
    }
    NSInteger markIndex = _selectedIndex;
    _selectedIndex = selectedIndex;
    if (markIndex!=_selectedIndex) {
        DTViewController *controller = [_controllerList safeObjectAtIndex:markIndex];
        [controller viewWillDisappear:YES];
        
        controller = [_controllerList safeObjectAtIndex:_selectedIndex];
        [controller viewWillAppear:YES];
    }
    if (_tabBar.selectIndex!=selectedIndex&&_selectedIndex<_titleList.count){
        _tabBar.selectIndex = selectedIndex;
    }
    if (_scrollView.currentIndex!=selectedIndex&&selectedIndex<_controllerList.count) {
        [_scrollView setCurrentIndex:selectedIndex];
    }
    
    if (markIndex!=_selectedIndex) {
        DTViewController *controller = [_controllerList safeObjectAtIndex:markIndex];
        [controller viewDidDisappear:YES];
        
        controller = [_controllerList safeObjectAtIndex:_selectedIndex];
        [controller viewDidAppear:YES];
    }
    
    [self setCurrentControllerCanScrollToTop:YES];
}

- (void)setselectedIndex:(NSInteger)selectedIndex event:(BOOL)event
{
    self.selectedIndex = selectedIndex;
}

- (void)reloadData
{
    [_tabBar setItems:_titleList];
    [_scrollView reloadData];
}

#pragma mark - BPHorizontalScrollViewDelegate

- (NSInteger)numberOfItems
{
    if (_unScroll) {
        return 1;
    }
    return _controllerList.count;
}

- (DTHorizontalScrollItemView *)horizontalScrollView:(DTHorizontalScrollView *)scroller itemViewForIndex:(NSInteger)index
{
    DTScrollControllerView *itemView = [[DTScrollControllerView alloc] initWithFrame:scroller.bounds];
    itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    itemView.gap = scroller.gap;
    if (index==_selectedIndex||_preLoad) {
        DTViewController *controller = [_controllerList safeObjectAtIndex:index];
        itemView.controller = controller;
    }
    return itemView;
}

- (void)horizontalScrollView:(DTHorizontalScrollView *)scroller didselectedIndex:(NSInteger)index
{
    [self setselectedIndex:index event:YES];
}

- (void)horizontalScrollViewDidScroll:(DTHorizontalScrollView *)scroller
{
    CGPoint point = CGPointMake(0, 0);
    point = [[[UIApplication sharedApplication].delegate window] convertPoint:point fromView:self.view];
    
    //滑动返回 问题处理
    if (point.x>0.1) {
        scroller.contentOffset = CGPointMake(scroller.width*scroller.currentIndex, scroller.contentOffset.y);
    }
    if (!_preLoad) {
        if (scroller.contentOffset.x>scroller.width*_selectedIndex) {
            DTScrollControllerView *itemView = (id)[scroller itemViewAtIndex:_selectedIndex+1];
            if(itemView&&_selectedIndex+1<_controllerList.count) {
                UIViewController *controller = [_controllerList safeObjectAtIndex:_selectedIndex+1];
                itemView.controller = controller;
            }
        } else if (scroller.contentOffset.x<scroller.width*_selectedIndex) {
            DTScrollControllerView *itemView = (id)[scroller itemViewAtIndex:_selectedIndex-1];
            if(itemView&&_selectedIndex-1>=0) {
                UIViewController *controller = [_controllerList safeObjectAtIndex:_selectedIndex-1];
                itemView.controller = controller;
            }
        }
        DTScrollControllerView *itemView = (id)[scroller itemViewAtIndex:_selectedIndex];
        if(itemView) {
            UIViewController *controller = [_controllerList safeObjectAtIndex:_selectedIndex];
            itemView.controller = controller;
        }
    }
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidselectIndex:(NSInteger)index
{
    if (_selectedIndex==index) {
        [self currentControllerScrollToTop:YES];
    }
    [self setselectedIndex:index event:YES];
}

- (void)currentControllerScrollToTop:(BOOL)animation
{
    UIViewController *controller = [self currentController];
    if ([controller isKindOfClass:[DTTableController class]]) {
        [(DTTableController *)controller scrollToTop:animation];
    }
}

- (void)setCurrentControllerCanScrollToTop:(BOOL)top
{
    UIViewController *controller = [self currentController];
    if ([controller isKindOfClass:[DTTableController class]]) {
        [(DTTableController *)controller setTableViewScrollToTop:top];
    }
}

@end

@implementation DTScrollControllerView

- (void)viewDidShow
{
    
}

- (void)setController:(UIViewController *)controller
{
    if (controller==_controller&&controller.view.superview==self) {
        return;
    }
    _controller = controller;
    if (controller.view.superview != self) {
        [self removeAllSubviews];
        [controller.view removeFromSuperview];
        controller.view.frame = CGRectMake(_gap, 0, self.width-_gap*2, self.height);
        controller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:controller.view];
    }
    
}

@end
