//
//  DTHttpRefreshInsetTabController.m
//  DrivingTest
//
//  Created by cheng on 2020/2/4.
//  Copyright © 2020 eclicks. All rights reserved.
//

#import "DTHttpRefreshInsetTabController.h"
#import "WCUICommon.h"

NSString *const CONTENT_OFFSET = @"contentOffset";

@interface DTHttpRefreshInsetTabController () <DTTableControllerScrollDelegate> {
    NSMutableDictionary *_controllerDict;
    
    BOOL _mainTableCanScroll;
    BOOL _subTableCanScroll;
    
    NSMutableArray *_aspectArray;
}

@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) DTScrollTabView *tabBar;
@property (nonatomic, strong) DTControllerListView *scrollView;

//@property (nonatomic, strong) DTHttpRefreshTableController *topController;

@end

@implementation DTHttpRefreshInsetTabController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self removeControllerObserver];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.shouldRecognizeSimultaneouslyDT = YES;
    
    _tableFooterView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    _tableFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView = _tableFooterView;
    
    _mainTableCanScroll = YES;
    
    _tabBar = [[DTScrollTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    _tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabBar.tDelegate = self;
    _tabBar.items = self.titles;
    [_tableFooterView addSubview:_tabBar];
    
    _scrollView = [[DTControllerListView alloc] initWithFrame:CGRectMake(0, _tabBar.bottom, self.view.width, self.view.height - _tabBar.bottom)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
    _scrollView.controllerList = self.controllers;
    [_tableFooterView insertSubview:_scrollView belowSubview:_tabBar];
    
    self.tableView.anotherTable = [self currentControllerTable];
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    if (_tabBar) {
        _tabBar.items = self.titles;
    }
}

- (void)setControllers:(NSArray *)controllers
{
    _controllers = controllers;
    WEAK_SELF
    [_controllers enumerateObjectsUsingBlock:^(DTTableController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf setupControllerItem:obj];
    }];
    if (_scrollView) {
        _scrollView.controllerList = controllers;
    }
}

- (NSString *)currentTitle
{
    return [_titles safeObjectAtIndex:_selectedIndex];
}

- (UIViewController *)currentController
{
    return [_scrollView itemWithIndex:self.selectedIndex];
}

- (DTTableController *)currentTableController
{
    DTTableController *vc = (id)[self currentController];
    if ([vc isKindOfClass:DTTableController.class]) {
        return vc;
    }
    return nil;
}

- (UITableView *)currentControllerTable
{
    return [self currentTableController].tableView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    if (_tabBar.selectIndex != selectedIndex) {
        _tabBar.selectIndex = selectedIndex;
    }
    if (_scrollView.selectedIndex != selectedIndex) {
        _scrollView.selectedIndex = selectedIndex;
    }
    
    self.tableView.anotherTable = [self currentControllerTable];
    
    if (!_subTableCanScroll) {
        [self checkSubContentOffset:[self currentControllerTable]];
    }
}

- (UIViewController *)createControllerForIndex:(NSInteger)index
{
    return nil;
}

- (DTListDataModel *)createDataModel
{
    return nil;
}

- (void)refresh
{
    [super refresh];
    
    if ([[self currentController] respondsToSelector:@selector(refresh)]) {
        [[self currentController] performSelector:@selector(refresh)];
    }
}

- (void)reloadData
{
    [super reloadData];
}

- (void)reloadTableView
{
    [super reloadTableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - DTPullRefreshHeadViewDelegate

- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(DTPushRefreshHeadView *)view
{
    if ([[self currentController] respondsToSelector:@selector(pullRefreshTableHeaderDataSourceIsLoading:)]) {
        return [(DTHttpRefreshTableController *)[self currentController] pullRefreshTableHeaderDataSourceIsLoading:view] && [super pullRefreshTableHeaderDataSourceIsLoading:view];
    }
    return [super pullRefreshTableHeaderDataSourceIsLoading:view];
}

- (void)currentControllerScrollToTop:(BOOL)animation
{
    UIViewController *controller = [self currentController];
    if ([controller isKindOfClass:[DTTableController class]]) {
        [(DTTableController *)controller scrollToTop:animation];
    }
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    if (_selectedIndex == index) {
        [self currentControllerScrollToTop:YES];
    }
    [self setSelectedIndex:index];
}

#pragma mark - DTControllerListViewDelegate

- (NSInteger)controllerListViewCountForItems:(DTControllerListView *)view
{
    return self.titles.count;
}

- (void)controllerListView:(DTControllerListView *)view didSelectedIndex:(NSInteger)selectedIndex
{
    self.tableView.scrollEnabled = YES;
    [self setSelectedIndex:selectedIndex];
}

- (void)controllerListView:(DTControllerListView *)view didScrollView:(UIScrollView *)scrollView
{
    self.tableView.scrollEnabled = NO;
    [_tabBar setSelectedLineMoveWithScorllView:scrollView];
}

- (UIViewController *)controllerListView:(DTControllerListView *)view controllerForIndex:(NSInteger)selectedIndex
{
    id vc = [_controllerDict objectForKey:@(selectedIndex)];
    if (!vc) {
        if (!_controllerDict) {
            _controllerDict = [NSMutableDictionary dictionary];
        }
        vc = [self createControllerForIndex:selectedIndex];
        [self setupControllerItem:vc];
        [_controllerDict safeSetObject:vc forKey:@(selectedIndex)];
    } else {
        if (selectedIndex != _selectedIndex && !_subTableCanScroll) {
            if ([vc isKindOfClass:DTTableController.class]) {
                [self checkSubContentOffset:[(DTTableController *)vc tableView]];
            }
        }
    }
    return vc;
}

#pragma mark -

- (void)setupControllerItem:(DTTableController *)controller
{
    if ([controller isKindOfClass:DTViewController.class]) {
        controller.superDTController = self;
    }
    
    if ([controller isKindOfClass:DTTableController.class]) {
        [controller view];
        
//        DTHttpRefreshInsetTabTableRoute *route = [DTHttpRefreshInsetTabTableRoute proxyWithTarget:controller];
//        route.userInfo = self;
//        controller.tableView.delegate = route;
        
//        [controller.tableView addObserver:self forKeyPath:CONTENT_OFFSET options:NSKeyValueObservingOptionNew context:NULL];
        
//        [controller replaceMethod:@selector(scrollViewDidScroll:) toTarget:self replace:@selector(subscrollViewDidScroll:)];
        
//        id asp = [controller aspect_hookSelector:@selector(scrollViewDidScroll:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
//            [self subscrollViewDidScroll:aspectInfo.arguments[0]];
//        } error:NULL];
//
//        if (!_aspectArray) {
//            _aspectArray = [NSMutableArray array];
//        }
//        [_aspectArray safeAddObject:asp];
        
        controller.tableScrollDelegate = self;
    }
}

- (void)removeControllerObserver
{
//    if (_aspectArray) {
//        [_aspectArray enumerateObjectsUsingBlock:^(id<AspectToken> obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj respondsToSelector:@selector(remove)]) {
//                [obj remove];
//            }
//        }];
//        [_aspectArray removeAllObjects];
//        _aspectArray = nil;
//    }
    
//    if (_controllers.count) {
//        [_controllers enumerateObjectsUsingBlock:^(DTTableController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj.tableView removeObserver:self forKeyPath:CONTENT_OFFSET];
//        }];
//    } else if (_controllerDict.count) {
//        [_controllerDict.allValues enumerateObjectsUsingBlock:^(DTTableController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj.tableView removeObserver:self forKeyPath:CONTENT_OFFSET];
//        }];
//    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:CONTENT_OFFSET]) {
        if (object == self.tableView) {
//            [self checkMainContentOffset];
        } else {
//            [self checkSubContentOffset:object];
        }
    }
}

- (void)checkSubContentOffset:(UITableView *)table
{
//    CGFloat y1 = self.tableView.contentOffset.y;
    
    CGFloat y2 = table.contentOffset.y;
    if (y2 <= 0) {
        if (!CGFloatEqualToFloat(y2, 0)) {
            [table setContentOffset:CGPointZero];
        }
        _mainTableCanScroll = YES;
    } else {
        _mainTableCanScroll = NO;

        if (!_subTableCanScroll) {
            if (!CGFloatEqualToFloat(y2, 0)) {
                [table setContentOffset:CGPointZero];
            }
        }
    }
}

//- (void)checkMainContentOffset
//{
//    DTTableController *vc = (id)[self currentController];
//
//    if ([vc isKindOfClass:DTTableController.class]) {
//        if (self.tableView.contentOffset.y < _tableFooterView.top) {
//            _subtableCanScroll = NO;
//        } else {
//            _subtableCanScroll = YES;
//        }
//    }
//}

- (void)tableController:(DTTableController *)controller scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y2 = scrollView.contentOffset.y;
    if (y2 <= 0) {
        [scrollView setContentOffset:CGPointZero];
        _mainTableCanScroll = YES;
    } else {
        _mainTableCanScroll = NO;
    
        if (!_subTableCanScroll) {
            _mainTableCanScroll = YES;
            [scrollView setContentOffset:CGPointZero];
        }
    }
//    self.tableView.shouldRecognizeSimultaneously = _mainTableCanScroll;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    CGFloat y1 = scrollView.contentOffset.y;
    
    if (y1 >= _tableFooterView.top) {
        [scrollView setContentOffset:CGPointMake(0, _tableFooterView.top)];
        _subTableCanScroll = YES;
    } else {
        _subTableCanScroll = NO;
        
        if (!_mainTableCanScroll) {
            _subTableCanScroll = YES;
            [scrollView setContentOffset:CGPointMake(0, _tableFooterView.top)];
        }
    }
}

@end
