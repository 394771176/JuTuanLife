//
//  DTTabScorllContentCell.m
//  DrivingTest
//
//  Created by cheng on 2018/8/7.
//  Copyright © 2018年 eclicks. All rights reserved.
//

#import "DTTabScorllContentCell.h"
//#import "DTViewController.h"

@interface DTTabScorllContentCell () <
DTTabBarViewDelegate,
//DTHorizontalScrollViewDelegate, DTHorizontalScrollViewDataSource,
DTControllerListViewDelegate> {
    NSMutableDictionary *_reuseCells;
    
    BOOL _isClickTab;
}

@end

@implementation DTTabScorllContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _reuseCells = [NSMutableDictionary dictionary];
        
        _tabBarAsHeader = YES;
        
        _tabBar = [[DTScrollTabView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 44)];
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tabBar.tDelegate = self;
        [self.contentView addSubview:_tabBar];
        
        _scrollView = [[DTControllerListView alloc] initWithFrame:CGRectMake(0, _tabBar.bottom, self.contentView.width, 100)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _scrollView.delegate = self;
        [self.contentView insertSubview:_scrollView belowSubview:_tabBar];
        
        _lastIndex = -1;
        _selectedIndex = 0;
        
        [self setSelectionStyleNone];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)idForIndex:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(tabScorllContentCell:identifierForIndex:)]) {
        return [_delegate tabScorllContentCell:self identifierForIndex:index];
    }
    return nil;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    _tabBar.items = titles;
    _scrollView.num = titles.count;
    [_scrollView reloadData];
    if (titles.count <=1) {
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _tableView.height);
        _tabBar.height = 0;
        _tabBar.hidden = YES;
    }else{
        _tabBar.height = 44;
        _tabBar.hidden = NO;
        _scrollView.frame = CGRectMake(0, 44, SCREEN_WIDTH, _tableView.height-44);
    }
    self.selectedIndex = _selectedIndex;
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _scrollView.height = _tableView.height - _tabBar.height;
}


- (id)currentTitleItem
{
    return [_titles safeObjectAtIndex:_selectedIndex];
}

- (id<DTTabScorllContentItemViewDelegate>)currentContentView
{
    return [_scrollView itemWithIndex:_selectedIndex];
}

- (NSString *)currentTitleString
{
    return [_tabBar titleWithIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _lastIndex = _selectedIndex;
    _selectedIndex = selectedIndex;
    if (_tabBar.selectIndex != selectedIndex) {
        _tabBar.selectIndex = selectedIndex;
    } else {
        _tabBar.selectIndex = selectedIndex;
    }
    
    if (_scrollView.selectedIndex != selectedIndex) {
        _scrollView.selectedIndex = selectedIndex;
    }
    
    id<DTTabScorllContentItemViewDelegate> contentView = [self currentContentView];
    if (self.tableView.contentOffset.y < self.top) {
        _tabBar.top = 0;
        _scrollView.top = _tabBar.height;
        [contentView tabScorllContentItemViewSetContentOffsetY:0];
    } else {
        CGFloat offset = [contentView tabScorllContentItemViewContentOffsetY];
        if (self.top + offset + _tableView.height > self.tableView.contentSize.height)
        {
            CGFloat height = [contentView tabScorllContentItemViewContentSize].height + _tabBar.height;
            height = MAX(_tableView.height, height);
            self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, height + self.top);
            self.height = self.contentView.height = height;
        }
        self.tableView.contentOffset = CGPointMake(0, offset + self.top);
        NSLog(@"gaodu:%lf",self.contentView.height - _scrollView.height);
        _scrollView.top = MIN(offset + _tabBar.height, self.contentView.height - _scrollView.height);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(tabScorllContentCell:updateView:withIndex:)]) {
        [_delegate tabScorllContentCell:self updateView:contentView withIndex:selectedIndex];
    }
}


- (void)reloadData
{
    [_scrollView reloadData];
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView
{
    id<DTTabScorllContentItemViewDelegate> contentView = [self currentContentView];
    if (scrollView.contentOffset.y <= self.top) {
        _tabBar.top = 0;
        _scrollView.top = _tabBar.height;
        [contentView tabScorllContentItemViewSetContentOffsetY:0];
    } else {
        CGFloat offset = scrollView.contentOffset.y - self.top;
        _tabBar.top = offset;
        _scrollView.top = MIN(offset + _tabBar.height, self.contentView.height - _scrollView.height);
        [contentView tabScorllContentItemViewSetContentOffsetY:offset];
    }
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    if (_selectedIndex == index) {
        [self.tableView setContentOffset:CGPointMake(0, self.top) animated:YES];
        return;
    }
    self.selectedIndex = index;
}

#pragma mark - DTControllerListViewDelegate

- (UIViewController *)controllerListView:(DTControllerListView *)view controllerForIndex:(NSInteger)selectedIndex
{
    id<DTTabScorllContentItemViewDelegate> itemView = [_delegate tabScorllContentCell:self viewForIndex:selectedIndex];
    if ([itemView respondsToSelector:@selector(tabScorllContentItemViewSetTableViewUnableScroll)]) {
        [itemView tabScorllContentItemViewSetTableViewUnableScroll];
    }
    return (id)itemView;
}

- (void)controllerListView:(DTControllerListView *)view didSelectedIndex:(NSInteger)selectedIndex
{
    self.selectedIndex = selectedIndex;
}

- (void)controllerListView:(DTControllerListView *)view didScrollView:(UIScrollView *)scrollView
{
    [_tabBar setSelectedLineMoveWithScorllView:scrollView];
}

+ (CGFloat)cellHeightWithItem:(DTTabScorllContentCell *)item tableView:(UITableView *)tableView
{
    UIView<DTTabScorllContentItemViewDelegate> *view = [item currentContentView];
    CGFloat height = [view tabScorllContentItemViewContentSize].height + 44;
    NSLog(@"cell高度：%lf",MAX(height, tableView.height));
    return MAX(height, tableView.height);
}

@end


@interface DTTabScorllContentItemView () {
    
}

@end

@implementation DTTabScorllContentItemView



@end
